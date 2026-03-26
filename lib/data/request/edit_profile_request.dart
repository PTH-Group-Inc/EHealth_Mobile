import 'package:json_annotation/json_annotation.dart';

part 'edit_profile_request.g.dart';

@JsonSerializable()
class EditProfileRequest {
  @JsonKey(name: 'full_name')
  final String? fullName;
  final String? dob;
  final String? gender;
  final String? address;
  @JsonKey(name: 'identity_card_number')
  final String? identityCardNumber;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  EditProfileRequest({
    this.fullName,
    this.dob,
    this.gender,
    this.address,
    this.identityCardNumber,
    this.avatarUrl,
  });

  factory EditProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$EditProfileRequestFromJson(json);
  Map<String, dynamic> toJson() => _$EditProfileRequestToJson(this);
}
