// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialty_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialtyResponse _$SpecialtyResponseFromJson(Map<String, dynamic> json) =>
    SpecialtyResponse(
      specialtiesId: json['specialties_id'] as String?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$SpecialtyResponseToJson(SpecialtyResponse instance) =>
    <String, dynamic>{
      'specialties_id': instance.specialtiesId,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
    };
