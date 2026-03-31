// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvatarResponse _$AvatarResponseFromJson(Map<String, dynamic> json) =>
    AvatarResponse(
      url: json['url'] as String?,
      publicId: json['public_id'] as String?,
      uploadedAt: json['uploaded_at'] as String?,
    );

Map<String, dynamic> _$AvatarResponseToJson(AvatarResponse instance) =>
    <String, dynamic>{
      'url': instance.url,
      'public_id': instance.publicId,
      'uploaded_at': instance.uploadedAt,
    };
