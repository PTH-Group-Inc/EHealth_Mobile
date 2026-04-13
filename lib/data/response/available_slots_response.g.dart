// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_slots_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableSlotsResponse _$AvailableSlotsResponseFromJson(
  Map<String, dynamic> json,
) => AvailableSlotsResponse(
  slotId: json['slot_id'] as String,
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  shiftId: json['shift_id'] as String,
  shiftCode: json['shift_code'] as String?,
  shiftName: json['shift_name'] as String?,
  bookedCount: (json['booked_count'] as num?)?.toInt(),
  maxCapacity: (json['max_capacity'] as num?)?.toInt(),
  isAvailable: json['is_available'] as bool,
);

Map<String, dynamic> _$AvailableSlotsResponseToJson(
  AvailableSlotsResponse instance,
) => <String, dynamic>{
  'slot_id': instance.slotId,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'shift_id': instance.shiftId,
  'shift_code': instance.shiftCode,
  'shift_name': instance.shiftName,
  'booked_count': instance.bookedCount,
  'max_capacity': instance.maxCapacity,
  'is_available': instance.isAvailable,
};
