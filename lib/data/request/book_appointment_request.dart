import 'package:json_annotation/json_annotation.dart';

part 'book_appointment_request.g.dart';

@JsonSerializable()
class BookAppointmentRequest {
  @JsonKey(name: 'patient_id')
  final String patientId;
  
  @JsonKey(name: 'branch_id')
  final String branchId;
  
  @JsonKey(name: 'shift_id')
  final String shiftId;
  
  @JsonKey(name: 'appointment_date')
  final String appointmentDate;
  
  @JsonKey(name: 'booking_channel')
  final String bookingChannel;
  
  @JsonKey(name: 'reason_for_visit')
  final String reasonForVisit;
  
  @JsonKey(name: 'symptoms_notes')
  final String symptomsNotes;
  
  @JsonKey(name: 'facility_service_id')
  final String facilityServiceId;

  @JsonKey(name: 'slot_id')
  final String slotId;

  BookAppointmentRequest({
    required this.patientId,
    required this.branchId,
    required this.shiftId,
    required this.appointmentDate,
    required this.bookingChannel,
    required this.reasonForVisit,
    required this.symptomsNotes,
    required this.facilityServiceId,
    required this.slotId,
  });

  factory BookAppointmentRequest.fromJson(Map<String, dynamic> json) =>
      _$BookAppointmentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BookAppointmentRequestToJson(this);
}
