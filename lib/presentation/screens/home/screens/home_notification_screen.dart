import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_color.dart';
import '../../../../app/theme/app_shadow.dart';
import '../../../widgets/feedback/app_refresh.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/cubit/auth_state.dart';
import '../../../../domain/notification_item.dart';
import '../../../widgets/feedback/empty_state_widget.dart';
import '../../../widgets/feedback/app_loading_widget.dart';

class HomeNotificationScreen extends StatefulWidget {
  const HomeNotificationScreen({super.key});

  @override
  State<HomeNotificationScreen> createState() => _HomeNotificationScreenState();
}

class _HomeNotificationScreenState extends State<HomeNotificationScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    // Refresh data when screen is first built in a session
    context.read<NotificationCubit>().loadNotifications();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationCubit>().loadMoreNotifications();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != AuthStatus.success &&
          current.status == AuthStatus.success,
      listener: (context, state) {
        // Refresh when user logs in/identity changes
        context.read<NotificationCubit>().loadNotifications();
      },
      child: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          return AppRefresh(
            onRefresh: () async {
              await context.read<NotificationCubit>().loadNotifications();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Thông báo",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      if (state.notifications.isNotEmpty)
                        TextButton.icon(
                          onPressed: state.isMarkingAllRead
                              ? null
                              : () =>
                                    context.read<NotificationCubit>().readAll(),
                          icon: state.isMarkingAllRead
                              ? const AppLoadingWidget(size: 14, strokeWidth: 2)
                              : const Icon(Icons.done_all, size: 18),
                          label: const Text(
                            "Đọc tất cả",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(child: _buildBody(state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(NotificationState state) {
    if (state.status == NotificationStatus.loading &&
        state.notifications.isEmpty) {
      return const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(height: 300, child: Center(child: AppLoadingWidget())),
      );
    }

    if (state.notifications.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: _buildEmptyState(),
      );
    }

    return _buildNotificationList(state);
  }

  Widget _buildEmptyState() {
    return const EmptyStateWidget(
      icon: Icons.notifications_none_outlined,
      title: "Bạn chưa có thông báo nào",
      subtitle:
          "Các thông báo về lịch hẹn và ưu đãi mới nhất sẽ xuất hiện tại đây.",
    );
  }

  Widget _buildNotificationList(NotificationState state) {
    final notifications = state.notifications;
    return ListView.separated(
      key: const PageStorageKey('notification_list_view'),
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
      itemCount: notifications.length + (state.isFetchingMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index < notifications.length) {
          final item = notifications[index];
          return _buildNotificationItem(item);
        }
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: AppLoadingWidget(size: 24)),
        );
      },
    );
  }

  Widget _buildNotificationItem(NotificationItem item) {
    final bool isRead = item.isRead ?? false;
    final String timeStr = item.createdAt != null
        ? DateFormat('HH:mm, dd/MM/yyyy').format(item.createdAt!)
        : "--:--";

    return InkWell(
      onTap: () => context.push('/notification-detail', extra: item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : const Color(0xFFF0F7FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead
                ? Colors.grey.shade200
                : AppColors.primary.withValues(alpha: 0.2),
          ),
          boxShadow: isRead ? null : AppShadow.cardShadow,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isRead ? Colors.grey.shade100 : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isRead
                    ? Icons.notifications_outlined
                    : Icons.notifications_active,
                color: isRead ? AppColors.textLight : AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title ?? "Thông báo",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isRead
                                ? FontWeight.w600
                                : FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        const Icon(
                          Icons.done_all,
                          color: AppColors.primary,
                          size: 16,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    (item.content ?? "").replaceAll('\\n', '\n'),
                    style: TextStyle(
                      fontSize: 14,
                      color: isRead ? AppColors.textLight : AppColors.textDark,
                      height: 1.4,
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeStr,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                      if (!isRead)
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () =>
                              context.read<NotificationCubit>().read(item.id!),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text(
                              "Đã đọc",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
