// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_patient_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePatientRequest _$UpdatePatientRequestFromJson(
  Map<String, dynamic> json,
) => UpdatePatientRequest(
  full_name: json['full_name'] as String?,
  date_of_birth: json['date_of_birth'] as String?,
  gender: json['gender'] as String?,
  phone_number: json['phone_number'] as String?,
  email: json['email'] as String?,
  id_card_number: json['id_card_number'] as String?,
  address: json['address'] as String?,
  province_id: (json['province_id'] as num?)?.toInt(),
  district_id: (json['district_id'] as num?)?.toInt(),
  ward_id: (json['ward_id'] as num?)?.toInt(),
  emergency_contact_name: json['emergency_contact_name'] as String?,
  emergency_contact_phone: json['emergency_contact_phone'] as String?,
);

Map<String, dynamic> _$UpdatePatientRequestToJson(
  UpdatePatientRequest instance,
) => <String, dynamic>{
  'full_name': instance.full_name,
  'date_of_birth': instance.date_of_birth,
  'gender': instance.gender,
  'phone_number': instance.phone_number,
  'email': instance.email,
  'id_card_number': instance.id_card_number,
  'address': instance.address,
  'province_id': instance.province_id,
  'district_id': instance.district_id,
  'ward_id': instance.ward_id,
  'emergency_contact_name': instance.emergency_contact_name,
  'emergency_contact_phone': instance.emergency_contact_phone,
};
