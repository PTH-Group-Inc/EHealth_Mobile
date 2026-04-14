class Prescription {
  final PrescriptionHeader prescription;
  final List<PrescriptionDetail> details;

  Prescription({
    required this.prescription,
    required this.details,
  });
}

class PrescriptionHeader {
  final String id;
  final String code;
  final String encounterId;
  final String patientId;
  final String? doctorId;
  final String status;
  final String? clinicalDiagnosis;
  final String? doctorNotes;
  final DateTime? prescribedAt;
  final String? doctorName;
  final String? patientName;

  PrescriptionHeader({
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
}

class PrescriptionDetail {
  final String id;
  final String drugId;
  final int quantity;
  final String? dosage;
  final String? frequency;
  final int? durationDays;
  final String? usageInstruction;
  final String? routeOfAdministration;
  final String? notes;
  final String? drugCode;
  final String? brandName;
  final String? activeIngredients;
  final String? dispensingUnit;

  PrescriptionDetail({
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
}
