import 'dart:developer';
import 'package:api_testing_app/core/models/api_response_model.dart';
import 'package:api_testing_app/core/network/api_constants.dart';
import 'package:api_testing_app/core/widgets/custom_snackbar.dart';
import 'package:api_testing_app/features/auth/services/auth_service.dart';
import 'package:api_testing_app/routes/app_navigator.dart';
import 'package:api_testing_app/routes/routes_name.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  final Dio dio = Dio();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  DioClient._internal() {
    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl, // Replace with your base URL
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
      headers: {'Content-Type': 'application/json'},
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await secureStorage.read(key: 'access_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // You can log or modify responses here
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          log('Dio error: ${e.type} → ${e.message}');

          final context = AppNavigator.navigatorKey.currentContext;

          if (e.response?.statusCode == 401 &&
              e.requestOptions.path != ApiConstants.refreshToken) {
            try {
              // Attempt to refresh the token

              final refreshToken = await secureStorage.read(
                key: 'refresh_token',
              );
              if (refreshToken == null) throw Exception('No refresh token');
              final authService = AuthService();
              final newTokens = await authService.refreshToken(refreshToken);
              await secureStorage.write(
                key: 'access_token',
                value: newTokens['accessToken'],
              );
              await secureStorage.write(
                key: 'refresh_token',
                value: newTokens['refreshToken'],
              );
              // Retry the original request with new token
              e.requestOptions.headers['Authorization'] =
                  'Bearer ${newTokens['accessToken']}';

              final response = await dio.fetch(e.requestOptions);
              return handler.resolve(response);
            } catch (refreshError) {
              log('Refresh token error: $refreshError');
              await secureStorage.deleteAll();
              if (context != null) {
                CustomSnackBar.show(
                  context,
                  'Session expired. Please log in again.',
                );
              }

              await Future.delayed(const Duration(seconds: 2));
              AppNavigator.navigatorKey.currentState?.pushNamedAndRemoveUntil(
                RouteNames.login,
                (route) => false,
              );
              return handler.reject(e); // Reject the original error
            }
          } else if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.unknown ||
              e.type == DioExceptionType.receiveTimeout ||
              e.message?.contains('SocketException') == true) {
            if (context != null) {
              CustomSnackBar.show(
                context,
                'No internet or server unreachable.',
              );
            }
          }
          return handler.next(e); // Let BLoC or UI decide what to do next
        },
      ),
    );
  }

  Future<ApiResponse<T>> safeRequest<T>({
    required Future<Response> Function() request,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await request();
      return ApiResponse.fromJson(response.data, parser);
    } on DioException catch (e) {
      log('Dio error: ${e.message}');

      String errorMessage = 'Something went wrong.';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        errorMessage = 'Unable to connect to the server. Check your internet.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred.';
      } else if (e.type == DioExceptionType.unknown) {
        errorMessage = 'Unknown error occurred.';
      }

      return ApiResponse<T>(
        success: false,
        message: errorMessage,
        data: null,
        statusCode: 500,
      );
    }
  }
}
