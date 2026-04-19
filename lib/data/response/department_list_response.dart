import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/data/response/department_response.dart';
import 'package:e_health/data/response/base_response/pagination_response.dart';

part 'department_list_response.g.dart';

@JsonSerializable()
class DepartmentListResponse {
  final bool? success;
  final DepartmentListData? data;
  final String? message;
  final String? status;

  bool get isSuccess => success == true || status == 'success';

  DepartmentListResponse({this.success, this.data, this.message, this.status});

  factory DepartmentListResponse.fromJson(Map<String, dynamic> json) =>
      _$DepartmentListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentListResponseToJson(this);
}

@JsonSerializable()
class DepartmentListData {
  final List<DepartmentResponse>? items;
  final PaginationResponse? pagination;

  DepartmentListData({this.items, this.pagination});

  factory DepartmentListData.fromJson(Map<String, dynamic> json) =>
      _$DepartmentListDataFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentListDataToJson(this);
}
