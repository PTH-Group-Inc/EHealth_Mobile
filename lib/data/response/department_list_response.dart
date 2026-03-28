import 'package:json_annotation/json_annotation.dart';
import 'department_response.dart';
import 'base_response/pagination_response.dart';

part 'department_list_response.g.dart';

@JsonSerializable()
class DepartmentListResponse {
  final bool? success;
  final DepartmentListData? data;
  final String? message;

  DepartmentListResponse({this.success, this.data, this.message});

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
