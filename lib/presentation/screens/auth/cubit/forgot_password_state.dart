import 'package:equatable/equatable.dart';

enum ForgotPasswordStatus { initial, loading, success, failure }

class ForgotPasswordState extends Equatable {
  final ForgotPasswordStatus status;
  final String? message;
  final String? email;
  final bool isEmailSent;
  final bool isResetSuccess;

  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.initial,
    this.message,
    this.email,
    this.isEmailSent = false,
    this.isResetSuccess = false,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    String? message,
    String? email,
    bool? isEmailSent,
    bool? isResetSuccess,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      message: message ?? this.message,
      email: email ?? this.email,
      isEmailSent: isEmailSent ?? this.isEmailSent,
      isResetSuccess: isResetSuccess ?? this.isResetSuccess,
    );
  }

  @override
  List<Object?> get props => [status, message, email, isEmailSent, isResetSuccess];
}
