// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentDetailResponse _$AppointmentDetailResponseFromJson(
  Map<String, dynamic> json,
) => AppointmentDetailResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : AppointmentDetailDataResponse.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
  auditLogs: (json['audit_logs'] as List<dynamic>?)
      ?.map(
        (e) =>
            AppointmentAuditLogItemResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$AppointmentDetailResponseToJson(
  AppointmentDetailResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'audit_logs': instance.auditLogs,
};

AppointmentDetailDataResponse _$AppointmentDetailDataResponseFromJson(
  Map<String, dynamic> json,
) => AppointmentDetailDataResponse(
  appointmentsId: json['appointments_id'] as String,
  appointmentCode: json['appointment_code'] as String,
  patientId: json['patient_id'] as String?,
  doctorId: json['doctor_id'] as String?,
  slotId: json['slot_id'] as String?,
  roomId: json['room_id'] as String?,
  facilityServiceId: json['facility_service_id'] as String?,
  appointmentDate: json['appointment_date'] as String?,
  bookingChannel: json['booking_channel'] as String?,
  reasonForVisit: json['reason_for_visit'] as String?,
  symptomsNotes: json['symptoms_notes'] as String?,
  status: json['status'] as String,
  priority: json['priority'] as String?,
  queueNumber: (json['queue_number'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  branchId: json['branch_id'] as String,
  patientName: json['patient_name'] as String?,
  doctorName: json['doctor_name'] as String?,
  roomName: json['room_name'] as String?,
  branchName: json['branch_name'] as String?,
  serviceName: json['service_name'] as String?,
  slotStartTime: json['slot_start_time'] as String?,
  slotEndTime: json['slot_end_time'] as String?,
  checkInMethod: json['check_in_method'] as String?,
  qrToken: json['qr_token'] as String?,
  qrTokenExpiresAt: json['qr_token_expires_at'] as String?,
  isLate: json['is_late'] as bool?,
  lateMinutes: (json['late_minutes'] as num?)?.toInt(),
  checkedInAt: json['checked_in_at'] as String?,
  confirmedAt: json['confirmed_at'] as String?,
  confirmedBy: json['confirmed_by'] as String?,
  startedAt: json['started_at'] as String?,
  completedAt: json['completed_at'] as String?,
  cancelledAt: json['cancelled_at'] as String?,
  cancellationReason: json['cancellation_reason'] as String?,
  cancelledBy: json['cancelled_by'] as String?,
  rescheduleCount: (json['reschedule_count'] as num?)?.toInt(),
  lastRescheduledAt: json['last_rescheduled_at'] as String?,
  isTeleconsultation: json['is_teleconsultation'] as bool?,
  teleBookingSessionId: json['tele_booking_session_id'] as String?,
);

Map<String, dynamic> _$AppointmentDetailDataResponseToJson(
  AppointmentDetailDataResponse instance,
) => <String, dynamic>{
  'appointments_id': instance.appointmentsId,
  'appointment_code': instance.appointmentCode,
  'patient_id': instance.patientId,
  'doctor_id': instance.doctorId,
  'slot_id': instance.slotId,
  'room_id': instance.roomId,
  'facility_service_id': instance.facilityServiceId,
  'appointment_date': instance.appointmentDate,
  'booking_channel': instance.bookingChannel,
  'reason_for_visit': instance.reasonForVisit,
  'symptoms_notes': instance.symptomsNotes,
  'status': instance.status,
  'priority': instance.priority,
  'queue_number': instance.queueNumber,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'branch_id': instance.branchId,
  'patient_name': instance.patientName,
  'doctor_name': instance.doctorName,
  'room_name': instance.roomName,
  'branch_name': instance.branchName,
  'service_name': instance.serviceName,
  'slot_start_time': instance.slotStartTime,
  'slot_end_time': instance.slotEndTime,
  'check_in_method': instance.checkInMethod,
  'qr_token': instance.qrToken,
  'qr_token_expires_at': instance.qrTokenExpiresAt,
  'is_late': instance.isLate,
  'late_minutes': instance.lateMinutes,
  'checked_in_at': instance.checkedInAt,
  'confirmed_at': instance.confirmedAt,
  'confirmed_by': instance.confirmedBy,
  'started_at': instance.startedAt,
  'completed_at': instance.completedAt,
  'cancelled_at': instance.cancelledAt,
  'cancellation_reason': instance.cancellationReason,
  'cancelled_by': instance.cancelledBy,
  'reschedule_count': instance.rescheduleCount,
  'last_rescheduled_at': instance.lastRescheduledAt,
  'is_teleconsultation': instance.isTeleconsultation,
  'tele_booking_session_id': instance.teleBookingSessionId,
};

AppointmentAuditLogItemResponse _$AppointmentAuditLogItemResponseFromJson(
  Map<String, dynamic> json,
) => AppointmentAuditLogItemResponse(
  appointmentAuditLogsId: json['appointment_audit_logs_id'] as String,
  appointmentId: json['appointment_id'] as String,
  changedBy: json['changed_by'] as String?,
  oldStatus: json['old_status'] as String?,
  newStatus: json['new_status'] as String,
  actionNote: json['action_note'] as String?,
  createdAt: json['created_at'] as String,
  changedByName: json['changed_by_name'] as String?,
);

Map<String, dynamic> _$AppointmentAuditLogItemResponseToJson(
  AppointmentAuditLogItemResponse instance,
) => <String, dynamic>{
  'appointment_audit_logs_id': instance.appointmentAuditLogsId,
  'appointment_id': instance.appointmentId,
  'changed_by': instance.changedBy,
  'old_status': instance.oldStatus,
  'new_status': instance.newStatus,
  'action_note': instance.actionNote,
  'created_at': instance.createdAt,
  'changed_by_name': instance.changedByName,
};
