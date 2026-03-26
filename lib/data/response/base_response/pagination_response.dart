import 'package:json_annotation/json_annotation.dart';
import '../../../domain/pagination.dart';

part 'pagination_response.g.dart';

@JsonSerializable()
class PaginationResponse {
  final int? page;
  final int? limit;
  @JsonKey(name: 'total_records')
  final int? totalRecords;
  @JsonKey(name: 'total_pages')
  final int? totalPages;

  PaginationResponse({
    this.page,
    this.limit,
    this.totalRecords,
    this.totalPages,
  });

  factory PaginationResponse.fromJson(Map<String, dynamic> json) =>
      _$PaginationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationResponseToJson(this);

  Pagination map() {
    return Pagination(
      page: page,
      limit: limit,
      totalRecords: totalRecords,
      totalPages: totalPages,
    );
  }
}
