import 'package:json_annotation/json_annotation.dart';

part 'book_patient_appointment_request.g.dart';

@JsonSerializable()
class BookPatientAppointmentRequest {
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
  
  @JsonKey(name: 'doctor_id')
  final String doctorId;
  
  @JsonKey(name: 'slot_id')
  final String slotId;
  
  @JsonKey(name: 'room_id')
  final String roomId;
  
  @JsonKey(name: 'facility_service_id')
  final String facilityServiceId;

  BookPatientAppointmentRequest({
    required this.patientId,
    required this.branchId,
    required this.shiftId,
    required this.appointmentDate,
    required this.bookingChannel,
    required this.reasonForVisit,
    required this.doctorId,
    required this.slotId,
    required this.roomId,
    required this.facilityServiceId,
  });

  factory BookPatientAppointmentRequest.fromJson(Map<String, dynamic> json) =>
      _$BookPatientAppointmentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BookPatientAppointmentRequestToJson(this);
}
