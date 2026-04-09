// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'edit_profile_request.g.dart';

@JsonSerializable()
class EditProfileRequest {
  final String? full_name;
  final String? dob;
  final String? gender;
  final String? address;
  final String? identity_card_number;


  EditProfileRequest({
    this.full_name,
    this.dob,
    this.gender,
    this.address,
    this.identity_card_number,

  });

  factory EditProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$EditProfileRequestFromJson(json);
  Map<String, dynamic> toJson() => _$EditProfileRequestToJson(this);
}
