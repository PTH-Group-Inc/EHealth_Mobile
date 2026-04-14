import 'package:equatable/equatable.dart';

class Department extends Equatable {
  final String? departmentsId;
  final String? branchId;
  final String? facilityId;
  final String? code;
  final String? name;
  final String? description;
  final String? logoUrl;
  final String? status;
  final String? groupType;
  final String? branchName;
  final String? facilityName;

  const Department({
    this.departmentsId,
    this.branchId,
    this.facilityId,
    this.code,
    this.name,
    this.description,
    this.logoUrl,
    this.status,
    this.groupType,
    this.branchName,
    this.facilityName,
  });

  @override
  List<Object?> get props => [
    departmentsId,
    branchId,
    facilityId,
    code,
    name,
    description,
    status,
    groupType,
    branchName,
    facilityName,
    logoUrl,
  ];
}
