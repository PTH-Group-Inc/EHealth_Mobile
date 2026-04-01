class AppointmentAuditLog {
  final String id;
  final String appointmentId;
  final String? changedBy;
  final String? oldStatus;
  final String newStatus;
  final String? actionNote;
  final DateTime createdAt;
  final String? changedByName;

  AppointmentAuditLog({
    required this.id,
    required this.appointmentId,
    this.changedBy,
    this.oldStatus,
    required this.newStatus,
    this.actionNote,
    required this.createdAt,
    this.changedByName,
  });
}
