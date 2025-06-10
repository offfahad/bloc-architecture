import 'package:api_testing_app/core/models/auth_data_model.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthDataModel data;

  AuthSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class LogoutSuccess extends AuthState {}

class ProfilePictureUpdated extends AuthState {}

class PasswordUpdated extends AuthState {}
