// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrescriptionResponse _$PrescriptionResponseFromJson(
  Map<String, dynamic> json,
) => PrescriptionResponse(
  prescription: PrescriptionHeaderResponse.fromJson(
    json['prescription'] as Map<String, dynamic>,
  ),
  details: (json['details'] as List<dynamic>)
      .map(
        (e) => PrescriptionDetailResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$PrescriptionResponseToJson(
  PrescriptionResponse instance,
) => <String, dynamic>{
  'prescription': instance.prescription,
  'details': instance.details,
};

PrescriptionHeaderResponse _$PrescriptionHeaderResponseFromJson(
  Map<String, dynamic> json,
) => PrescriptionHeaderResponse(
  id: json['prescriptions_id'] as String,
  code: json['prescription_code'] as String,
  encounterId: json['encounter_id'] as String,
  patientId: json['patient_id'] as String,
  doctorId: json['doctor_id'] as String?,
  status: json['status'] as String,
  clinicalDiagnosis: json['clinical_diagnosis'] as String?,
  doctorNotes: json['doctor_notes'] as String?,
  prescribedAt: json['prescribed_at'] as String?,
  doctorName: json['doctor_name'] as String?,
  patientName: json['patient_name'] as String?,
);

Map<String, dynamic> _$PrescriptionHeaderResponseToJson(
  PrescriptionHeaderResponse instance,
) => <String, dynamic>{
  'prescriptions_id': instance.id,
  'prescription_code': instance.code,
  'encounter_id': instance.encounterId,
  'patient_id': instance.patientId,
  'doctor_id': instance.doctorId,
  'status': instance.status,
  'clinical_diagnosis': instance.clinicalDiagnosis,
  'doctor_notes': instance.doctorNotes,
  'prescribed_at': instance.prescribedAt,
  'doctor_name': instance.doctorName,
  'patient_name': instance.patientName,
};

PrescriptionDetailResponse _$PrescriptionDetailResponseFromJson(
  Map<String, dynamic> json,
) => PrescriptionDetailResponse(
  id: json['prescription_details_id'] as String,
  drugId: json['drug_id'] as String,
  quantity: (json['quantity'] as num).toInt(),
  dosage: json['dosage'] as String?,
  frequency: json['frequency'] as String?,
  durationDays: (json['duration_days'] as num?)?.toInt(),
  usageInstruction: json['usage_instruction'] as String?,
  routeOfAdministration: json['route_of_administration'] as String?,
  notes: json['notes'] as String?,
  drugCode: json['drug_code'] as String?,
  brandName: json['brand_name'] as String?,
  activeIngredients: json['active_ingredients'] as String?,
  dispensingUnit: json['dispensing_unit'] as String?,
);

Map<String, dynamic> _$PrescriptionDetailResponseToJson(
  PrescriptionDetailResponse instance,
) => <String, dynamic>{
  'prescription_details_id': instance.id,
  'drug_id': instance.drugId,
  'quantity': instance.quantity,
  'dosage': instance.dosage,
  'frequency': instance.frequency,
  'duration_days': instance.durationDays,
  'usage_instruction': instance.usageInstruction,
  'route_of_administration': instance.routeOfAdministration,
  'notes': instance.notes,
  'drug_code': instance.drugCode,
  'brand_name': instance.brandName,
  'active_ingredients': instance.activeIngredients,
  'dispensing_unit': instance.dispensingUnit,
};
