import 'package:equatable/equatable.dart';
import 'avatar.dart';

class DoctorDetail extends Equatable {
  final String? usersId;
  final String? email;
  final String? phone;
  final String? status;
  final String? fullName;
  final String? dob;
  final String? gender;
  final String? identityCardNumber;
  final List<Avatar>? avatars;
  final String? address;
  final String? signatureUrl;
  final String? createdAt;
  final String? updatedAt;
  final String? userProfilesId;
  final String? doctorsId;
  final String? doctorTitle;
  final String? biography;
  final String? consultationFee;
  final String? specialtyId;
  final String? specialtyName;
  final List<DoctorFacility>? facilities;

  const DoctorDetail({
    this.usersId,
    this.email,
    this.phone,
    this.status,
    this.fullName,
    this.dob,
    this.gender,
    this.identityCardNumber,
    this.avatars,
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

  @override
  List<Object?> get props => [
        usersId,
        email,
        phone,
        status,
        fullName,
        dob,
        gender,
        identityCardNumber,
        avatars,
        address,
        signatureUrl,
        createdAt,
        updatedAt,
        userProfilesId,
        doctorsId,
        doctorTitle,
        biography,
        consultationFee,
        specialtyId,
        specialtyName,
        facilities,
      ];
}

class DoctorFacility extends Equatable {
  final String? userBranchDeptId;
  final String? branchId;
  final String? branchName;
  final String? departmentId;
  final String? departmentName;
  final String? roleTitle;
  final String? facilityName;
  final String? facilityId;

  const DoctorFacility({
    this.userBranchDeptId,
    this.branchId,
    this.branchName,
    this.departmentId,
    this.departmentName,
    this.roleTitle,
    this.facilityName,
    this.facilityId,
  });

  @override
  List<Object?> get props => [
        userBranchDeptId,
        branchId,
        branchName,
        departmentId,
        departmentName,
        roleTitle,
        facilityName,
        facilityId,
      ];
}

