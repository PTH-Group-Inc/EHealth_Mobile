// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditProfileRequest _$EditProfileRequestFromJson(Map<String, dynamic> json) =>
    EditProfileRequest(
      fullName: json['full_name'] as String?,
      dob: json['dob'] as String?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      identityCardNumber: json['identity_card_number'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$EditProfileRequestToJson(EditProfileRequest instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'dob': instance.dob,
      'gender': instance.gender,
      'address': instance.address,
      'identity_card_number': instance.identityCardNumber,
      'avatar_url': instance.avatarUrl,
    };
