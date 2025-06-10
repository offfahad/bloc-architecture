import 'package:api_testing_app/features/auth/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<LoginEvent>(_onLogin);
    on<GetMeEvent>(_onGetMe);
    on<LogoutEvent>(_onLogout);
    on<UpdateProfilePictureEvent>(_onUpdateProfilePicture);
    on<UpdatePasswordEvent>(_onUpdatePassword);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await authRepository.register(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
      mobile: event.mobile,
    );

    if (result.success && result.data != null) {
      emit(AuthSuccess(result.data!)); // You can now access user in OTP screen
    } else {
      emit(AuthFailure(result.message));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.verifyOtp(
      email: event.email,
      otp: event.otp,
    );
    if (result.success && result.data != null) {
      emit(AuthSuccess(result.data!));
    } else {
      emit(AuthFailure(result.message));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.login(
      email: event.email,
      password: event.password,
    );

    result.success && result.data != null
        ? emit(AuthSuccess(result.data!))
        : emit(AuthFailure(result.message));
  }

  Future<void> _onGetMe(GetMeEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.getMe();

    result.success && result.data != null
        ? emit(AuthSuccess(result.data!))
        : emit(AuthFailure(result.message));
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.clearTokens();
    emit(LogoutSuccess());
  }

  Future<void> _onUpdateProfilePicture(
    UpdateProfilePictureEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.updateProfilePicture(event.imageUrl);

    result.success
        ? emit(ProfilePictureUpdated())
        : emit(AuthFailure(result.message));
  }

  Future<void> _onUpdatePassword(
    UpdatePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.updatePassword(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );

    result.success
        ? emit(PasswordUpdated())
        : emit(AuthFailure(result.message));
  }
}
