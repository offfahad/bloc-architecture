import 'package:api_testing_app/core/widgets/custom_snackbar.dart';
import 'package:api_testing_app/features/auth/bloc/auth_bloc.dart';
import 'package:api_testing_app/features/auth/bloc/auth_event.dart';
import 'package:api_testing_app/features/auth/bloc/auth_state.dart';
import 'package:api_testing_app/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onLoginPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      CustomSnackBar.show(context, 'Please enter a valid email');
      return;
    }

    if (password.isEmpty) {
      CustomSnackBar.show(context, 'Password is required');
      return;
    }

    context.read<AuthBloc>().add(LoginEvent(email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is AuthSuccess) {
            Navigator.pop(context); // Remove loader
            Navigator.pushReplacementNamed(
              context,
              RouteNames.dashboard,
              arguments: state.data.user,
            );
          } else if (state is AuthFailure) {
            Navigator.pop(context); // Remove loader
            CustomSnackBar.show(context, state.message);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onLoginPressed,
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        RouteNames.register,
                      );
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
