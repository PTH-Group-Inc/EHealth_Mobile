import 'package:equatable/equatable.dart';

enum ChangePasswordStatus { initial, loading, success, failure }

class ChangePasswordState extends Equatable {
  final ChangePasswordStatus status;
  final String? message;
  final bool obscureOldPassword;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;

  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.message,
    this.obscureOldPassword = true,
    this.obscureNewPassword = true,
    this.obscureConfirmPassword = true,
  });

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    String? message,
    bool? obscureOldPassword,
    bool? obscureNewPassword,
    bool? obscureConfirmPassword,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      message: message,
      obscureOldPassword: obscureOldPassword ?? this.obscureOldPassword,
      obscureNewPassword: obscureNewPassword ?? this.obscureNewPassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        obscureOldPassword,
        obscureNewPassword,
        obscureConfirmPassword,
      ];
}
