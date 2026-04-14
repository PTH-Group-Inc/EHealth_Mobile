import 'package:json_annotation/json_annotation.dart';
import '../../domain/medication.dart';

part 'current_medication_response.g.dart';

@JsonSerializable()
class CurrentMedicationResponse {
  @JsonKey(name: 'prescription_code')
  final String prescriptionCode;
  @JsonKey(name: 'drug_code')
  final String drugCode;
  @JsonKey(name: 'brand_name')
  final String brandName;
  @JsonKey(name: 'active_ingredients')
  final String activeIngredients;
  final String dosage;
  final String frequency;
  @JsonKey(name: 'duration_days')
  final int durationDays;
  @JsonKey(name: 'usage_instruction')
  final String usageInstruction;
  @JsonKey(name: 'route_of_administration')
  final String routeOfAdministration;
  @JsonKey(name: 'dispensing_unit')
  final String dispensingUnit;
  @JsonKey(name: 'prescribed_at')
  final String prescribedAt;
  @JsonKey(name: 'estimated_end_date')
  final String estimatedEndDate;
  @JsonKey(name: 'doctor_name')
  final String doctorName;

  CurrentMedicationResponse({
    required this.prescriptionCode,
    required this.drugCode,
    required this.brandName,
    required this.activeIngredients,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
    required this.usageInstruction,
    required this.routeOfAdministration,
    required this.dispensingUnit,
    required this.prescribedAt,
    required this.estimatedEndDate,
    required this.doctorName,
  });

  factory CurrentMedicationResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrentMedicationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentMedicationResponseToJson(this);

  Medication map() {
    return Medication(
      prescriptionCode: prescriptionCode,
      drugCode: drugCode,
      brandName: brandName,
      activeIngredients: activeIngredients,
      dosage: dosage,
      frequency: frequency,
      durationDays: durationDays,
      usageInstruction: usageInstruction,
      routeOfAdministration: routeOfAdministration,
      dispensingUnit: dispensingUnit,
      prescribedAt: DateTime.parse(prescribedAt),
      estimatedEndDate: DateTime.parse(estimatedEndDate),
      doctorName: doctorName,
    );
  }
}
