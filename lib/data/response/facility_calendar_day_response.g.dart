// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_calendar_day_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacilityCalendarResponse _$FacilityCalendarResponseFromJson(
  Map<String, dynamic> json,
) => FacilityCalendarResponse(
  facilityId: json['facility_id'] as String,
  month: (json['month'] as num).toInt(),
  year: (json['year'] as num).toInt(),
  days: (json['days'] as List<dynamic>)
      .map(
        (e) => FacilityCalendarDayResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$FacilityCalendarResponseToJson(
  FacilityCalendarResponse instance,
) => <String, dynamic>{
  'facility_id': instance.facilityId,
  'month': instance.month,
  'year': instance.year,
  'days': instance.days,
};

FacilityCalendarDayResponse _$FacilityCalendarDayResponseFromJson(
  Map<String, dynamic> json,
) => FacilityCalendarDayResponse(
  date: json['date'] as String,
  isOpen: json['is_open'] as bool,
  dayOfWeek: (json['day_of_week'] as num?)?.toInt(),
  dayName: json['day_name'] as String?,
);

Map<String, dynamic> _$FacilityCalendarDayResponseToJson(
  FacilityCalendarDayResponse instance,
) => <String, dynamic>{
  'date': instance.date,
  'is_open': instance.isOpen,
  'day_of_week': instance.dayOfWeek,
  'day_name': instance.dayName,
};
