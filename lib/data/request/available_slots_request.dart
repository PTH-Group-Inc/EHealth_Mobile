import 'package:json_annotation/json_annotation.dart';

part 'available_slots_request.g.dart';

@JsonSerializable()
class AvailableSlotsRequest {
  @JsonKey(name: 'date')
  final String date;
  
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  
  @JsonKey(name: 'facility_id')
  final String facilityId;

  AvailableSlotsRequest({
    required this.date,
    this.doctorId,
    required this.facilityId,
  });



  factory AvailableSlotsRequest.fromJson(Map<String, dynamic> json) =>
      _$AvailableSlotsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableSlotsRequestToJson(this);
}
