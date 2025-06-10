import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String mobile;

  RegisterEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.mobile,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, password, mobile];
}

class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String otp;

  VerifyOtpEvent({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class GetMeEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class UpdateProfilePictureEvent extends AuthEvent {
  final String imageUrl;

  UpdateProfilePictureEvent({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}

class UpdatePasswordEvent extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  UpdatePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}
