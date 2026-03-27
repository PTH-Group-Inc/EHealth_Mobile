import 'package:json_annotation/json_annotation.dart';
import 'pagination_response.dart';

part 'page_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PageResponse<T> {
  final bool? success;
  final List<T>? data;
  final PaginationResponse? pagination;
  final String? message;

  PageResponse({this.success, this.data, this.pagination, this.message});

  factory PageResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PageResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PageResponseToJson(this, toJsonT);
}
