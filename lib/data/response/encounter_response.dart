import 'package:json_annotation/json_annotation.dart';
import '../../domain/encounter.dart';

part 'encounter_response.g.dart';

@JsonSerializable()
class EncounterResponse {
  @JsonKey(name: 'encounters_id')
  final String id;
  
  @JsonKey(name: 'appointment_id')
  final String appointmentId;
  
  @JsonKey(name: 'patient_id')
  final String patientId;
  
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  
  @JsonKey(name: 'room_id')
  final String? roomId;
  
  @JsonKey(name: 'encounter_type')
  final String? encounterType;
  
  @JsonKey(name: 'start_time')
  final String? startTime;
  
  @JsonKey(name: 'end_time')
  final String? endTime;
  
  @JsonKey(name: 'status')
  final String status;
  
  @JsonKey(name: 'patient_name')
  final String? patientName;
  
  @JsonKey(name: 'doctor_name')
  final String? doctorName;
  
  @JsonKey(name: 'appointment_code')
  final String? appointmentCode;

  @JsonKey(name: 'conclusion')
  final String? conclusion;

  @JsonKey(name: 'notes')
  final String? notes;

  @JsonKey(name: 'visit_number')
  final int? visitNumber;

  @JsonKey(name: 'patient_code')
  final String? patientCode;

  @JsonKey(name: 'doctor_title')
  final String? doctorTitle;

  @JsonKey(name: 'room_name')
  final String? roomName;

  EncounterResponse({
    required this.id,
    required this.appointmentId,
    required this.patientId,
    this.doctorId,
    this.roomId,
    this.encounterType,
    this.startTime,
    this.endTime,
    required this.status,
    this.patientName,
    this.doctorName,
    this.appointmentCode,
    this.conclusion,
    this.notes,
    this.visitNumber,
    this.patientCode,
    this.doctorTitle,
    this.roomName,
  });

  factory EncounterResponse.fromJson(Map<String, dynamic> json) =>
      _$EncounterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EncounterResponseToJson(this);

  Encounter map() {
    return Encounter(
      id: id,
      appointmentId: appointmentId,
      patientId: patientId,
      doctorId: doctorId,
      roomId: roomId,
      encounterType: encounterType,
      startTime: startTime != null ? DateTime.tryParse(startTime!) : null,
      endTime: endTime != null ? DateTime.tryParse(endTime!) : null,
      status: status,
      patientName: patientName,
      doctorName: doctorName,
      appointmentCode: appointmentCode,
      conclusion: conclusion,
      notes: notes,
      visitNumber: visitNumber,
      patientCode: patientCode,
      doctorTitle: doctorTitle,
      roomName: roomName,
    );
  }
}
