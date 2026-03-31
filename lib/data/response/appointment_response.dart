import 'package:json_annotation/json_annotation.dart';
import '../../domain/booked_appointment.dart';

part 'appointment_response.g.dart';

@JsonSerializable()
class AppointmentResponse {
  @JsonKey(name: 'appointments_id')
  final String appointmentsId;
  
  @JsonKey(name: 'appointment_code')
  final String appointmentCode;
  
  @JsonKey(name: 'branch_id')
  final String branchId;
  
  @JsonKey(name: 'slot_id')
  final String? slotId;
  
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  
  @JsonKey(name: 'room_id')
  final String? roomId;
  
  final String status;

  AppointmentResponse({
    required this.appointmentsId,
    required this.appointmentCode,
    required this.branchId,
    this.slotId,
    this.doctorId,
    this.roomId,
    required this.status,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) =>
      _$AppointmentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AppointmentResponseToJson(this);

  BookedAppointment map() {
    return BookedAppointment(
      id: appointmentsId,
      code: appointmentCode,
      branchId: branchId,
      slotId: slotId,
      doctorId: doctorId,
      roomId: roomId,
      status: status,
    );
  }
}
