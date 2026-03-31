import 'package:equatable/equatable.dart';

enum VerifyEmailStatus { initial, loading, success, failure }

class VerifyEmailState extends Equatable {
  final VerifyEmailStatus status;
  final String? message;

  const VerifyEmailState({
    this.status = VerifyEmailStatus.initial,
    this.message,
  });

  VerifyEmailState copyWith({
    VerifyEmailStatus? status,
    String? message,
  }) {
    return VerifyEmailState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
