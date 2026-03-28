import 'package:json_annotation/json_annotation.dart';
import '../../domain/department.dart';

part 'department_response.g.dart';

@JsonSerializable()
class DepartmentResponse {
  @JsonKey(name: 'departments_id')
  final String? departmentsId;
  @JsonKey(name: 'branch_id')
  final String? branchId;
  final String? code;
  final String? name;
  final String? description;
  final String? status;
  @JsonKey(name: 'branch_name')
  final String? branchName;
  @JsonKey(name: 'facility_name')
  final String? facilityName;

  DepartmentResponse({
    this.departmentsId,
    this.branchId,
    this.code,
    this.name,
    this.description,
    this.status,
    this.branchName,
    this.facilityName,
  });

  factory DepartmentResponse.fromJson(Map<String, dynamic> json) =>
      _$DepartmentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentResponseToJson(this);

  Department map() {
    return Department(
      id: departmentsId,
      branchId: branchId,
      code: code,
      name: name,
      description: description,
      status: status,
      branchName: branchName,
      facilityName: facilityName,
    );
  }
}
