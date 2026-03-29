// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_phone_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterPhoneRequest _$RegisterPhoneRequestFromJson(
  Map<String, dynamic> json,
) => RegisterPhoneRequest(
  phone: json['phone'] as String,
  password: json['password'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$RegisterPhoneRequestToJson(
  RegisterPhoneRequest instance,
) => <String, dynamic>{
  'phone': instance.phone,
  'password': instance.password,
  'name': instance.name,
};
