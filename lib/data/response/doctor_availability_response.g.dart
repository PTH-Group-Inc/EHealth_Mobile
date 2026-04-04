// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_availability_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorAvailabilityResponse _$DoctorAvailabilityResponseFromJson(
  Map<String, dynamic> json,
) => DoctorAvailabilityResponse(
  staffSchedulesId: json['staff_schedules_id'] as String?,
  workingDate: json['working_date'] as String?,
  startTime: json['start_time'] as String?,
  endTime: json['end_time'] as String?,
  isLeave: json['is_leave'] as bool?,
  leaveReason: json['leave_reason'] as String?,
  scheduleStatus: json['schedule_status'] as String?,
  shiftId: json['shift_id'] as String?,
  shiftCode: json['shift_code'] as String?,
  shiftName: json['shift_name'] as String?,
  roomId: json['room_id'] as String?,
  roomName: json['room_name'] as String?,
  doctorId: json['doctor_id'] as String?,
  specialtyName: json['specialty_name'] as String?,
  availabilityStatus: json['availability_status'] as String?,
);

Map<String, dynamic> _$DoctorAvailabilityResponseToJson(
  DoctorAvailabilityResponse instance,
) => <String, dynamic>{
  'staff_schedules_id': instance.staffSchedulesId,
  'working_date': instance.workingDate,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'is_leave': instance.isLeave,
  'leave_reason': instance.leaveReason,
  'schedule_status': instance.scheduleStatus,
  'shift_id': instance.shiftId,
  'shift_code': instance.shiftCode,
  'shift_name': instance.shiftName,
  'room_id': instance.roomId,
  'room_name': instance.roomName,
  'doctor_id': instance.doctorId,
  'specialty_name': instance.specialtyName,
  'availability_status': instance.availabilityStatus,
};
