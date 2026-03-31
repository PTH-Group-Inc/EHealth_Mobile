import 'package:equatable/equatable.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final String? message;
  final String? phoneError;
  final String? emailError;
  final String? nameError;
  final String? passwordError;
  final bool isEmailMode;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.message,
    this.phoneError,
    this.emailError,
    this.nameError,
    this.passwordError,
    this.isEmailMode = false,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    String? message,
    String? phoneError,
    String? emailError,
    String? nameError,
    String? passwordError,
    bool? isEmailMode,
  }) {
    return RegisterState(
      status: status ?? this.status,
      message: message ?? this.message,
      phoneError: phoneError,
      emailError: emailError,
      nameError: nameError,
      passwordError: passwordError,
      isEmailMode: isEmailMode ?? this.isEmailMode,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        phoneError,
        emailError,
        nameError,
        passwordError,
        isEmailMode,
      ];
}
