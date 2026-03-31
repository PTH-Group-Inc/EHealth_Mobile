class MedicalHistory {
  final String encountersId;
  final String appointmentId;
  final String patientId;
  final String doctorId;
  final String roomId;
  final String encounterType;
  final DateTime startTime;
  final DateTime? endTime;
  final String status;
  final DateTime createdAt;
  final String doctorName;
  final String doctorTitle;
  final String specialtyName;
  final String roomName;
  final String roomCode;
  final String patientCode;
  final String patientName;
  final String? chiefComplaint;
  final String? primaryDiagnosis;

  MedicalHistory({
    required this.encountersId,
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.roomId,
    required this.encounterType,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.createdAt,
    required this.doctorName,
    required this.doctorTitle,
    required this.specialtyName,
    required this.roomName,
    required this.roomCode,
    required this.patientCode,
    required this.patientName,
    this.chiefComplaint,
    this.primaryDiagnosis,
  });
}
