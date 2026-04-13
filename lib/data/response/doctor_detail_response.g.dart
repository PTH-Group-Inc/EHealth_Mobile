// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorDetailResponse _$DoctorDetailResponseFromJson(
  Map<String, dynamic> json,
) => DoctorDetailResponse(
  usersId: json['users_id'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  status: json['status'] as String?,
  fullName: json['full_name'] as String?,
  dob: json['dob'] as String?,
  gender: json['gender'] as String?,
  identityCardNumber: json['identity_card_number'] as String?,
  avatar: (json['avatar_url'] as List<dynamic>?)
      ?.map((e) => AvatarResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  address: json['address'] as String?,
  signatureUrl: json['signature_url'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  userProfilesId: json['user_profiles_id'] as String?,
  doctorsId: json['doctors_id'] as String?,
  doctorTitle: json['doctor_title'] as String?,
  biography: json['biography'] as String?,
  consultationFee: json['consultation_fee'] as String?,
  specialtyId: json['specialty_id'] as String?,
  specialtyName: json['specialty_name'] as String?,
  facilities: (json['facilities'] as List<dynamic>?)
      ?.map((e) => DoctorFacilityResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DoctorDetailResponseToJson(
  DoctorDetailResponse instance,
) => <String, dynamic>{
  'users_id': instance.usersId,
  'email': instance.email,
  'phone': instance.phone,
  'status': instance.status,
  'full_name': instance.fullName,
  'dob': instance.dob,
  'gender': instance.gender,
  'identity_card_number': instance.identityCardNumber,
  'avatar_url': instance.avatar,
  'address': instance.address,
  'signature_url': instance.signatureUrl,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'user_profiles_id': instance.userProfilesId,
  'doctors_id': instance.doctorsId,
  'doctor_title': instance.doctorTitle,
  'biography': instance.biography,
  'consultation_fee': instance.consultationFee,
  'specialty_id': instance.specialtyId,
  'specialty_name': instance.specialtyName,
  'facilities': instance.facilities,
};

DoctorFacilityResponse _$DoctorFacilityResponseFromJson(
  Map<String, dynamic> json,
) => DoctorFacilityResponse(
  userBranchDeptId: json['user_branch_dept_id'] as String?,
  branchId: json['branch_id'] as String?,
  branchName: json['branch_name'] as String?,
  departmentId: json['department_id'] as String?,
  departmentName: json['department_name'] as String?,
  roleTitle: json['role_title'] as String?,
  facilityName: json['facility_name'] as String?,
  facilityId: json['facility_id'] as String?,
);

Map<String, dynamic> _$DoctorFacilityResponseToJson(
  DoctorFacilityResponse instance,
) => <String, dynamic>{
  'user_branch_dept_id': instance.userBranchDeptId,
  'branch_id': instance.branchId,
  'branch_name': instance.branchName,
  'department_id': instance.departmentId,
  'department_name': instance.departmentName,
  'role_title': instance.roleTitle,
  'facility_name': instance.facilityName,
  'facility_id': instance.facilityId,
};
