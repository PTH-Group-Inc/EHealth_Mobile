// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientResponse _$PatientResponseFromJson(Map<String, dynamic> json) =>
    PatientResponse(
      id: json['id'] as String,
      patientCode: json['patient_code'] as String,
      accountId: json['account_id'] as String?,
      fullName: json['full_name'] as String,
      dateOfBirth: json['date_of_birth'] as String,
      gender: json['gender'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      idCardNumber: json['id_card_number'] as String?,
      address: json['address'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      hasInsurance: json['has_insurance'] as bool,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$PatientResponseToJson(PatientResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patient_code': instance.patientCode,
      'account_id': instance.accountId,
      'full_name': instance.fullName,
      'date_of_birth': instance.dateOfBirth,
      'gender': instance.gender,
      'phone_number': instance.phoneNumber,
      'email': instance.email,
      'id_card_number': instance.idCardNumber,
      'address': instance.address,
      'emergency_contact_name': instance.emergencyContactName,
      'emergency_contact_phone': instance.emergencyContactPhone,
      'has_insurance': instance.hasInsurance,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
