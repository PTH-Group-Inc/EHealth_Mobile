// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationListResponse _$NotificationListResponseFromJson(
  Map<String, dynamic> json,
) => NotificationListResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => NotificationResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: json['meta'] == null
      ? null
      : NotificationMeta.fromJson(json['meta'] as Map<String, dynamic>),
  pagination: json['pagination'] == null
      ? null
      : PaginationResponse.fromJson(json['pagination'] as Map<String, dynamic>),
  status: json['status'] as String?,
);

Map<String, dynamic> _$NotificationListResponseToJson(
  NotificationListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'meta': instance.meta,
  'pagination': instance.pagination,
  'status': instance.status,
};

NotificationMeta _$NotificationMetaFromJson(Map<String, dynamic> json) =>
    NotificationMeta(unreadCount: (json['unread_count'] as num?)?.toInt());

Map<String, dynamic> _$NotificationMetaToJson(NotificationMeta instance) =>
    <String, dynamic>{'unread_count': instance.unreadCount};
