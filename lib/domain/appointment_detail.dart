import 'package:e_health/domain/booked_appointment.dart';
import 'package:e_health/domain/appointment_audit_log.dart';

class AppointmentDetail {
  final BookedAppointment appointment;
  final String? checkInMethod;
  final String? qrToken;
  final DateTime? qrTokenExpiresAt;
  final bool isLate;
  final int lateMinutes;
  final DateTime? checkedInAt;
  final DateTime? confirmedAt;
  final String? confirmedBy;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final String? cancelledBy;
  final int rescheduleCount;
  final DateTime? lastRescheduledAt;
  final bool isTeleconsultation;
  final String? teleBookingSessionId;
  final List<AppointmentAuditLog> auditLogs;

  AppointmentDetail({
    required this.appointment,
    this.checkInMethod,
    this.qrToken,
    this.qrTokenExpiresAt,
    this.isLate = false,
    this.lateMinutes = 0,
    this.checkedInAt,
    this.confirmedAt,
    this.confirmedBy,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
    this.cancelledBy,
    this.rescheduleCount = 0,
    this.lastRescheduledAt,
    this.isTeleconsultation = false,
    this.teleBookingSessionId,
    required this.auditLogs,
  });
}
