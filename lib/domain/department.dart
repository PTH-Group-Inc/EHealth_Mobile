import 'package:equatable/equatable.dart';

class Department extends Equatable {
  final String? id;
  final String? branchId;
  final String? code;
  final String? name;
  final String? description;
  final String? status;
  final String? branchName;
  final String? facilityName;

  const Department({
    this.id,
    this.branchId,
    this.code,
    this.name,
    this.description,
    this.status,
    this.branchName,
    this.facilityName,
  });

  @override
  List<Object?> get props => [
        id,
        branchId,
        code,
        name,
        description,
        status,
        branchName,
        facilityName,
      ];
}
