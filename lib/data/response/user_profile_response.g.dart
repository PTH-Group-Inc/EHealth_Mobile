// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileResponse _$UserProfileResponseFromJson(Map<String, dynamic> json) =>
    UserProfileResponse(
      id: json['users_id'] as String?,
      email: json['email'] as String?,
      name: json['full_name'] as String?,
      phone: json['phone_number'] as String?,
      address: json['address'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      gender: json['gender'] as String?,
      birthday: json['dob'] as String?,
      status: json['status'] as String?,
      identityCard: json['identity_card_number'] as String?,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserProfileResponseToJson(
  UserProfileResponse instance,
) => <String, dynamic>{
  'users_id': instance.id,
  'email': instance.email,
  'full_name': instance.name,
  'phone_number': instance.phone,
  'address': instance.address,
  'avatar_url': instance.avatarUrl,
  'gender': instance.gender,
  'dob': instance.birthday,
  'status': instance.status,
  'identity_card_number': instance.identityCard,
  'roles': instance.roles,
};
