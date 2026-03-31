class BookedAppointment {
  final String id;
  final String code;
  final String branchId;
  final String? slotId;
  final String? doctorId;
  final String? roomId;
  final String status;

  BookedAppointment({
    required this.id,
    required this.code,
    required this.branchId,
    this.slotId,
    this.doctorId,
    this.roomId,
    required this.status,
  });
}
