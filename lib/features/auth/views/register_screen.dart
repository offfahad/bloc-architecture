import 'package:api_testing_app/features/auth/bloc/auth_bloc.dart';
import 'package:api_testing_app/features/auth/bloc/auth_event.dart';
import 'package:api_testing_app/features/auth/bloc/auth_state.dart';
import 'package:api_testing_app/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _password = TextEditingController();

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        RegisterEvent(
          firstName: _firstName.text.trim(),
          lastName: _lastName.text.trim(),
          email: _email.text.trim(),
          mobile: _mobile.text.trim(),
          password: _password.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthSuccess) {
            final user = state.data.user;
            Navigator.pushReplacementNamed(
              context,
              RouteNames.verifyOtp,
              arguments: {'email': user.email, 'userId': user.id},
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: _firstName,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                      ),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _lastName,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _mobile,
                      decoration: const InputDecoration(labelText: 'Mobile'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator:
                          (value) => value!.length < 6 ? 'Min 6 chars' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed:
                          state is AuthLoading ? null : () => _submit(context),
                      child: const Text("Register"),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              RouteNames.login,
                            );
                          },
                          child: const Text("Login"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (state is AuthLoading)
                const Center(child: CircularProgressIndicator.adaptive()),
            ],
          );
        },
      ),
    );
  }
}
