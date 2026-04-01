import 'package:equatable/equatable.dart';
import '../../../../domain/appointment_detail.dart';

enum AppointmentDetailStatus { initial, loading, success, failure }

class AppointmentDetailState extends Equatable {
  final AppointmentDetailStatus status;
  final AppointmentDetail? appointment;
  final String? errorMessage;

  const AppointmentDetailState({
    this.status = AppointmentDetailStatus.initial,
    this.appointment,
    this.errorMessage,
  });

  AppointmentDetailState copyWith({
    AppointmentDetailStatus? status,
    AppointmentDetail? appointment,
    String? errorMessage,
  }) {
    return AppointmentDetailState(
      status: status ?? this.status,
      appointment: appointment ?? this.appointment,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, appointment, errorMessage];
}
