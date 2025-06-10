import 'package:api_testing_app/core/models/api_response_model.dart';
import 'package:api_testing_app/core/models/auth_data_model.dart';
import 'package:api_testing_app/features/auth/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Register user
  Future<ApiResponse<AuthDataModel>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String mobile,
  }) async {
    return await _authService.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      mobile: mobile,
    );
  }

  /// Verify OTP
  Future<ApiResponse<AuthDataModel>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await _authService.verifyOtp(email: email, otp: otp);
  }

  /// Login user and save tokens
  Future<ApiResponse<AuthDataModel>> login({
    required String email,
    required String password,
  }) async {
    final response = await _authService.login(email: email, password: password);
    if (response.success && response.data?.tokens != null) {
      await saveTokens(
        response.data!.tokens!.accessToken,
        response.data!.tokens!.refreshToken,
      );
    }
    return response;
  }

  /// Get current user profile
  Future<ApiResponse<AuthDataModel>> getMe() async {
    final response = await _authService.getMe();
    if (response.success && response.data?.tokens != null) {
      await saveTokens(
        response.data!.tokens!.accessToken,
        response.data!.tokens!.refreshToken,
      );
    }
    return response;
  }

  /// Update profile picture
  Future<ApiResponse<String>> updateProfilePicture(String url) async {
    return await _authService.updateProfilePicture(imageUrl: url);
  }

  /// Update password
  Future<ApiResponse<String>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await _authService.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  /// Securely save tokens
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  /// Clear all tokens
  Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  /// Check if token exists
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null && token.isNotEmpty;
  }

  /// Fetch access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }
}
