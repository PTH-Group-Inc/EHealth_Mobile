import 'package:json_annotation/json_annotation.dart';
import '../../domain/shift.dart';

part 'shift_response.g.dart';

@JsonSerializable()
class ShiftResponse {
  @JsonKey(name: 'shifts_id')
  final String shiftsId;
  
  final String code;
  final String name;
  
  @JsonKey(name: 'start_time')
  final String startTime;
  
  @JsonKey(name: 'end_time')
  final String endTime;
  
  final String description;

  ShiftResponse({
    required this.shiftsId,
    required this.code,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.description,
  });

  factory ShiftResponse.fromJson(Map<String, dynamic> json) =>
      _$ShiftResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ShiftResponseToJson(this);

  Shift map() {
    return Shift(
      id: shiftsId,
      code: code,
      name: name,
      startTime: startTime,
      endTime: endTime,
      description: description,
    );
  }
}
