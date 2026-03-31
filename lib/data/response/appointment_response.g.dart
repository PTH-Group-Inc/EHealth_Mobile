// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentResponse _$AppointmentResponseFromJson(Map<String, dynamic> json) =>
    AppointmentResponse(
      appointmentsId: json['appointments_id'] as String,
      appointmentCode: json['appointment_code'] as String,
      branchId: json['branch_id'] as String,
      slotId: json['slot_id'] as String?,
      doctorId: json['doctor_id'] as String?,
      roomId: json['room_id'] as String?,
      status: json['status'] as String,
    );

Map<String, dynamic> _$AppointmentResponseToJson(
  AppointmentResponse instance,
) => <String, dynamic>{
  'appointments_id': instance.appointmentsId,
  'appointment_code': instance.appointmentCode,
  'branch_id': instance.branchId,
  'slot_id': instance.slotId,
  'doctor_id': instance.doctorId,
  'room_id': instance.roomId,
  'status': instance.status,
};
