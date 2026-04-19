// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/domain/notification_item.dart';

part 'notification_response.g.dart';

@JsonSerializable()
class NotificationResponse {
  final String? user_notifications_id;
  final String? user_id;
  final String? template_id;
  final String? title;
  final String? content;
  final Map<String, dynamic>? data_payload;
  final bool? is_read;
  final String? read_at;
  final String? created_at;

  NotificationResponse({
    this.user_notifications_id,
    this.user_id,
    this.template_id,
    this.title,
    this.content,
    this.data_payload,
    this.is_read,
    this.read_at,
    this.created_at,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);

  NotificationItem map() {
    return NotificationItem(
      id: user_notifications_id,
      userId: user_id,
      templateId: template_id,
      title: title,
      content: content,
      dataPayload: data_payload,
      isRead: is_read,
      readAt: read_at != null ? DateTime.tryParse(read_at!) : null,
      createdAt: created_at != null ? DateTime.tryParse(created_at!) : null,
    );
  }
}
