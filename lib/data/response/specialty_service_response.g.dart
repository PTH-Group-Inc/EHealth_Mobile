// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialty_service_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialtyServiceResponse _$SpecialtyServiceResponseFromJson(
  Map<String, dynamic> json,
) => SpecialtyServiceResponse(
  specialtyId: json['specialty_id'] as String?,
  serviceId: json['service_id'] as String?,
  facilityServiceId: json['facility_service_id'] as String?,
  facilityServicesId: json['facility_services_id'] as String?,
  serviceCode: json['service_code'] as String?,
  serviceName: json['service_name'] as String?,
  serviceGroup: json['service_group'] as String?,
  serviceType: json['service_type'] as String?,
  basePrice: json['base_price'] as String?,
  insurancePrice: json['insurance_price'] as String?,
  vipPrice: json['vip_price'] as String?,
);

Map<String, dynamic> _$SpecialtyServiceResponseToJson(
  SpecialtyServiceResponse instance,
) => <String, dynamic>{
  'specialty_id': instance.specialtyId,
  'service_id': instance.serviceId,
  'facility_service_id': instance.facilityServiceId,
  'facility_services_id': instance.facilityServicesId,
  'service_code': instance.serviceCode,
  'service_name': instance.serviceName,
  'service_group': instance.serviceGroup,
  'service_type': instance.serviceType,
  'base_price': instance.basePrice,
  'insurance_price': instance.insurancePrice,
  'vip_price': instance.vipPrice,
};
