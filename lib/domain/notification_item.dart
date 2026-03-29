import 'package:equatable/equatable.dart';

class NotificationItem extends Equatable {
  final String? id;
  final String? userId;
  final String? templateId;
  final String? title;
  final String? content;
  final Map<String, dynamic>? dataPayload;
  final bool? isRead;
  final DateTime? readAt;
  final DateTime? createdAt;

  const NotificationItem({
    this.id,
    this.userId,
    this.templateId,
    this.title,
    this.content,
    this.dataPayload,
    this.isRead,
    this.readAt,
    this.createdAt,
  });

  NotificationItem copyWith({
    String? id,
    String? userId,
    String? templateId,
    String? title,
    String? content,
    Map<String, dynamic>? dataPayload,
    bool? isRead,
    DateTime? readAt,
    DateTime? createdAt,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      templateId: templateId ?? this.templateId,
      title: title ?? this.title,
      content: content ?? this.content,
      dataPayload: dataPayload ?? this.dataPayload,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        templateId,
        title,
        content,
        dataPayload,
        isRead,
        readAt,
        createdAt,
      ];
}
