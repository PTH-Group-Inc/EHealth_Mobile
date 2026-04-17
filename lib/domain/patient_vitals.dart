class PatientVitals {
  final String clinicalExaminationsId;
  final String encounterId;
  final DateTime encounterStart;
  final String? doctorName;
  final String? recorderName;
  final int? pulse;
  final int? bloodPressureSystolic;
  final int? bloodPressureDiastolic;
  final double? temperature;
  final int? respiratoryRate;
  final int? spo2;
  final double? weight;
  final int? height;
  final double? bmi;
  final double? bloodGlucose;
  final DateTime createdAt;

  PatientVitals({
    required this.clinicalExaminationsId,
    required this.encounterId,
    required this.encounterStart,
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
    required this.createdAt,
  });
}
