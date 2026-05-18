// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_service_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorServiceResponse _$DoctorServiceResponseFromJson(
  Map<String, dynamic> json,
) => DoctorServiceResponse(
  doctorId: json['doctor_id'] as String?,
  doctorName: json['doctor_name'] as String?,
  doctorAvatar: DoctorServiceResponse._parseAvatar(json['doctor_avatar']),
  facilityServiceId: json['facility_service_id'] as String?,
  isPrimary: json['is_primary'] as bool?,
  serviceCode: json['service_code'] as String?,
  serviceName: json['service_name'] as String?,
  serviceGroup: json['service_group'] as String?,
  basePrice: DoctorServiceResponse._parsePriceNullable(json['base_price']),
  insurancePrice: DoctorServiceResponse._parsePriceNullable(
    json['insurance_price'],
  ),
  vipPrice: DoctorServiceResponse._parsePriceNullable(json['vip_price']),
);

Map<String, dynamic> _$DoctorServiceResponseToJson(
  DoctorServiceResponse instance,
) => <String, dynamic>{
  'doctor_id': instance.doctorId,
  'doctor_name': instance.doctorName,
  'doctor_avatar': instance.doctorAvatar,
  'facility_service_id': instance.facilityServiceId,
  'is_primary': instance.isPrimary,
  'service_code': instance.serviceCode,
  'service_name': instance.serviceName,
  'service_group': instance.serviceGroup,
  'base_price': instance.basePrice,
  'insurance_price': instance.insurancePrice,
  'vip_price': instance.vipPrice,
};
