import 'package:e_health/data/response/avatar_response.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/domain/doctor.dart';

part 'doctor_response.g.dart';

@JsonSerializable()
class DoctorResponse {
  @JsonKey(name: 'doctors_id')
  final String? id;
  @JsonKey(name: 'user_id')
  final String? userId;
  final String? title;
  @JsonKey(name: 'full_name')
  final String? fullName;
  @JsonKey(name: 'specialty_name')
  final String? specialtyName;
  @JsonKey(name: 'avatar_url', fromJson: _parseAvatar)
  final List<AvatarResponse>? avatar;

  const DoctorResponse({
    this.id,
    this.userId,
    this.title,
    this.fullName,
    this.specialtyName,
    this.avatar,
  });

  factory DoctorResponse.fromJson(Map<String, dynamic> json) =>
      _$DoctorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorResponseToJson(this);

  static List<AvatarResponse>? _parseAvatar(dynamic json) {
    if (json == null) return null;
    if (json is List) {
      return json
          .map((e) => AvatarResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (json is Map) {
      return [AvatarResponse.fromJson(json as Map<String, dynamic>)];
    }
    return null;
  }

  Doctor map() {
    return Doctor(
      serverId: id,
      userId: userId,
      title: title,
      fullName: fullName,
      specialtyName: specialtyName,
      avatarUrl: avatar?.map((e) => e.map()).toList() ?? [],
    );
  }
}
