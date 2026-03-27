import 'package:json_annotation/json_annotation.dart';

part 'meta_response.g.dart';

@JsonSerializable()
class MetaResponse {
  final int? total;
  final int? page;
  final int? limit;
  final int? totalPages;

  MetaResponse({this.total, this.page, this.limit, this.totalPages});

  factory MetaResponse.fromJson(Map<String, dynamic> json) =>
      _$MetaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MetaResponseToJson(this);
}
