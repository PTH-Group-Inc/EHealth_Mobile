import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/presentation/screens/home/cubit/notification_state.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  final Repository _repository;

  NotificationCubit(this._repository) : super(const NotificationState());

  Future<void> loadNotifications() async {
    emit(state.copyWith(
      status: NotificationStatus.loading,
      page: 1,
      hasReachedMax: false,
      clearError: true,
    ));
    final result = await _repository.getNotifications(page: 1, limit: 20);
    result.fold(
      (failure) => emit(state.copyWith(
        status: NotificationStatus.failure,
        errorMessage: failure.message,
      )),
      (notifications) {
        emit(state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
          hasReachedMax: notifications.length < 20,
        ));
      },
    );
  }

  Future<void> loadMoreNotifications() async {
    if (state.isFetchingMore || state.hasReachedMax) return;

    emit(state.copyWith(isFetchingMore: true, clearError: true));
    final nextPage = state.page + 1;
    final result = await _repository.getNotifications(page: nextPage, limit: 20);

    result.fold(
      (failure) => emit(state.copyWith(
        isFetchingMore: false,
        errorMessage: failure.message,
      )),
      (newNotifications) {
        if (newNotifications.isEmpty) {
          emit(state.copyWith(
            isFetchingMore: false,
            hasReachedMax: true,
          ));
        } else {
          emit(state.copyWith(
            isFetchingMore: false,
            notifications: [...state.notifications, ...newNotifications],
            page: nextPage,
            hasReachedMax: newNotifications.length < 20,
          ));
        }
      },
    );
  }

  Future<void> readAll() async {
    emit(state.copyWith(isMarkingAllRead: true, clearError: true));
    final result = await _repository.readAllNotifications();
    result.fold(
      (failure) => emit(state.copyWith(
        isMarkingAllRead: false,
        errorMessage: failure.message,
      )),
      (_) {
        // Update local state to show all as read
        final updatedNotifications = state.notifications.map((n) {
          return n.copyWith(isRead: true);
        }).toList();
        
        emit(state.copyWith(
          isMarkingAllRead: false,
          notifications: updatedNotifications,
        ));
      },
    );
  }

  Future<void> read(String id) async {
    final result = await _repository.readNotification(id);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        // Update local state for specific notification
        final updatedNotifications = state.notifications.map((n) {
          if (n.id == id) {
            return n.copyWith(isRead: true);
          }
          return n;
        }).toList();
        
        emit(state.copyWith(notifications: updatedNotifications));
      },
    );
  }
}
