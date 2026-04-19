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
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  const DoctorResponse({
    this.id,
    this.userId,
    this.title,
    this.fullName,
    this.specialtyName,
    this.avatarUrl,
  });

  factory DoctorResponse.fromJson(Map<String, dynamic> json) =>
      _$DoctorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorResponseToJson(this);

  Doctor map() {
    return Doctor(
      id: id,
      userId: userId,
      title: title,
      fullName: fullName,
      specialtyName: specialtyName,
      avatarUrl: avatarUrl,
    );
  }
}
