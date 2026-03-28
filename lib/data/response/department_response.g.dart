// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentResponse _$DepartmentResponseFromJson(Map<String, dynamic> json) =>
    DepartmentResponse(
      departmentsId: json['departments_id'] as String?,
      branchId: json['branch_id'] as String?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      branchName: json['branch_name'] as String?,
      facilityName: json['facility_name'] as String?,
    );

Map<String, dynamic> _$DepartmentResponseToJson(DepartmentResponse instance) =>
    <String, dynamic>{
      'departments_id': instance.departmentsId,
      'branch_id': instance.branchId,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'status': instance.status,
      'branch_name': instance.branchName,
      'facility_name': instance.facilityName,
    };
