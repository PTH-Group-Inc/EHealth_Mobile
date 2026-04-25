import 'package:e_health/domain/user_profile.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/data/response/avatar_response.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserResponse {
  final String? userId;
  final String? name;
  final List<AvatarResponse>? avatar;
  final String? email;
  final String? phone;
  final List<String>? roles;

  UserResponse({
    this.userId,
    this.name,
    this.avatar,
    this.email,
    this.phone,
    this.roles,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);

  UserProfile map() => UserProfile(
        id: userId ?? "",
        email: email ?? "",
        name: name ?? "",
        phone: phone,
        roles: roles,
        avatars: avatar?.map((e) => e.map()).toList(),
      );

  // Helper for UI to get the primary avatar URL
  String? get avatarUrl => (avatar != null && avatar!.isNotEmpty) ? avatar![0].url : null;

  // Map to Domain (if needed)
  Map<String, dynamic> toMap() => {
    'userId': userId,
    'name': name,
    'avatar': avatar?.map((e) => e.toJson()).toList(),
    'email': email,
    'phone': phone,
    'roles': roles,
  };
}
