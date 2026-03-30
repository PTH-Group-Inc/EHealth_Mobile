import 'package:equatable/equatable.dart';

class DoctorDetail extends Equatable {
  final String? usersId;
  final String? email;
  final String? phone;
  final String? status;
  final String? fullName;
  final String? dob;
  final String? gender;
  final String? identityCardNumber;
  final String? avatarUrl;
  final String? address;
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
    this.avatarUrl,
    this.address,
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
        avatarUrl,
        address,
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

  const DoctorFacility({
    this.userBranchDeptId,
    this.branchId,
    this.branchName,
    this.departmentId,
    this.departmentName,
    this.roleTitle,
    this.facilityName,
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
      ];
}
