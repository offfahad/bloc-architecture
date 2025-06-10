class ApiConstants {
  static const String baseUrl = 'http://localhost:3000/api/v1';

  // Auth
  static const String register = '$baseUrl/auth/register';
  static const String verifyOtp = '$baseUrl/auth/verify';
  static const String login = '$baseUrl/auth/login';
  static const String me = '$baseUrl/users/me';
  static const String refreshToken = '$baseUrl/auth/refresh-token';

  // User
  static const String updateProfilePicture =
      '$baseUrl/users/update-profile-picture';
  static const String updatePassword = '$baseUrl/users/update-password';
}
