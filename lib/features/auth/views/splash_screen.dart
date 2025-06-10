import 'package:api_testing_app/features/auth/bloc/auth_bloc.dart';
import 'package:api_testing_app/features/auth/bloc/auth_event.dart';
import 'package:api_testing_app/features/auth/bloc/auth_state.dart';
import 'package:api_testing_app/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger getMe on splash start
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authBloc = context.read<AuthBloc>();
    final hasTokens = await _hasValidTokens();

    if (hasTokens) {
      authBloc.add(GetMeEvent());
    } else {
      Navigator.pushReplacementNamed(context, RouteNames.login);
    }
  }

  Future<bool> _hasValidTokens() async {
    final storage = const FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    final refreshToken = await storage.read(key: 'refresh_token');
    return accessToken != null && refreshToken != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(
              context,
              RouteNames.dashboard,
              arguments: state.data.user,
            );
          } else if (state is AuthFailure) {
            Navigator.pushReplacementNamed(context, RouteNames.login);
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is AuthLoading || state is AuthInitial)
                  const CircularProgressIndicator(),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to Bloc API Calling App',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
