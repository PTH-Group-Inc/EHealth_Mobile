// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_history_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalHistoryListResponse _$MedicalHistoryListResponseFromJson(
  Map<String, dynamic> json,
) => MedicalHistoryListResponse(
  success: json['success'] as bool,
  data: MedicalHistoryPageData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MedicalHistoryListResponseToJson(
  MedicalHistoryListResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

MedicalHistoryPageData _$MedicalHistoryPageDataFromJson(
  Map<String, dynamic> json,
) => MedicalHistoryPageData(
  data: (json['data'] as List<dynamic>)
      .map((e) => MedicalHistoryResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
);

Map<String, dynamic> _$MedicalHistoryPageDataToJson(
  MedicalHistoryPageData instance,
) => <String, dynamic>{
  'data': instance.data,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
  'totalPages': instance.totalPages,
};

MedicalHistoryResponse _$MedicalHistoryResponseFromJson(
  Map<String, dynamic> json,
) => MedicalHistoryResponse(
  encounters_id: json['encounters_id'] as String,
  appointment_id: json['appointment_id'] as String,
  patient_id: json['patient_id'] as String,
  doctor_id: json['doctor_id'] as String,
  room_id: json['room_id'] as String,
  encounter_type: json['encounter_type'] as String,
  start_time: json['start_time'] as String,
  end_time: json['end_time'] as String?,
  status: json['status'] as String,
  created_at: json['created_at'] as String,
  doctor_name: json['doctor_name'] as String,
  doctor_title: json['doctor_title'] as String,
  specialty_name: json['specialty_name'] as String,
  room_name: json['room_name'] as String,
  room_code: json['room_code'] as String,
  patient_code: json['patient_code'] as String,
  patient_name: json['patient_name'] as String,
  chief_complaint: json['chief_complaint'] as String?,
  primary_diagnosis: json['primary_diagnosis'] as String?,
);

Map<String, dynamic> _$MedicalHistoryResponseToJson(
  MedicalHistoryResponse instance,
) => <String, dynamic>{
  'encounters_id': instance.encounters_id,
  'appointment_id': instance.appointment_id,
  'patient_id': instance.patient_id,
  'doctor_id': instance.doctor_id,
  'room_id': instance.room_id,
  'encounter_type': instance.encounter_type,
  'start_time': instance.start_time,
  'end_time': instance.end_time,
  'status': instance.status,
  'created_at': instance.created_at,
  'doctor_name': instance.doctor_name,
  'doctor_title': instance.doctor_title,
  'specialty_name': instance.specialty_name,
  'room_name': instance.room_name,
  'room_code': instance.room_code,
  'patient_code': instance.patient_code,
  'patient_name': instance.patient_name,
  'chief_complaint': instance.chief_complaint,
  'primary_diagnosis': instance.primary_diagnosis,
};
