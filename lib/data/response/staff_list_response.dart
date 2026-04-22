import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/domain/doctor.dart';
import 'package:e_health/data/response/avatar_response.dart';

part 'staff_list_response.g.dart';

@JsonSerializable()
class StaffListResponse {
  final String? status;
  final StaffListData? data;

  bool get isSuccess => status == 'success';

  StaffListResponse({this.status, this.data});

  factory StaffListResponse.fromJson(Map<String, dynamic> json) =>
      _$StaffListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StaffListResponseToJson(this);
}

@JsonSerializable()
class StaffListData {
  final List<StaffItemResponse>? items;
  final int? total;
  final int? page;
  final int? limit;
  final int? totalPages;

  StaffListData({
    this.items,
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory StaffListData.fromJson(Map<String, dynamic> json) =>
      _$StaffListDataFromJson(json);

  Map<String, dynamic> toJson() => _$StaffListDataToJson(this);
}

@JsonSerializable()
class StaffItemResponse {
  @JsonKey(name: 'users_id')
  final String? userId;
  final String? email;
  final String? phone;
  final String? status;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final List<String>? roles;
  @JsonKey(name: 'user_profiles_id')
  final String? profileId;
  @JsonKey(name: 'full_name')
  final String? fullName;
  final String? dob;
  final String? gender;
  @JsonKey(name: 'avatar_url', fromJson: _parseAvatar)
  final List<AvatarResponse>? avatar;
  @JsonKey(name: 'doctors_id')
  final String? doctorsId;
  @JsonKey(name: 'doctor_title')
  final String? doctorTitle;
  @JsonKey(name: 'consultation_fee')
  final String? consultationFee;
  @JsonKey(name: 'specialty_id')
  final String? specialtyId;
  @JsonKey(name: 'specialty_name')
  final String? specialtyName;
  @JsonKey(name: 'facility_name')
  final String? facilityName;

  StaffItemResponse({
    this.userId,
    this.email,
    this.phone,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.roles,
    this.profileId,
    this.fullName,
    this.dob,
    this.gender,
    this.avatar,
    this.doctorsId,
    this.doctorTitle,
    this.consultationFee,
    this.specialtyId,
    this.specialtyName,
    this.facilityName,
  });

  factory StaffItemResponse.fromJson(Map<String, dynamic> json) =>
      _$StaffItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StaffItemResponseToJson(this);

  static List<AvatarResponse>? _parseAvatar(dynamic json) {
    if (json == null) return null;
    if (json is List) {
      return json
          .map((e) => AvatarResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (json is Map) {
      return [AvatarResponse.fromJson(json as Map<String, dynamic>)];
    }
    return null;
  }

  Doctor map() {
    return Doctor(
      id: profileId,
      serverId: doctorsId,
      userId: userId,
      title: doctorTitle,
      fullName: fullName,
      specialtyName: specialtyName,
      specialtyId: specialtyId,
      avatarUrl: avatar?.map((e) => e.map()).toList() ?? [],
      phone: phone,
      consultationFee: consultationFee,
      facilityName: facilityName,
    );
  }
}
