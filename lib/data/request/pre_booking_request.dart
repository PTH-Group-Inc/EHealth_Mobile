import 'package:json_annotation/json_annotation.dart';

part 'pre_booking_request.g.dart';

@JsonSerializable()
class PreBookingRequest {
  @JsonKey(name: 'patient_id')
  final String patientId;

  @JsonKey(name: 'branch_id')
  final String branchId;

  @JsonKey(name: 'appointment_date')
  final String appointmentDate;

  @JsonKey(name: 'facility_service_id')
  final String facilityServiceId;

  @JsonKey(name: 'slot_id')
  final String slotId;

  @JsonKey(name: 'shift_id')
  final String shiftId;

  @JsonKey(name: 'doctor_id')
  final String? doctorId;

  @JsonKey(name: 'notes')
  final String? notes;

  @JsonKey(name: 'booking_channel')
  final String bookingChannel;

  PreBookingRequest({
    required this.patientId,
    required this.branchId,
    required this.appointmentDate,
    required this.facilityServiceId,
    required this.slotId,
    required this.shiftId,
    this.doctorId,
    this.notes,
    this.bookingChannel = 'APP',
  });

  factory PreBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$PreBookingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PreBookingRequestToJson(this);
}
