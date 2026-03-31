import 'package:json_annotation/json_annotation.dart';
import '../../domain/patient.dart';

part 'patient_response.g.dart';

@JsonSerializable()
class PatientResponse {
  final String id;
  @JsonKey(name: 'patient_code')
  final String patientCode;
  @JsonKey(name: 'account_id')
  final String? accountId;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'date_of_birth')
  final String dateOfBirth;
  final String gender;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String email;
  @JsonKey(name: 'id_card_number')
  final String? idCardNumber;
  final String? address;
  @JsonKey(name: 'emergency_contact_name')
  final String? emergencyContactName;
  @JsonKey(name: 'emergency_contact_phone')
  final String? emergencyContactPhone;
  @JsonKey(name: 'has_insurance')
  final bool hasInsurance;
  final String status;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  PatientResponse({
    required this.id,
    required this.patientCode,
    this.accountId,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    this.idCardNumber,
    this.address,
    this.emergencyContactName,
    this.emergencyContactPhone,
    required this.hasInsurance,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatientResponse.fromJson(Map<String, dynamic> json) =>
      _$PatientResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PatientResponseToJson(this);

  Patient map() {
    return Patient(
      id: id,
      patientCode: patientCode,
      accountId: accountId,
      fullName: fullName,
      dateOfBirth: DateTime.parse(dateOfBirth),
      gender: gender,
      phoneNumber: phoneNumber,
      email: email,
      idCardNumber: idCardNumber,
      address: address,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
      hasInsurance: hasInsurance,
      status: status,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}
