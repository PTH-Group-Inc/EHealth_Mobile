// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchResponse _$BranchResponseFromJson(Map<String, dynamic> json) =>
    BranchResponse(
      branchesId: json['branches_id'] as String?,
      facilityId: json['facility_id'] as String?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as String?,
      establishedDate: json['established_date'] as String?,
      deletedAt: json['deleted_at'] as String?,
      facilityName: json['facility_name'] as String?,
      logo_url: json['logo_url'] as String?,
    );

Map<String, dynamic> _$BranchResponseToJson(BranchResponse instance) =>
    <String, dynamic>{
      'branches_id': instance.branchesId,
      'facility_id': instance.facilityId,
      'code': instance.code,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'status': instance.status,
      'established_date': instance.establishedDate,
      'deleted_at': instance.deletedAt,
      'facility_name': instance.facilityName,
      'logo_url': instance.logo_url,
    };
