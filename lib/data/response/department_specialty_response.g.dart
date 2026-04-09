// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_specialty_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentSpecialtyResponse _$DepartmentSpecialtyResponseFromJson(
  Map<String, dynamic> json,
) => DepartmentSpecialtyResponse(
  departmentSpecialtyId: json['department_specialty_id'] as String?,
  departmentId: json['department_id'] as String?,
  specialtyId: json['specialty_id'] as String?,
  createdAt: json['created_at'] as String?,
  specialtyCode: json['specialty_code'] as String?,
  specialtyName: json['specialty_name'] as String?,
  specialtyDescription: json['specialty_description'] as String?,
  specialtyLogoUrl: json['specialty_logo_url'] as String?,
);

Map<String, dynamic> _$DepartmentSpecialtyResponseToJson(
  DepartmentSpecialtyResponse instance,
) => <String, dynamic>{
  'department_specialty_id': instance.departmentSpecialtyId,
  'department_id': instance.departmentId,
  'specialty_id': instance.specialtyId,
  'created_at': instance.createdAt,
  'specialty_code': instance.specialtyCode,
  'specialty_name': instance.specialtyName,
  'specialty_description': instance.specialtyDescription,
  'specialty_logo_url': instance.specialtyLogoUrl,
};
