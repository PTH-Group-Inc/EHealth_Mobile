part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {}

final class AuthFailure extends AuthState {
  final String? emailError;
  final String? passwordError;
  final String? generalError;

  AuthFailure({
    this.emailError,
    this.passwordError,
    this.generalError,
  });
}
