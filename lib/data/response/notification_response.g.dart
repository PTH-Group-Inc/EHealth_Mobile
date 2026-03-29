// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationResponse _$NotificationResponseFromJson(
  Map<String, dynamic> json,
) => NotificationResponse(
  user_notifications_id: json['user_notifications_id'] as String?,
  user_id: json['user_id'] as String?,
  template_id: json['template_id'] as String?,
  title: json['title'] as String?,
  content: json['content'] as String?,
  data_payload: json['data_payload'] as Map<String, dynamic>?,
  is_read: json['is_read'] as bool?,
  read_at: json['read_at'] as String?,
  created_at: json['created_at'] as String?,
);

Map<String, dynamic> _$NotificationResponseToJson(
  NotificationResponse instance,
) => <String, dynamic>{
  'user_notifications_id': instance.user_notifications_id,
  'user_id': instance.user_id,
  'template_id': instance.template_id,
  'title': instance.title,
  'content': instance.content,
  'data_payload': instance.data_payload,
  'is_read': instance.is_read,
  'read_at': instance.read_at,
  'created_at': instance.created_at,
};
