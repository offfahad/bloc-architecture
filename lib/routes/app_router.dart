import 'package:api_testing_app/core/models/user_model.dart';
import 'package:api_testing_app/features/auth/views/login_screen.dart';
import 'package:api_testing_app/features/auth/views/register_screen.dart';
import 'package:api_testing_app/features/auth/views/splash_screen.dart';
import 'package:api_testing_app/features/auth/views/verify_otp_screen.dart';
import 'package:api_testing_app/features/home/views/dashboard_screen.dart';
import 'package:api_testing_app/routes/routes_name.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case RouteNames.verifyOtp:
        final args = settings.arguments as Map<String, dynamic>;
        final email = args['email'] as String;
        final userId = args['userId'] as String;

        return MaterialPageRoute(
          builder: (_) => VerifyOtpScreen(email: email, userId: userId),
        );

      case RouteNames.dashboard:
        final user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (_) => DashboardScreen(userModel: user),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
