class BookedAppointment {
  final String id;
  final String code;
  final String branchId;
  final String? slotId;
  final String? doctorId;
  final String? roomId;
  final String status;
  final String? patientId;
  final String? facilityServiceId;
  final String? appointmentDate;
  final String? bookingChannel;
  final String? reasonForVisit;
  final String? symptomsNotes;
  final String? priority;
  final int? queueNumber;
  final String? patientName;
  final String? doctorName;
  final String? roomName;
  final String? branchName;
  final String? serviceName;
  final String? slotStartTime;
  final String? slotEndTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BookedAppointment({
    required this.id,
    required this.code,
    required this.branchId,
    this.slotId,
    this.doctorId,
    this.roomId,
    required this.status,
    this.patientId,
    this.facilityServiceId,
    this.appointmentDate,
    this.bookingChannel,
    this.reasonForVisit,
    this.symptomsNotes,
    this.priority,
    this.queueNumber,
    this.patientName,
    this.doctorName,
    this.roomName,
    this.branchName,
    this.serviceName,
    this.slotStartTime,
    this.slotEndTime,
    this.createdAt,
    this.updatedAt,
  });
}
