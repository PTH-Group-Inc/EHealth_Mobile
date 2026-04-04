class DoctorAvailability {
  final String staffSchedulesId;
  final String workingDate;
  final String startTime;
  final String endTime;
  final bool isLeave;
  final String? leaveReason;
  final String scheduleStatus;
  final String shiftId;
  final String shiftCode;
  final String shiftName;
  final String roomId;
  final String roomName;
  final String doctorId;
  final String specialtyName;
  final String availabilityStatus;

  DoctorAvailability({
    required this.staffSchedulesId,
    required this.workingDate,
    required this.startTime,
    required this.endTime,
    required this.isLeave,
    this.leaveReason,
    required this.scheduleStatus,
    required this.shiftId,
    required this.shiftCode,
    required this.shiftName,
    required this.roomId,
    required this.roomName,
    required this.doctorId,
    required this.specialtyName,
    required this.availabilityStatus,
  });
}
