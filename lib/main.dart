import 'package:api_testing_app/features/auth/repositories/auth_repository.dart';
import 'package:api_testing_app/routes/app_navigator.dart';
import 'package:api_testing_app/routes/app_router.dart';
import 'package:api_testing_app/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api_testing_app/features/auth/bloc/auth_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(context.read<AuthRepository>()),
        child: MaterialApp(
          navigatorKey: AppNavigator.navigatorKey,
          title: 'API Testing App With Bloc',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: RouteNames.splash,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
