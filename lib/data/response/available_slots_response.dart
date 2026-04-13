import 'package:json_annotation/json_annotation.dart';
import '../../domain/slot.dart';

part 'available_slots_response.g.dart';

@JsonSerializable()
class AvailableSlotsResponse {
  @JsonKey(name: 'slot_id')
  final String slotId;
  
  @JsonKey(name: 'start_time')
  final String startTime;
  
  @JsonKey(name: 'end_time')
  final String endTime;
  
  @JsonKey(name: 'shift_id')
  final String shiftId;
  
  @JsonKey(name: 'shift_code')
  final String? shiftCode;
  
  @JsonKey(name: 'shift_name')
  final String? shiftName;
  
  @JsonKey(name: 'booked_count')
  final int? bookedCount;
  
  @JsonKey(name: 'max_capacity')
  final int? maxCapacity;
  
  @JsonKey(name: 'is_available')
  final bool isAvailable;

  AvailableSlotsResponse({
    required this.slotId,
    required this.startTime,
    required this.endTime,
    required this.shiftId,
    this.shiftCode,
    this.shiftName,
    this.bookedCount,
    this.maxCapacity,
    required this.isAvailable,
  });

  factory AvailableSlotsResponse.fromJson(Map<String, dynamic> json) =>
      _$AvailableSlotsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableSlotsResponseToJson(this);

  Slot map() {
    return Slot(
      id: slotId,
      shiftId: shiftId,
      startTime: startTime,
      endTime: endTime,
      isActive: true, // Assuming active since it's returned for availability
      isAvailable: isAvailable,
    );
  }
}
