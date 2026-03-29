import 'package:equatable/equatable.dart';
import '../../../../domain/notification_item.dart';

enum NotificationStatus { initial, loading, success, failure }

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<NotificationItem> notifications;
  final String? errorMessage;
  final bool isMarkingAllRead;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.errorMessage,
    this.isMarkingAllRead = false,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationItem>? notifications,
    String? errorMessage,
    bool? isMarkingAllRead,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage ?? this.errorMessage,
      isMarkingAllRead: isMarkingAllRead ?? this.isMarkingAllRead,
    );
  }

  @override
  List<Object?> get props => [
        status,
        notifications,
        errorMessage,
        isMarkingAllRead,
      ];
}
