import 'package:json_annotation/json_annotation.dart';
import '../../domain/slot.dart';

part 'slot_response.g.dart';

@JsonSerializable()
class SlotResponse {
  @JsonKey(name: 'slot_id')
  final String slotId;
  
  @JsonKey(name: 'shift_id')
  final String shiftId;
  
  @JsonKey(name: 'start_time')
  final String startTime;
  
  @JsonKey(name: 'end_time')
  final String endTime;
  
  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'is_available')
  final bool? isAvailable;

  SlotResponse({
    required this.slotId,
    required this.shiftId,
    required this.startTime,
    required this.endTime,
    required this.isActive,
    this.isAvailable,
  });

  factory SlotResponse.fromJson(Map<String, dynamic> json) =>
      _$SlotResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SlotResponseToJson(this);

  Slot map() {
    return Slot(
      id: slotId,
      shiftId: shiftId,
      startTime: startTime,
      endTime: endTime,
      isActive: isActive,
      isAvailable: isAvailable ?? true,
    );
  }
}
