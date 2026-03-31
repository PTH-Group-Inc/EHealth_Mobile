import 'package:json_annotation/json_annotation.dart';
import '../../domain/booked_appointment.dart';
import 'base_response/pagination_response.dart';

part 'appointment_list_response.g.dart';

@JsonSerializable()
class AppointmentListResponse {
  final bool? success;
  final String? message;
  final List<AppointmentListItemResponse>? data;
  @JsonKey(name: 'patient_id')
  final String? patientId;
  final PaginationResponse? pagination;

  AppointmentListResponse({
    this.success,
    this.message,
    this.data,
    this.patientId,
    this.pagination,
  });

  factory AppointmentListResponse.fromJson(Map<String, dynamic> json) =>
      _$AppointmentListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentListResponseToJson(this);
}

@JsonSerializable()
class AppointmentListItemResponse {
  @JsonKey(name: 'appointments_id')
  final String appointmentsId;
  @JsonKey(name: 'appointment_code')
  final String appointmentCode;
  @JsonKey(name: 'patient_id')
  final String? patientId;
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  @JsonKey(name: 'slot_id')
  final String? slotId;
  @JsonKey(name: 'room_id')
  final String? roomId;
  @JsonKey(name: 'facility_service_id')
  final String? facilityServiceId;
  @JsonKey(name: 'appointment_date')
  final String? appointmentDate;
  @JsonKey(name: 'booking_channel')
  final String? bookingChannel;
  @JsonKey(name: 'reason_for_visit')
  final String? reasonForVisit;
  @JsonKey(name: 'symptoms_notes')
  final String? symptomsNotes;
  final String status;
  final String? priority;
  @JsonKey(name: 'queue_number')
  final int? queueNumber;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'branch_id')
  final String branchId;
  @JsonKey(name: 'patient_name')
  final String? patientName;
  @JsonKey(name: 'doctor_name')
  final String? doctorName;
  @JsonKey(name: 'room_name')
  final String? roomName;
  @JsonKey(name: 'branch_name')
  final String? branchName;
  @JsonKey(name: 'service_name')
  final String? serviceName;
  @JsonKey(name: 'slot_start_time')
  final String? slotStartTime;
  @JsonKey(name: 'slot_end_time')
  final String? slotEndTime;

  AppointmentListItemResponse({
    required this.appointmentsId,
    required this.appointmentCode,
    this.patientId,
    this.doctorId,
    this.slotId,
    this.roomId,
    this.facilityServiceId,
    this.appointmentDate,
    this.bookingChannel,
    this.reasonForVisit,
    this.symptomsNotes,
    required this.status,
    this.priority,
    this.queueNumber,
    this.createdAt,
    this.updatedAt,
    required this.branchId,
    this.patientName,
    this.doctorName,
    this.roomName,
    this.branchName,
    this.serviceName,
    this.slotStartTime,
    this.slotEndTime,
  });

  factory AppointmentListItemResponse.fromJson(Map<String, dynamic> json) =>
      _$AppointmentListItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentListItemResponseToJson(this);

  BookedAppointment map() {
    return BookedAppointment(
      id: appointmentsId,
      code: appointmentCode,
      branchId: branchId,
      slotId: slotId,
      doctorId: doctorId,
      roomId: roomId,
      status: status,
      patientId: patientId,
      facilityServiceId: facilityServiceId,
      appointmentDate: appointmentDate,
      bookingChannel: bookingChannel,
      reasonForVisit: reasonForVisit,
      symptomsNotes: symptomsNotes,
      priority: priority,
      queueNumber: queueNumber,
      patientName: patientName,
      doctorName: doctorName,
      roomName: roomName,
      branchName: branchName,
      serviceName: serviceName,
      slotStartTime: slotStartTime,
      slotEndTime: slotEndTime,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }
}
