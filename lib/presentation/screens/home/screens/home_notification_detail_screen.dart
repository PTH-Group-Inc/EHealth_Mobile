import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_color.dart';
import '../../../../app/theme/app_shadow.dart';
import '../../../../domain/notification_item.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';
import '../../../widgets/feedback/app_loading_widget.dart';

class HomeNotificationDetailScreen extends StatelessWidget {
  final NotificationItem item;

  const HomeNotificationDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final String timeStr = item.createdAt != null
        ? DateFormat('HH:mm, dd/MM/yyyy').format(item.createdAt!)
        : "--:--";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Chi tiết thông báo",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          // Find the latest version of this item in the state
          final currentItem = state.notifications.firstWhere(
            (n) => n.id == item.id,
            orElse: () => item,
          );
          final bool isRead = currentItem.isRead ?? false;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isRead ? Colors.grey.shade100 : const Color(0xFFF0F7FF),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isRead ? Icons.notifications_none : Icons.notifications_active,
                              color: isRead ? AppColors.textLight : AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  timeStr,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textLight,
                                  ),
                                ),
                                if (!isRead)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Text(
                                      "Mới",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        currentItem.title ?? "Thông báo",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                          height: 1.3,
                        ),
                      ),
                      const Divider(height: 48, thickness: 1),
                      Text(
                        (currentItem.content ?? "").replaceAll('\\n', '\n'),
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textDark,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 120), // Bottom space for button
                    ],
                  ),
                ),
              ),
              if (!isRead)
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => context.read<NotificationCubit>().read(currentItem.id!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Đã đọc",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
