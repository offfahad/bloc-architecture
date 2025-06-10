import 'package:api_testing_app/core/models/api_response_model.dart';
import 'package:api_testing_app/core/models/auth_data_model.dart';
import 'package:api_testing_app/core/network/api_constants.dart';
import 'package:api_testing_app/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = DioClient().dio;
  final DioClient _client = DioClient();

  /// Register
  Future<ApiResponse<AuthDataModel>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String mobile,
  }) {
    return _client.safeRequest(
      request:
          () => _dio.post(
            ApiConstants.register,
            data: {
              'firstName': firstName,
              'lastName': lastName,
              'email': email,
              'password': password,
              'mobile': mobile,
            },
          ),
      parser: (data) => AuthDataModel.fromJson(data),
    );
  }

  /// Verify OTP
  Future<ApiResponse<AuthDataModel>> verifyOtp({
    required String email,
    required String otp,
  }) {
    return _client.safeRequest(
      request:
          () => _dio.post(
            ApiConstants.verifyOtp,
            data: {'email': email, 'otp': otp},
          ),
      parser: (data) => AuthDataModel.fromJson(data),
    );
  }

  /// Login
  Future<ApiResponse<AuthDataModel>> login({
    required String email,
    required String password,
  }) {
    return _client.safeRequest(
      request:
          () => _dio.post(
            ApiConstants.login,
            data: {'email': email, 'password': password},
          ),
      parser: (data) => AuthDataModel.fromJson(data),
    );
  }

  /// Get Me
  Future<ApiResponse<AuthDataModel>> getMe() {
    return _client.safeRequest(
      request: () => _dio.get(ApiConstants.me),
      parser: (data) => AuthDataModel.fromJson(data),
    );
  }

  /// Update Profile Picture
  Future<ApiResponse<String>> updateProfilePicture({required String imageUrl}) {
    return _client.safeRequest(
      request:
          () => _dio.put(
            ApiConstants.updateProfilePicture,
            data: {'profilePicture': imageUrl},
          ),
      parser: (data) => data.toString(),
    );
  }

  /// Update Password
  Future<ApiResponse<String>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _client.safeRequest(
      request:
          () => _dio.put(
            ApiConstants.updatePassword,
            data: {
              'currentPassword': currentPassword,
              'newPassword': newPassword,
            },
          ),
      parser: (data) => data.toString(),
    );
  }

  Future<Map<String, String>> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      // Correct path to access tokens
      if (response.data['success'] != true) {
        throw Exception('success is not true for refresh token from api');
      }
      return {
        'accessToken': response.data['data']['accessToken'],
        'refreshToken': response.data['data']['refreshToken'],
      };
    } on DioException catch (e) {
      throw Exception(
        'Failed to refresh token: ${e.response?.data ?? e.message}',
      );
    }
  }
}
