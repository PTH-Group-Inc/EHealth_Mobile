import 'package:json_annotation/json_annotation.dart';
import '../../domain/doctor.dart';

part 'doctor_response.g.dart';

@JsonSerializable()
class DoctorResponse {
  @JsonKey(name: 'doctors_id')
  final String? id;
  @JsonKey(name: 'user_id')
  final String? userId;
  final String? title;
  @JsonKey(name: 'consultation_fee')
  final String? consultationFee;
  @JsonKey(name: 'full_name')
  final String? fullName;
  @JsonKey(name: 'specialty_name')
  final String? specialtyName;

  const DoctorResponse({
    this.id,
    this.userId,
    this.title,
    this.consultationFee,
    this.fullName,
    this.specialtyName,
  });

  factory DoctorResponse.fromJson(Map<String, dynamic> json) =>
      _$DoctorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorResponseToJson(this);

  Doctor map() {
    return Doctor(
      id: id,
      userId: userId,
      title: title,
      consultationFee: consultationFee,
      fullName: fullName,
      specialtyName: specialtyName,
    );
  }
}
