// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      userId: json['userId'] as String?,
      name: json['name'] as String?,
      avatar: (json['avatar'] as List<dynamic>?)
          ?.map((e) => AvatarResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      roles: (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'avatar': instance.avatar?.map((e) => e.toJson()).toList(),
      'email': instance.email,
      'phone': instance.phone,
      'roles': instance.roles,
    };
