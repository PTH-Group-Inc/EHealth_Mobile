import 'package:equatable/equatable.dart';
import 'package:e_health/domain/pagination.dart';


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

  Department copyWith({
    String? departmentsId,
    String? branchId,
    String? facilityId,
    String? code,
    String? name,
    String? description,
    String? logoUrl,
    String? status,
    String? groupType,
    String? branchName,
    String? facilityName,
  }) {
    return Department(
      departmentsId: departmentsId ?? this.departmentsId,
      branchId: branchId ?? this.branchId,
      facilityId: facilityId ?? this.facilityId,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      status: status ?? this.status,
      groupType: groupType ?? this.groupType,
      branchName: branchName ?? this.branchName,
      facilityName: facilityName ?? this.facilityName,
    );
  }

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

class DepartmentList extends Equatable {
  final List<Department> items;
  final Pagination? pagination;

  const DepartmentList({
    required this.items,
    this.pagination,
  });

  @override
  List<Object?> get props => [items, pagination];
}

