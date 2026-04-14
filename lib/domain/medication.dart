class Medication {
  final String prescriptionCode;
  final String drugCode;
  final String brandName;
  final String activeIngredients;
  final String dosage;
  final String frequency;
  final int durationDays;
  final String usageInstruction;
  final String routeOfAdministration;
  final String dispensingUnit;
  final DateTime prescribedAt;
  final DateTime estimatedEndDate;
  final String doctorName;

  Medication({
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
}
