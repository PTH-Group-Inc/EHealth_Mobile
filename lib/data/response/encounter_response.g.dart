// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encounter_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EncounterResponse _$EncounterResponseFromJson(Map<String, dynamic> json) =>
    EncounterResponse(
      id: json['encounters_id'] as String,
      appointmentId: json['appointment_id'] as String,
      patientId: json['patient_id'] as String,
      doctorId: json['doctor_id'] as String?,
      roomId: json['room_id'] as String?,
      encounterType: json['encounter_type'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      status: json['status'] as String,
      patientName: json['patient_name'] as String?,
      doctorName: json['doctor_name'] as String?,
      appointmentCode: json['appointment_code'] as String?,
    );

Map<String, dynamic> _$EncounterResponseToJson(EncounterResponse instance) =>
    <String, dynamic>{
      'encounters_id': instance.id,
      'appointment_id': instance.appointmentId,
      'patient_id': instance.patientId,
      'doctor_id': instance.doctorId,
      'room_id': instance.roomId,
      'encounter_type': instance.encounterType,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'status': instance.status,
      'patient_name': instance.patientName,
      'doctor_name': instance.doctorName,
      'appointment_code': instance.appointmentCode,
    };
