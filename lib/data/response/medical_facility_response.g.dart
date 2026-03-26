// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_facility_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalFacilityListResponse _$MedicalFacilityListResponseFromJson(
  Map<String, dynamic> json,
) => MedicalFacilityListResponse(
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => MedicalFacilityResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  pagination: json['pagination'] == null
      ? null
      : PaginationResponse.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MedicalFacilityListResponseToJson(
  MedicalFacilityListResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'pagination': instance.pagination,
};

MedicalFacilityResponse _$MedicalFacilityResponseFromJson(
  Map<String, dynamic> json,
) => MedicalFacilityResponse(
  facilitiesId: json['facilities_id'] as String?,
  code: json['code'] as String?,
  name: json['name'] as String?,
  taxCode: json['tax_code'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  website: json['website'] as String?,
  headquartersAddress: json['headquarters_address'] as String?,
  logoUrl: json['logo_url'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$MedicalFacilityResponseToJson(
  MedicalFacilityResponse instance,
) => <String, dynamic>{
  'facilities_id': instance.facilitiesId,
  'code': instance.code,
  'name': instance.name,
  'tax_code': instance.taxCode,
  'email': instance.email,
  'phone': instance.phone,
  'website': instance.website,
  'headquarters_address': instance.headquartersAddress,
  'logo_url': instance.logoUrl,
  'status': instance.status,
};
