import 'package:api_testing_app/features/auth/bloc/auth_bloc.dart';
import 'package:api_testing_app/features/auth/bloc/auth_event.dart';
import 'package:api_testing_app/features/auth/bloc/auth_state.dart';
import 'package:api_testing_app/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final String userId;

  const VerifyOtpScreen({super.key, required this.email, required this.userId});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onSubmitPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        VerifyOtpEvent(email: widget.email, otp: _otpController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is AuthSuccess) {
            Navigator.pop(context); // Remove loading
            Navigator.pushReplacementNamed(context, RouteNames.login);
          } else if (state is AuthFailure) {
            Navigator.pop(context); // Remove loading
            showDialog(
              context: context,
              builder:
                  (_) => AlertDialog(
                    title: const Text('Error'),
                    content: Text(state.message),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'An OTP has been sent to:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.email,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text('Enter the OTP below. It is valid for 10 minutes.'),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Enter OTP'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'OTP is required';
                    }
                    if (value.length != 6) {
                      return 'OTP must be 6 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _onSubmitPressed,
                  child: const Text('Verify'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
