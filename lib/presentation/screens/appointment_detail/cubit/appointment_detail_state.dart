import 'package:equatable/equatable.dart';
import 'package:e_health/domain/appointment_detail.dart';
import 'package:e_health/domain/encounter.dart';
import 'package:e_health/domain/invoice.dart';
import 'package:e_health/domain/prescription.dart';

enum AppointmentDetailStatus { initial, loading, success, failure }

class AppointmentDetailState extends Equatable {
  final AppointmentDetailStatus status;
  final AppointmentDetail? appointment;
  final String? errorMessage;
  final Encounter? encounter;
  final Invoice? invoice;
  final Prescription? prescription;
  final bool isPreparingPayment;
  final bool navigateToPayment;
  final bool isCancelling;
  final bool cancelSuccess;

  const AppointmentDetailState({
    this.status = AppointmentDetailStatus.initial,
    this.appointment,
    this.errorMessage,
    this.encounter,
    this.invoice,
    this.prescription,
    this.isPreparingPayment = false,
    this.navigateToPayment = false,
    this.isCancelling = false,
    this.cancelSuccess = false,
  });

  AppointmentDetailState copyWith({
    AppointmentDetailStatus? status,
    AppointmentDetail? appointment,
    String? errorMessage,
    Encounter? encounter,
    Invoice? invoice,
    Prescription? prescription,
    bool? isPreparingPayment,
    bool? navigateToPayment,
    bool? isCancelling,
    bool? cancelSuccess,
  }) {
    return AppointmentDetailState(
      status: status ?? this.status,
      appointment: appointment ?? this.appointment,
      errorMessage: errorMessage ?? this.errorMessage,
      encounter: encounter ?? this.encounter,
      invoice: invoice ?? this.invoice,
      prescription: prescription ?? this.prescription,
      isPreparingPayment: isPreparingPayment ?? this.isPreparingPayment,
      navigateToPayment: navigateToPayment ?? this.navigateToPayment,
      isCancelling: isCancelling ?? this.isCancelling,
      cancelSuccess: cancelSuccess ?? this.cancelSuccess,
    );
  }

  @override
  List<Object?> get props => [
        status,
        appointment,
        errorMessage,
        encounter,
        invoice,
        prescription,
        isPreparingPayment,
        navigateToPayment,
        isCancelling,
        cancelSuccess,
      ];
}
