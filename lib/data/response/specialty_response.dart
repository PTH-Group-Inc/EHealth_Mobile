import 'package:json_annotation/json_annotation.dart';
import '../../domain/specialty.dart';

part 'specialty_response.g.dart';

@JsonSerializable()
class SpecialtyResponse {
  @JsonKey(name: 'specialties_id')
  final String? specialtiesId;
  final String? code;
  final String? name;
  final String? description;

  SpecialtyResponse({
    this.specialtiesId,
    this.code,
    this.name,
    this.description,
  });

  factory SpecialtyResponse.fromJson(Map<String, dynamic> json) =>
      _$SpecialtyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialtyResponseToJson(this);

  Specialty map() {
    return Specialty(
      id: specialtiesId,
      code: code,
      name: name,
      description: description,
    );
  }
}
