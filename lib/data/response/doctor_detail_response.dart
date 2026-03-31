import 'package:json_annotation/json_annotation.dart';
import '../../domain/doctor_detail.dart';
import 'avatar_response.dart';

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
  @JsonKey(name: 'avatar_url')
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
      avatarUrl: (avatar != null && avatar!.isNotEmpty) ? avatar![0].url : null,
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

  const DoctorFacilityResponse({
    this.userBranchDeptId,
    this.branchId,
    this.branchName,
    this.departmentId,
    this.departmentName,
    this.roleTitle,
    this.facilityName,
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
    );
  }
}
