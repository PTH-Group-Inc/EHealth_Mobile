import 'package:json_annotation/json_annotation.dart';

part 'rest_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class RestResponse<T> {
  final bool? success;
  final T? data;
  final String? message;

  RestResponse({this.success, this.data, this.message});

  factory RestResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$RestResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$RestResponseToJson(this, toJsonT);
}
