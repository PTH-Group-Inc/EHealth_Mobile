// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_vitals_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientVitalsResponse _$PatientVitalsResponseFromJson(
  Map<String, dynamic> json,
) => PatientVitalsResponse(
  clinicalExaminationsId: json['clinical_examinations_id'] as String?,
  encounterId: json['encounter_id'] as String?,
  encounterDate: json['encounter_date'] as String?,
  doctorName: json['doctor_name'] as String?,
  recorderName: json['recorded_by'] as String?,
  pulse: (json['pulse'] as num?)?.toInt(),
  bloodPressureSystolic: (json['blood_pressure_systolic'] as num?)?.toInt(),
  bloodPressureDiastolic: (json['blood_pressure_diastolic'] as num?)?.toInt(),
  temperature: json['temperature'],
  respiratoryRate: (json['respiratory_rate'] as num?)?.toInt(),
  spo2: (json['spo2'] as num?)?.toInt(),
  weight: json['weight'],
  height: json['height'],
  bmi: json['bmi'],
  bloodGlucose: (json['blood_glucose'] as num?)?.toDouble(),
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$PatientVitalsResponseToJson(
  PatientVitalsResponse instance,
) => <String, dynamic>{
  'clinical_examinations_id': instance.clinicalExaminationsId,
  'encounter_id': instance.encounterId,
  'encounter_date': instance.encounterDate,
  'doctor_name': instance.doctorName,
  'recorded_by': instance.recorderName,
  'pulse': instance.pulse,
  'blood_pressure_systolic': instance.bloodPressureSystolic,
  'blood_pressure_diastolic': instance.bloodPressureDiastolic,
  'temperature': instance.temperature,
  'respiratory_rate': instance.respiratoryRate,
  'spo2': instance.spo2,
  'weight': instance.weight,
  'height': instance.height,
  'bmi': instance.bmi,
  'blood_glucose': instance.bloodGlucose,
  'created_at': instance.createdAt,
};
