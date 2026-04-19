import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/domain/specialty.dart';

part 'department_specialty_response.g.dart';

@JsonSerializable()
class DepartmentSpecialtyResponse {
  @JsonKey(name: 'department_specialty_id')
  final String? departmentSpecialtyId;
  @JsonKey(name: 'department_id')
  final String? departmentId;
  @JsonKey(name: 'specialty_id')
  final String? specialtyId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'specialty_code')
  final String? specialtyCode;
  @JsonKey(name: 'specialty_name')
  final String? specialtyName;
  @JsonKey(name: 'specialty_description')
  final String? specialtyDescription;
  @JsonKey(name: 'specialty_logo_url')
  final String? specialtyLogoUrl;

  DepartmentSpecialtyResponse({
    this.departmentSpecialtyId,
    this.departmentId,
    this.specialtyId,
    this.createdAt,
    this.specialtyCode,
    this.specialtyName,
    this.specialtyDescription,
    this.specialtyLogoUrl,
  });

  factory DepartmentSpecialtyResponse.fromJson(Map<String, dynamic> json) =>
      _$DepartmentSpecialtyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentSpecialtyResponseToJson(this);

  Specialty map() {
    return Specialty(
      id: specialtyId,
      code: specialtyCode,
      name: specialtyName,
      description: specialtyDescription,
      logoUrl: specialtyLogoUrl,
    );
  }
}
