import 'package:json_annotation/json_annotation.dart';
import '../../domain/medical_facility.dart';
import 'base_response/pagination_response.dart';

part 'medical_facility_response.g.dart';

@JsonSerializable()
class MedicalFacilityResponse {
  @JsonKey(name: 'facilities_id')
  final String? facilitiesId;
  final String? code;
  final String? name;
  @JsonKey(name: 'tax_code')
  final String? taxCode;
  final String? email;
  final String? phone;
  final String? website;
  @JsonKey(name: 'headquarters_address')
  final String? headquartersAddress;
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  final String? status;

  MedicalFacilityResponse({
    this.facilitiesId,
    this.code,
    this.name,
    this.taxCode,
    this.email,
    this.phone,
    this.website,
    this.headquartersAddress,
    this.logoUrl,
    this.status,
  });

  factory MedicalFacilityResponse.fromJson(Map<String, dynamic> json) =>
      _$MedicalFacilityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalFacilityResponseToJson(this);

  MedicalFacility map() {
    return MedicalFacility(
      id: facilitiesId,
      code: code,
      name: name,
      taxCode: taxCode,
      email: email,
      phone: phone,
      website: website,
      headquartersAddress: headquartersAddress,
      logoUrl: logoUrl,
      status: status,
    );
  }
}
