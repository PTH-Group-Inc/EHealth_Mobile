import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/domain/doctor_detail.dart';
import 'package:e_health/data/response/avatar_response.dart';

part 'doctor_detail_response.g.dart';

@JsonSerializable()
class DoctorDetailResponse {
  @JsonKey(name: 'users_id')
  final String? usersId;
  final String? email;
  final String? phone;
  final String? status;
  @JsonKey(name: 'full_name')
  final String? fullName;
  final String? dob;
  final String? gender;
  @JsonKey(name: 'identity_card_number')
  final String? identityCardNumber;
  @JsonKey(name: 'avatar_url', fromJson: _parseAvatar)
  final List<AvatarResponse>? avatar;
  final String? address;
  @JsonKey(name: 'signature_url')
  final String? signatureUrl;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'user_profiles_id')
  final String? userProfilesId;
  @JsonKey(name: 'doctors_id')
  final String? doctorsId;
  @JsonKey(name: 'doctor_title')
  final String? doctorTitle;
  final String? biography;
  @JsonKey(name: 'consultation_fee')
  final String? consultationFee;
  @JsonKey(name: 'specialty_id')
  final String? specialtyId;
  @JsonKey(name: 'specialty_name')
  final String? specialtyName;
  final List<DoctorFacilityResponse>? facilities;

  const DoctorDetailResponse({
    this.usersId,
    this.email,
    this.phone,
    this.status,
    this.fullName,
    this.dob,
    this.gender,
    this.identityCardNumber,
    this.avatar,
    this.address,
    this.signatureUrl,
    this.createdAt,
    this.updatedAt,
    this.userProfilesId,
    this.doctorsId,
    this.doctorTitle,
    this.biography,
    this.consultationFee,
    this.specialtyId,
    this.specialtyName,
    this.facilities,
  });

  factory DoctorDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$DoctorDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorDetailResponseToJson(this);

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

  DoctorDetail map() {
    return DoctorDetail(
      usersId: usersId,
      email: email,
      phone: phone,
      status: status,
      fullName: fullName,
      dob: dob,
      gender: gender,
      identityCardNumber: identityCardNumber,
      avatars: avatar?.map((e) => e.map()).toList(),
      address: address,
      signatureUrl: signatureUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userProfilesId: userProfilesId,
      doctorsId: doctorsId,
      doctorTitle: doctorTitle,
      biography: biography,
      consultationFee: consultationFee,
      specialtyId: specialtyId,
      specialtyName: specialtyName,
      facilities: facilities?.map((e) => e.map()).toList(),
    );
  }
}

@JsonSerializable()
class DoctorFacilityResponse {
  @JsonKey(name: 'user_branch_dept_id')
  final String? userBranchDeptId;
  @JsonKey(name: 'branch_id')
  final String? branchId;
  @JsonKey(name: 'branch_name')
  final String? branchName;
  @JsonKey(name: 'department_id')
  final String? departmentId;
  @JsonKey(name: 'department_name')
  final String? departmentName;
  @JsonKey(name: 'role_title')
  final String? roleTitle;
  @JsonKey(name: 'facility_name')
  final String? facilityName;
  @JsonKey(name: 'facility_id')
  final String? facilityId;

  const DoctorFacilityResponse({
    this.userBranchDeptId,
    this.branchId,
    this.branchName,
    this.departmentId,
    this.departmentName,
    this.roleTitle,
    this.facilityName,
    this.facilityId,
  });

  factory DoctorFacilityResponse.fromJson(Map<String, dynamic> json) =>
      _$DoctorFacilityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorFacilityResponseToJson(this);

  DoctorFacility map() {
    return DoctorFacility(
      userBranchDeptId: userBranchDeptId,
      branchId: branchId,
      branchName: branchName,
      departmentId: departmentId,
      departmentName: departmentName,
      roleTitle: roleTitle,
      facilityName: facilityName,
      facilityId: facilityId,
    );
  }
}

