// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';
import '../../domain/department.dart';

part 'department_response.g.dart';

@JsonSerializable()
class DepartmentResponse {
  final String? departments_id;
  final String? branch_id;
  final String? code;
  final String? name;
  final String? description;
  final String? group_type;
  final String? status;
  final String? branch_name;
  final String? facility_name;
  final String? logo_url;

  DepartmentResponse({
    this.departments_id,
    this.branch_id,
    this.code,
    this.name,
    this.description,
    this.group_type,
    this.status,
    this.branch_name,
    this.facility_name,
    this.logo_url,
  });

  factory DepartmentResponse.fromJson(Map<String, dynamic> json) =>
      _$DepartmentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentResponseToJson(this);

  Department map() {
    return Department(
      id: departments_id,
      branchId: branch_id,
      code: code,
      name: name,
      description: description,
      groupType: group_type,
      status: status,
      branchName: branch_name,
      facilityName: facility_name,
      logoUrl: logo_url,
    );
  }
}
