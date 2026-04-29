// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FcmTokenRequest _$FcmTokenRequestFromJson(Map<String, dynamic> json) =>
    FcmTokenRequest(
      fcm_token: json['fcm_token'] as String,
      device_name: json['device_name'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$FcmTokenRequestToJson(FcmTokenRequest instance) =>
    <String, dynamic>{
      'fcm_token': instance.fcm_token,
      'device_name': instance.device_name,
      'userId': instance.userId,
    };
