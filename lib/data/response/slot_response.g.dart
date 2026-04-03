// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotResponse _$SlotResponseFromJson(Map<String, dynamic> json) => SlotResponse(
  slotId: json['slot_id'] as String,
  shiftId: json['shift_id'] as String,
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$SlotResponseToJson(SlotResponse instance) =>
    <String, dynamic>{
      'slot_id': instance.slotId,
      'shift_id': instance.shiftId,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'is_active': instance.isActive,
    };
