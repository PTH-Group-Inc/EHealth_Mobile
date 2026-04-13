// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_slots_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableSlotsRequest _$AvailableSlotsRequestFromJson(
  Map<String, dynamic> json,
) => AvailableSlotsRequest(
  date: json['date'] as String,
  doctorId: json['doctor_id'] as String?,
  facilityId: json['facility_id'] as String,
);

Map<String, dynamic> _$AvailableSlotsRequestToJson(
  AvailableSlotsRequest instance,
) => <String, dynamic>{
  'date': instance.date,
  'doctor_id': instance.doctorId,
  'facility_id': instance.facilityId,
};
