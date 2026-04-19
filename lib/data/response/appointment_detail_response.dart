import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/domain/appointment_detail.dart';
import 'package:e_health/domain/appointment_audit_log.dart';
import 'package:e_health/data/response/appointment_list_response.dart';

part 'appointment_detail_response.g.dart';

@JsonSerializable()
class AppointmentDetailResponse {
  final bool? success;
  final String? message;
  final AppointmentDetailDataResponse? data;
  @JsonKey(name: 'audit_logs')
  final List<AppointmentAuditLogItemResponse>? auditLogs;

  AppointmentDetailResponse({
    this.success,
    this.message,
    this.data,
    this.auditLogs,
  });

  factory AppointmentDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$AppointmentDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentDetailResponseToJson(this);

  AppointmentDetail map() {
    return AppointmentDetail(
      appointment: data!.map(),
      checkInMethod: data?.checkInMethod,
      qrToken: data?.qrToken,
      qrTokenExpiresAt: data?.qrTokenExpiresAt != null
          ? DateTime.tryParse(data!.qrTokenExpiresAt!)
          : null,
      isLate: data?.isLate ?? false,
      lateMinutes: data?.lateMinutes ?? 0,
      checkedInAt: data?.checkedInAt != null
          ? DateTime.tryParse(data!.checkedInAt!)
          : null,
      confirmedAt: data?.confirmedAt != null
          ? DateTime.tryParse(data!.confirmedAt!)
          : null,
      confirmedBy: data?.confirmedBy,
      startedAt: data?.startedAt != null
          ? DateTime.tryParse(data!.startedAt!)
          : null,
      completedAt: data?.completedAt != null
          ? DateTime.tryParse(data!.completedAt!)
          : null,
      cancelledAt: data?.cancelledAt != null
          ? DateTime.tryParse(data!.cancelledAt!)
          : null,
      cancellationReason: data?.cancellationReason,
      cancelledBy: data?.cancelledBy,
      rescheduleCount: data?.rescheduleCount ?? 0,
      lastRescheduledAt: data?.lastRescheduledAt != null
          ? DateTime.tryParse(data!.lastRescheduledAt!)
          : null,
      isTeleconsultation: data?.isTeleconsultation ?? false,
      teleBookingSessionId: data?.teleBookingSessionId,
      auditLogs: auditLogs?.map((e) => e.map()).toList() ?? [],
    );
  }
}

@JsonSerializable()
class AppointmentDetailDataResponse extends AppointmentListItemResponse {
  @JsonKey(name: 'check_in_method')
  final String? checkInMethod;
  @JsonKey(name: 'qr_token')
  final String? qrToken;
  @JsonKey(name: 'qr_token_expires_at')
  final String? qrTokenExpiresAt;
  @JsonKey(name: 'is_late')
  final bool? isLate;
  @JsonKey(name: 'late_minutes')
  final int? lateMinutes;
  @JsonKey(name: 'checked_in_at')
  final String? checkedInAt;
  @JsonKey(name: 'confirmed_at')
  final String? confirmedAt;
  @JsonKey(name: 'confirmed_by')
  final String? confirmedBy;
  @JsonKey(name: 'started_at')
  final String? startedAt;
  @JsonKey(name: 'completed_at')
  final String? completedAt;
  @JsonKey(name: 'cancelled_at')
  final String? cancelledAt;
  @JsonKey(name: 'cancellation_reason')
  final String? cancellationReason;
  @JsonKey(name: 'cancelled_by')
  final String? cancelledBy;
  @JsonKey(name: 'reschedule_count')
  final int? rescheduleCount;
  @JsonKey(name: 'last_rescheduled_at')
  final String? lastRescheduledAt;
  @JsonKey(name: 'is_teleconsultation')
  final bool? isTeleconsultation;
  @JsonKey(name: 'tele_booking_session_id')
  final String? teleBookingSessionId;

  AppointmentDetailDataResponse({
    required super.appointmentsId,
    required super.appointmentCode,
    super.patientId,
    super.doctorId,
    super.slotId,
    super.roomId,
    super.facilityServiceId,
    super.appointmentDate,
    super.bookingChannel,
    super.reasonForVisit,
    super.symptomsNotes,
    required super.status,
    super.priority,
    super.queueNumber,
    super.createdAt,
    super.updatedAt,
    required super.branchId,
    super.patientName,
    super.doctorName,
    super.roomName,
    super.branchName,
    super.serviceName,
    super.slotStartTime,
    super.slotEndTime,
    this.checkInMethod,
    this.qrToken,
    this.qrTokenExpiresAt,
    this.isLate,
    this.lateMinutes,
    this.checkedInAt,
    this.confirmedAt,
    this.confirmedBy,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
    this.cancelledBy,
    this.rescheduleCount,
    this.lastRescheduledAt,
    this.isTeleconsultation,
    this.teleBookingSessionId,
  });

  factory AppointmentDetailDataResponse.fromJson(Map<String, dynamic> json) =>
      _$AppointmentDetailDataResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AppointmentDetailDataResponseToJson(this);
}

@JsonSerializable()
class AppointmentAuditLogItemResponse {
  @JsonKey(name: 'appointment_audit_logs_id')
  final String appointmentAuditLogsId;
  @JsonKey(name: 'appointment_id')
  final String appointmentId;
  @JsonKey(name: 'changed_by')
  final String? changedBy;
  @JsonKey(name: 'old_status')
  final String? oldStatus;
  @JsonKey(name: 'new_status')
  final String newStatus;
  @JsonKey(name: 'action_note')
  final String? actionNote;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'changed_by_name')
  final String? changedByName;

  AppointmentAuditLogItemResponse({
    required this.appointmentAuditLogsId,
    required this.appointmentId,
    this.changedBy,
    this.oldStatus,
    required this.newStatus,
    this.actionNote,
    required this.createdAt,
    this.changedByName,
  });

  factory AppointmentAuditLogItemResponse.fromJson(Map<String, dynamic> json) =>
      _$AppointmentAuditLogItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentAuditLogItemResponseToJson(this);

  AppointmentAuditLog map() {
    return AppointmentAuditLog(
      id: appointmentAuditLogsId,
      appointmentId: appointmentId,
      changedBy: changedBy,
      oldStatus: oldStatus,
      newStatus: newStatus,
      actionNote: actionNote,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      changedByName: changedByName,
    );
  }
}
