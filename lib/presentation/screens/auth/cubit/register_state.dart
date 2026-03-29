import 'package:equatable/equatable.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final String? message;
  final String? phoneError;
  final String? nameError;
  final String? passwordError;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.message,
    this.phoneError,
    this.nameError,
    this.passwordError,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    String? message,
    String? phoneError,
    String? nameError,
    String? passwordError,
  }) {
    return RegisterState(
      status: status ?? this.status,
      message: message ?? this.message,
      phoneError: phoneError,
      nameError: nameError,
      passwordError: passwordError,
    );
  }

  @override
  List<Object?> get props => [status, message, phoneError, nameError, passwordError];
}
