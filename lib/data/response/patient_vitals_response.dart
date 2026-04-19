import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/domain/patient_vitals.dart';

part 'patient_vitals_response.g.dart';

@JsonSerializable()
class PatientVitalsResponse {
  @JsonKey(name: 'clinical_examinations_id')
  final String? clinicalExaminationsId;
  @JsonKey(name: 'encounter_id')
  final String? encounterId;
  @JsonKey(name: 'encounter_date')
  final String? encounterDate;
  @JsonKey(name: 'doctor_name')
  final String? doctorName;
  @JsonKey(name: 'recorded_by')
  final String? recorderName;
  final int? pulse;
  @JsonKey(name: 'blood_pressure_systolic')
  final int? bloodPressureSystolic;
  @JsonKey(name: 'blood_pressure_diastolic')
  final int? bloodPressureDiastolic;
  final dynamic temperature;
  @JsonKey(name: 'respiratory_rate')
  final int? respiratoryRate;
  final int? spo2;
  final dynamic weight;
  final dynamic height;
  final dynamic bmi;
  @JsonKey(name: 'blood_glucose')
  final double? bloodGlucose;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  PatientVitalsResponse({
    this.clinicalExaminationsId,
    this.encounterId,
    this.encounterDate,
    this.doctorName,
    this.recorderName,
    this.pulse,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.temperature,
    this.respiratoryRate,
    this.spo2,
    this.weight,
    this.height,
    this.bmi,
    this.bloodGlucose,
    this.createdAt,
  });

  factory PatientVitalsResponse.fromJson(Map<String, dynamic> json) =>
      _$PatientVitalsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PatientVitalsResponseToJson(this);

  PatientVitals map() {
    return PatientVitals(
      clinicalExaminationsId: clinicalExaminationsId ?? "",
      encounterId: encounterId ?? "",
      encounterStart: encounterDate != null
          ? DateTime.parse(encounterDate!)
          : (createdAt != null ? DateTime.parse(createdAt!) : DateTime.now()),
      doctorName: doctorName,
      recorderName: recorderName,
      pulse: pulse,
      bloodPressureSystolic: bloodPressureSystolic,
      bloodPressureDiastolic: bloodPressureDiastolic,
      temperature: double.tryParse(temperature?.toString() ?? ""),
      respiratoryRate: respiratoryRate,
      spo2: spo2,
      weight: double.tryParse(weight?.toString() ?? ""),
      height: double.tryParse(height?.toString() ?? "")?.toInt(),
      bmi: double.tryParse(bmi?.toString() ?? ""),
      bloodGlucose: bloodGlucose,
      createdAt: createdAt != null
          ? DateTime.parse(createdAt!)
          : (encounterDate != null
              ? DateTime.parse(encounterDate!)
              : DateTime.now()),
    );
  }
}
