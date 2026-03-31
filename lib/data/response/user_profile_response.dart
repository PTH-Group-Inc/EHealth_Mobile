import 'package:json_annotation/json_annotation.dart';
import '../../domain/user_profile.dart';
import 'avatar_response.dart';

part 'user_profile_response.g.dart';

@JsonSerializable()
class UserProfileResponse {
  @JsonKey(name: 'users_id')
  final String? id;
  final String? email;
  @JsonKey(name: 'full_name')
  final String? name;
  @JsonKey(name: 'phone_number')
  final String? phone;
  final String? address;
  @JsonKey(name: 'avatar_url')
  final List<AvatarResponse>? avatar;
  final String? gender;
  @JsonKey(name: 'dob')
  final String? birthday;
  final String? status;
  @JsonKey(name: 'last_login_at')
  final String? lastLoginAt;
  @JsonKey(name: 'identity_card_number')
  final String? identityCard;
  final Map<String, dynamic>? preferences;
  final List<String>? roles;

  UserProfileResponse({
    this.id,
    this.email,
    this.name,
    this.phone,
    this.address,
    this.avatar,
    this.gender,
    this.birthday,
    this.status,
    this.lastLoginAt,
    this.identityCard,
    this.preferences,
    this.roles,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileResponseToJson(this);

  UserProfile map() => UserProfile(
        id: id ?? "",
        email: email ?? "",
        name: name ?? "N/A",
        phone: phone,
        address: address,
        avatarUrl: (avatar != null && avatar!.isNotEmpty) ? avatar![0].url : null,
        gender: gender,
        birthday: birthday != null ? DateTime.tryParse(birthday!) : null,
        status: status,
        identityCard: identityCard,
        roles: roles,
      );
}
