// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentListResponse _$DepartmentListResponseFromJson(
  Map<String, dynamic> json,
) => DepartmentListResponse(
  success: json['success'] as bool?,
  data: json['data'] == null
      ? null
      : DepartmentListData.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$DepartmentListResponseToJson(
  DepartmentListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
  'status': instance.status,
};

DepartmentListData _$DepartmentListDataFromJson(Map<String, dynamic> json) =>
    DepartmentListData(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => DepartmentResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] == null
          ? null
          : PaginationResponse.fromJson(
              json['pagination'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$DepartmentListDataToJson(DepartmentListData instance) =>
    <String, dynamic>{
      'items': instance.items,
      'pagination': instance.pagination,
    };
