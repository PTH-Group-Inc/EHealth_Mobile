import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/data/response/specialty_response.dart';
import 'package:e_health/data/response/base_response/meta_response.dart';

part 'specialty_list_response.g.dart';

@JsonSerializable()
class SpecialtyListResponse {
  final bool? success;
  final String? message;
  final List<SpecialtyResponse>? data;
  final MetaResponse? meta;

  SpecialtyListResponse({this.success, this.message, this.data, this.meta});

  factory SpecialtyListResponse.fromJson(Map<String, dynamic> json) =>
      _$SpecialtyListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialtyListResponseToJson(this);
}
