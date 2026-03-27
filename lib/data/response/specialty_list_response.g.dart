// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialty_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialtyListResponse _$SpecialtyListResponseFromJson(
  Map<String, dynamic> json,
) => SpecialtyListResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => SpecialtyResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: json['meta'] == null
      ? null
      : MetaResponse.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SpecialtyListResponseToJson(
  SpecialtyListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'meta': instance.meta,
};
