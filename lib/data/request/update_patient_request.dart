// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'update_patient_request.g.dart';

@JsonSerializable()
class UpdatePatientRequest {
  final String? full_name;
  final String? date_of_birth;
  final String? gender;
  final String? phone_number;
  final String? email;
  final String? id_card_number;
  final String? address;
  final int? province_id;
  final int? district_id;
  final int? ward_id;
  final String? emergency_contact_name;
  final String? emergency_contact_phone;

  UpdatePatientRequest({
    this.full_name,
    this.date_of_birth,
    this.gender,
    this.phone_number,
    this.email,
    this.id_card_number,
    this.address,
    this.province_id,
    this.district_id,
    this.ward_id,
    this.emergency_contact_name,
    this.emergency_contact_phone,
  });

  factory UpdatePatientRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePatientRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdatePatientRequestToJson(this);
}
