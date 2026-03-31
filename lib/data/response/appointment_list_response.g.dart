// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentListResponse _$AppointmentListResponseFromJson(
  Map<String, dynamic> json,
) => AppointmentListResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map(
        (e) => AppointmentListItemResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  patientId: json['patient_id'] as String?,
  pagination: json['pagination'] == null
      ? null
      : PaginationResponse.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppointmentListResponseToJson(
  AppointmentListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'patient_id': instance.patientId,
  'pagination': instance.pagination,
};

AppointmentListItemResponse _$AppointmentListItemResponseFromJson(
  Map<String, dynamic> json,
) => AppointmentListItemResponse(
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
);

Map<String, dynamic> _$AppointmentListItemResponseToJson(
  AppointmentListItemResponse instance,
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
};
