// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestResponse<T> _$RestResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => RestResponse<T>(
  success: json['success'] as bool?,
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
  message: json['message'] as String?,
);

Map<String, dynamic> _$RestResponseToJson<T>(
  RestResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'success': instance.success,
  'data': _$nullableGenericToJson(instance.data, toJsonT),
  'message': instance.message,
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);
