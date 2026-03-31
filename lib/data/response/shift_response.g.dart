// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftResponse _$ShiftResponseFromJson(Map<String, dynamic> json) =>
    ShiftResponse(
      shiftsId: json['shifts_id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$ShiftResponseToJson(ShiftResponse instance) =>
    <String, dynamic>{
      'shifts_id': instance.shiftsId,
      'code': instance.code,
      'name': instance.name,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'description': instance.description,
    };
