// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffListResponse _$StaffListResponseFromJson(Map<String, dynamic> json) =>
    StaffListResponse(
      status: json['status'] as String?,
      data: json['data'] == null
          ? null
          : StaffListData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StaffListResponseToJson(StaffListResponse instance) =>
    <String, dynamic>{'status': instance.status, 'data': instance.data};

StaffListData _$StaffListDataFromJson(Map<String, dynamic> json) =>
    StaffListData(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => StaffItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StaffListDataToJson(StaffListData instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'totalPages': instance.totalPages,
    };

StaffItemResponse _$StaffItemResponseFromJson(Map<String, dynamic> json) =>
    StaffItemResponse(
      userId: json['users_id'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      profileId: json['user_profiles_id'] as String?,
      fullName: json['full_name'] as String?,
      dob: json['dob'] as String?,
      gender: json['gender'] as String?,
      avatar: StaffItemResponse._parseAvatar(json['avatar_url']),
      doctorsId: json['doctors_id'] as String?,
      doctorTitle: json['doctor_title'] as String?,
      consultationFee: json['consultation_fee'] as String?,
      specialtyId: json['specialty_id'] as String?,
      specialtyName: json['specialty_name'] as String?,
      facilityName: json['facility_name'] as String?,
    );

Map<String, dynamic> _$StaffItemResponseToJson(StaffItemResponse instance) =>
    <String, dynamic>{
      'users_id': instance.userId,
      'email': instance.email,
      'phone': instance.phone,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'roles': instance.roles,
      'user_profiles_id': instance.profileId,
      'full_name': instance.fullName,
      'dob': instance.dob,
      'gender': instance.gender,
      'avatar_url': instance.avatar,
      'doctors_id': instance.doctorsId,
      'doctor_title': instance.doctorTitle,
      'consultation_fee': instance.consultationFee,
      'specialty_id': instance.specialtyId,
      'specialty_name': instance.specialtyName,
      'facility_name': instance.facilityName,
    };
