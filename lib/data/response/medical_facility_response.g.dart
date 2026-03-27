// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_facility_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
