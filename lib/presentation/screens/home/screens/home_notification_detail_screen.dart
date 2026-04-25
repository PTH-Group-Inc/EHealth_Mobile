import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/theme/app_shadow.dart';
import 'package:e_health/domain/notification_item.dart';
import 'package:e_health/presentation/screens/home/cubit/notification_cubit.dart';
import 'package:e_health/presentation/screens/home/cubit/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeNotificationDetailScreen extends StatelessWidget {
  final NotificationItem item;

  const HomeNotificationDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final String timeStr = item.createdAt != null
        ? DateFormat('HH:mm, dd/MM/yyyy').format(item.createdAt!)
        : "--:--";

    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final currentItem = state.notifications.firstWhere(
          (n) => n.id == item.id,
          orElse: () => item,
        );
        final bool isRead = currentItem.isRead ?? false;

        return Scaffold(
          backgroundColor: AppColors.primaryBackground,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Chi tiết thông báo",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadow.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges & Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isRead
                              ? Colors.grey.shade100
                              : AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "THÔNG BÁO",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: isRead
                                ? AppColors.textSlate
                                : AppColors.primary,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      Text(
                        timeStr,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    currentItem.title ?? "Thông báo",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textHeader,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  // Content
                  Text(
                    (currentItem.content ?? "").replaceAll('\\n', '\n'),
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textDark,
                      height: 1.6,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Floating Read Button
          bottomNavigationBar: !isRead
              ? Container(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white.withValues(alpha: 0), Colors.white],
                      stops: const [0, 0.4],
                    ),
                  ),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      boxShadow: AppShadow.floatingShadow,
                    ),
                    child: ElevatedButton(
                      onPressed: () => context.read<NotificationCubit>().read(
                        currentItem.id!,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "ĐÃ ĐỌC",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}
