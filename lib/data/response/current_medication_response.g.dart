// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_medication_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentMedicationResponse _$CurrentMedicationResponseFromJson(
  Map<String, dynamic> json,
) => CurrentMedicationResponse(
  prescriptionCode: json['prescription_code'] as String,
  drugCode: json['drug_code'] as String,
  brandName: json['brand_name'] as String,
  activeIngredients: json['active_ingredients'] as String,
  dosage: json['dosage'] as String,
  frequency: json['frequency'] as String,
  durationDays: (json['duration_days'] as num).toInt(),
  usageInstruction: json['usage_instruction'] as String,
  routeOfAdministration: json['route_of_administration'] as String,
  dispensingUnit: json['dispensing_unit'] as String,
  prescribedAt: json['prescribed_at'] as String,
  estimatedEndDate: json['estimated_end_date'] as String,
  doctorName: json['doctor_name'] as String,
);

Map<String, dynamic> _$CurrentMedicationResponseToJson(
  CurrentMedicationResponse instance,
) => <String, dynamic>{
  'prescription_code': instance.prescriptionCode,
  'drug_code': instance.drugCode,
  'brand_name': instance.brandName,
  'active_ingredients': instance.activeIngredients,
  'dosage': instance.dosage,
  'frequency': instance.frequency,
  'duration_days': instance.durationDays,
  'usage_instruction': instance.usageInstruction,
  'route_of_administration': instance.routeOfAdministration,
  'dispensing_unit': instance.dispensingUnit,
  'prescribed_at': instance.prescribedAt,
  'estimated_end_date': instance.estimatedEndDate,
  'doctor_name': instance.doctorName,
};
