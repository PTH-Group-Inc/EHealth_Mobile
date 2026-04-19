// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/domain/medical_history.dart';

part 'medical_history_response.g.dart';

@JsonSerializable()
class MedicalHistoryListResponse {
  final bool success;
  final MedicalHistoryPageData data;

  MedicalHistoryListResponse({required this.success, required this.data});

  factory MedicalHistoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$MedicalHistoryListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MedicalHistoryListResponseToJson(this);
}

@JsonSerializable()
class MedicalHistoryPageData {
  final List<MedicalHistoryResponse> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  MedicalHistoryPageData({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory MedicalHistoryPageData.fromJson(Map<String, dynamic> json) =>
      _$MedicalHistoryPageDataFromJson(json);
  Map<String, dynamic> toJson() => _$MedicalHistoryPageDataToJson(this);
}

@JsonSerializable()
class MedicalHistoryResponse {
  final String encounters_id;
  final String appointment_id;
  final String patient_id;
  final String doctor_id;
  final String room_id;
  final String encounter_type;
  final String start_time;
  final String? end_time;
  final String status;
  final String created_at;
  final String doctor_name;
  final String doctor_title;
  final String specialty_name;
  final String room_name;
  final String room_code;
  final String patient_code;
  final String patient_name;
  final String? chief_complaint;
  final String? primary_diagnosis;

  MedicalHistoryResponse({
    required this.encounters_id,
    required this.appointment_id,
    required this.patient_id,
    required this.doctor_id,
    required this.room_id,
    required this.encounter_type,
    required this.start_time,
    this.end_time,
    required this.status,
    required this.created_at,
    required this.doctor_name,
    required this.doctor_title,
    required this.specialty_name,
    required this.room_name,
    required this.room_code,
    required this.patient_code,
    required this.patient_name,
    this.chief_complaint,
    this.primary_diagnosis,
  });

  factory MedicalHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$MedicalHistoryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MedicalHistoryResponseToJson(this);

  MedicalHistory map() {
    return MedicalHistory(
      encountersId: encounters_id,
      appointmentId: appointment_id,
      patientId: patient_id,
      doctorId: doctor_id,
      roomId: room_id,
      encounterType: encounter_type,
      startTime: DateTime.parse(start_time),
      endTime: end_time != null ? DateTime.parse(end_time!) : null,
      status: status,
      createdAt: DateTime.parse(created_at),
      doctorName: doctor_name,
      doctorTitle: doctor_title,
      specialtyName: specialty_name,
      roomName: room_name,
      roomCode: room_code,
      patientCode: patient_code,
      patientName: patient_name,
      chiefComplaint: chief_complaint,
      primaryDiagnosis: primary_diagnosis,
    );
  }
}
