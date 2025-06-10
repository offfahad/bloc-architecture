import 'package:api_testing_app/core/models/user_model.dart';
import 'package:api_testing_app/features/auth/bloc/auth_bloc.dart';
import 'package:api_testing_app/features/auth/bloc/auth_event.dart';
import 'package:api_testing_app/features/auth/bloc/auth_state.dart';
import 'package:api_testing_app/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatelessWidget {
  final UserModel userModel;
  const DashboardScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.profile);
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            final user = state.data.user;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${user.firstName} ${user.lastName}'),
                  Text('Email: ${user.email}'),
                  Text('Phone: ${user.mobile}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutEvent());
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteNames.login,
                        (route) => false,
                      );
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
