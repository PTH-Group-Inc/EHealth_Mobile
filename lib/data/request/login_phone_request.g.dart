// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_phone_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginPhoneRequest _$LoginPhoneRequestFromJson(Map<String, dynamic> json) =>
    LoginPhoneRequest(
      phone: json['phone'] as String,
      password: json['password'] as String,
      client_info: json['client_info'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$LoginPhoneRequestToJson(LoginPhoneRequest instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'password': instance.password,
      'client_info': instance.client_info,
    };
