// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
  patientId: json['patientId'] as String,
  patientName: json['patientName'] as String,
  patientAvatar: json['patientAvatar'] as String?,
  branchId: json['branchId'] as String?,
  branchName: json['branchName'] as String?,
  facilityId: json['facilityId'] as String?,
  departmentId: json['departmentId'] as String?,
  departmentName: json['departmentName'] as String?,
);

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'patientId': instance.patientId,
      'patientName': instance.patientName,
      'patientAvatar': instance.patientAvatar,
      'branchId': instance.branchId,
      'branchName': instance.branchName,
      'facilityId': instance.facilityId,
      'departmentId': instance.departmentId,
      'departmentName': instance.departmentName,
    };
