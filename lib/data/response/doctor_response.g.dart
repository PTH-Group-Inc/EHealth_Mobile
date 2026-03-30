// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorResponse _$DoctorResponseFromJson(Map<String, dynamic> json) =>
    DoctorResponse(
      id: json['doctors_id'] as String?,
      userId: json['user_id'] as String?,
      title: json['title'] as String?,
      consultationFee: json['consultation_fee'] as String?,
      fullName: json['full_name'] as String?,
      specialtyName: json['specialty_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$DoctorResponseToJson(DoctorResponse instance) =>
    <String, dynamic>{
      'doctors_id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'consultation_fee': instance.consultationFee,
      'full_name': instance.fullName,
      'specialty_name': instance.specialtyName,
      'avatar_url': instance.avatarUrl,
    };
