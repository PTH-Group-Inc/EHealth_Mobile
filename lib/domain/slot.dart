class Slot {
  final String id;
  final String shiftId;
  final String startTime;
  final String endTime;
  final bool isActive;
  final bool isAvailable;

  Slot({
    required this.id,
    required this.shiftId,
    required this.startTime,
    required this.endTime,
    required this.isActive,
    required this.isAvailable,
  });
}
