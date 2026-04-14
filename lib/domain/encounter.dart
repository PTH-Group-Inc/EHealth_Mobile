class Encounter {
  final String id;
  final String appointmentId;
  final String patientId;
  final String? doctorId;
  final String? roomId;
  final String? encounterType;
  final DateTime? startTime;
  final DateTime? endTime;
  final String status;
  final String? patientName;
  final String? doctorName;
  final String? appointmentCode;
  final String? conclusion;
  final String? notes;
  final int? visitNumber;
  final String? patientCode;
  final String? doctorTitle;
  final String? roomName;

  Encounter({
    required this.id,
    required this.appointmentId,
    required this.patientId,
    this.doctorId,
    this.roomId,
    this.encounterType,
    this.startTime,
    this.endTime,
    required this.status,
    this.patientName,
    this.doctorName,
    this.appointmentCode,
    this.conclusion,
    this.notes,
    this.visitNumber,
    this.patientCode,
    this.doctorTitle,
    this.roomName,
  });
}
