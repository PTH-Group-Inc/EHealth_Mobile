import 'package:json_annotation/json_annotation.dart';
import '../../domain/doctor.dart';
import 'avatar_response.dart';

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
  @JsonKey(name: 'avatar_url')
  final List<AvatarResponse>? avatar;
  @JsonKey(name: 'doctor_title')
  final String? doctorTitle;
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
    this.doctorTitle,
    this.specialtyName,
    this.facilityName,
  });

  factory StaffItemResponse.fromJson(Map<String, dynamic> json) =>
      _$StaffItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StaffItemResponseToJson(this);

  Doctor map() {
    return Doctor(
      id: profileId,
      userId: userId,
      title: doctorTitle,
      fullName: fullName,
      specialtyName: specialtyName,
      avatarUrl: (avatar != null && avatar!.isNotEmpty) ? avatar![0].url : null,
      phone: phone,
    );
  }
}
