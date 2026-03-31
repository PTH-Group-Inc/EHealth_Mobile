// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_service_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacilityServiceResponse _$FacilityServiceResponseFromJson(
  Map<String, dynamic> json,
) => FacilityServiceResponse(
  facilityServicesId: json['facility_services_id'] as String,
  facilityId: json['facility_id'] as String,
  serviceId: json['service_id'] as String,
  departmentId: json['department_id'] as String,
  basePrice: json['base_price'] as String,
  insurancePrice: json['insurance_price'] as String?,
  vipPrice: json['vip_price'] as String?,
  estimatedDurationMinutes: (json['estimated_duration_minutes'] as num).toInt(),
  serviceCode: json['service_code'] as String,
  serviceName: json['service_name'] as String,
  serviceGroup: json['service_group'] as String?,
);

Map<String, dynamic> _$FacilityServiceResponseToJson(
  FacilityServiceResponse instance,
) => <String, dynamic>{
  'facility_services_id': instance.facilityServicesId,
  'facility_id': instance.facilityId,
  'service_id': instance.serviceId,
  'department_id': instance.departmentId,
  'base_price': instance.basePrice,
  'insurance_price': instance.insurancePrice,
  'vip_price': instance.vipPrice,
  'estimated_duration_minutes': instance.estimatedDurationMinutes,
  'service_code': instance.serviceCode,
  'service_name': instance.serviceName,
  'service_group': instance.serviceGroup,
};
