import 'package:json_annotation/json_annotation.dart';

part 'facility_calendar_day_response.g.dart';

@JsonSerializable()
class FacilityCalendarResponse {
  @JsonKey(name: 'facility_id')
  final String facilityId;
  final int month;
  final int year;
  final List<FacilityCalendarDayResponse> days;

  FacilityCalendarResponse({
    required this.facilityId,
    required this.month,
    required this.year,
    required this.days,
  });

  factory FacilityCalendarResponse.fromJson(Map<String, dynamic> json) =>
      _$FacilityCalendarResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FacilityCalendarResponseToJson(this);
}

@JsonSerializable()
class FacilityCalendarDayResponse {
  final String date;
  
  @JsonKey(name: 'is_open')
  final bool isOpen;

  @JsonKey(name: 'day_of_week')
  final int? dayOfWeek;

  @JsonKey(name: 'day_name')
  final String? dayName;

  FacilityCalendarDayResponse({
    required this.date,
    required this.isOpen,
    this.dayOfWeek,
    this.dayName,
  });

  factory FacilityCalendarDayResponse.fromJson(Map<String, dynamic> json) =>
      _$FacilityCalendarDayResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FacilityCalendarDayResponseToJson(this);

  FacilityCalendarDayStatus map() {
    return FacilityCalendarDayStatus(
      date: DateTime.parse(date),
      isOpen: isOpen,
    );
  }
}

class FacilityCalendarDayStatus {
  final DateTime date;
  final bool isOpen;

  FacilityCalendarDayStatus({
    required this.date,
    required this.isOpen,
  });
}
