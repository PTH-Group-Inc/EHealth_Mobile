import 'package:json_annotation/json_annotation.dart';
import '../../domain/prescription.dart';

part 'prescription_response.g.dart';

@JsonSerializable()
class PrescriptionResponse {
  final PrescriptionHeaderResponse prescription;
  final List<PrescriptionDetailResponse> details;

  PrescriptionResponse({
    required this.prescription,
    required this.details,
  });

  factory PrescriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PrescriptionResponseToJson(this);

  Prescription map() {
    return Prescription(
      prescription: prescription.map(),
      details: details.map((e) => e.map()).toList(),
    );
  }
}

@JsonSerializable()
class PrescriptionHeaderResponse {
  @JsonKey(name: 'prescriptions_id')
  final String id;
  
  @JsonKey(name: 'prescription_code')
  final String code;
  
  @JsonKey(name: 'encounter_id')
  final String encounterId;
  
  @JsonKey(name: 'patient_id')
  final String patientId;
  
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  
  @JsonKey(name: 'status')
  final String status;
  
  @JsonKey(name: 'clinical_diagnosis')
  final String? clinicalDiagnosis;
  
  @JsonKey(name: 'doctor_notes')
  final String? doctorNotes;
  
  @JsonKey(name: 'prescribed_at')
  final String? prescribedAt;
  
  @JsonKey(name: 'doctor_name')
  final String? doctorName;
  
  @JsonKey(name: 'patient_name')
  final String? patientName;

  PrescriptionHeaderResponse({
    required this.id,
    required this.code,
    required this.encounterId,
    required this.patientId,
    this.doctorId,
    required this.status,
    this.clinicalDiagnosis,
    this.doctorNotes,
    this.prescribedAt,
    this.doctorName,
    this.patientName,
  });

  factory PrescriptionHeaderResponse.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionHeaderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PrescriptionHeaderResponseToJson(this);

  PrescriptionHeader map() {
    return PrescriptionHeader(
      id: id,
      code: code,
      encounterId: encounterId,
      patientId: patientId,
      doctorId: doctorId,
      status: status,
      clinicalDiagnosis: clinicalDiagnosis,
      doctorNotes: doctorNotes,
      prescribedAt: prescribedAt != null ? DateTime.tryParse(prescribedAt!) : null,
      doctorName: doctorName,
      patientName: patientName,
    );
  }
}

@JsonSerializable()
class PrescriptionDetailResponse {
  @JsonKey(name: 'prescription_details_id')
  final String id;
  
  @JsonKey(name: 'drug_id')
  final String drugId;
  
  @JsonKey(name: 'quantity')
  final int quantity;
  
  @JsonKey(name: 'dosage')
  final String? dosage;
  
  @JsonKey(name: 'frequency')
  final String? frequency;
  
  @JsonKey(name: 'duration_days')
  final int? durationDays;
  
  @JsonKey(name: 'usage_instruction')
  final String? usageInstruction;
  
  @JsonKey(name: 'route_of_administration')
  final String? routeOfAdministration;
  
  @JsonKey(name: 'notes')
  final String? notes;
  
  @JsonKey(name: 'drug_code')
  final String? drugCode;
  
  @JsonKey(name: 'brand_name')
  final String? brandName;
  
  @JsonKey(name: 'active_ingredients')
  final String? activeIngredients;
  
  @JsonKey(name: 'dispensing_unit')
  final String? dispensingUnit;

  PrescriptionDetailResponse({
    required this.id,
    required this.drugId,
    required this.quantity,
    this.dosage,
    this.frequency,
    this.durationDays,
    this.usageInstruction,
    this.routeOfAdministration,
    this.notes,
    this.drugCode,
    this.brandName,
    this.activeIngredients,
    this.dispensingUnit,
  });

  factory PrescriptionDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PrescriptionDetailResponseToJson(this);

  PrescriptionDetail map() {
    return PrescriptionDetail(
      id: id,
      drugId: drugId,
      quantity: quantity,
      dosage: dosage,
      frequency: frequency,
      durationDays: durationDays,
      usageInstruction: usageInstruction,
      routeOfAdministration: routeOfAdministration,
      notes: notes,
      drugCode: drugCode,
      brandName: brandName,
      activeIngredients: activeIngredients,
      dispensingUnit: dispensingUnit,
    );
  }
}
