import 'package:equatable/equatable.dart';
import '../../../../domain/notification_item.dart';

enum NotificationStatus { initial, loading, success, failure }

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<NotificationItem> notifications;
  final String? errorMessage;
  final bool isMarkingAllRead;
  final int page;
  final bool hasReachedMax;
  final bool isFetchingMore;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.errorMessage,
    this.isMarkingAllRead = false,
    this.page = 1,
    this.hasReachedMax = false,
    this.isFetchingMore = false,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationItem>? notifications,
    String? errorMessage,
    bool? isMarkingAllRead,
    int? page,
    bool? hasReachedMax,
    bool? isFetchingMore,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage ?? this.errorMessage,
      isMarkingAllRead: isMarkingAllRead ?? this.isMarkingAllRead,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }

  @override
  List<Object?> get props => [
        status,
        notifications,
        errorMessage,
        isMarkingAllRead,
        page,
        hasReachedMax,
        isFetchingMore,
      ];
}
