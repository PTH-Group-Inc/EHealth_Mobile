// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentResponse _$DepartmentResponseFromJson(Map<String, dynamic> json) =>
    DepartmentResponse(
      departments_id: json['departments_id'] as String?,
      branch_id: json['branch_id'] as String?,
      facility_id: json['facility_id'] as String?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      group_type: json['group_type'] as String?,
      status: json['status'] as String?,
      branch_name: json['branch_name'] as String?,
      facility_name: json['facility_name'] as String?,
      logo_url: json['logo_url'] as String?,
    );

Map<String, dynamic> _$DepartmentResponseToJson(DepartmentResponse instance) =>
    <String, dynamic>{
      'departments_id': instance.departments_id,
      'branch_id': instance.branch_id,
      'facility_id': instance.facility_id,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'group_type': instance.group_type,
      'status': instance.status,
      'branch_name': instance.branch_name,
      'facility_name': instance.facility_name,
      'logo_url': instance.logo_url,
    };
