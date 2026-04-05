import 'package:flutter/material.dart';
import '../../../../app/theme/app_color.dart';

class AppointmentHorizontalStepper extends StatelessWidget {
  final String currentStatus;

  const AppointmentHorizontalStepper({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    // Definining status nodes with labels and sequence
    final nodes = [
      {'status': 'PENDING', 'label': 'Đã tạo'},
      {'status': 'CONFIRMED', 'label': 'Xác nhận'},
      {'status': 'CHECKED_IN', 'label': 'Check-in'},
      {'status': 'IN_PROGRESS', 'label': 'Đang khám'},
      {'status': 'COMPLETED', 'label': 'Hoàn tất'},
    ];

    // Find current index
    int currentIndex = _getStatusIndex(currentStatus);
    bool isCancelled = currentStatus.toUpperCase() == 'CANCELLED';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TIẾN TRÌNH KHÁM",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.textSlate.withValues(alpha: 0.7),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: List.generate(nodes.length, (index) {
              final node = nodes[index];
              final isLast = index == nodes.length - 1;
              final isCompleted = !isCancelled && index <= currentIndex;
              final isActive = !isCancelled && index == currentIndex;

              return Expanded(
                flex: isLast ? 0 : 1,
                child: Row(
                  children: [
                    // Node
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? (isActive
                                      ? AppColors.primary
                                      : AppColors.primary.withValues(
                                          alpha: 0.2,
                                        ))
                                : AppColors.grey200,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCompleted
                                  ? AppColors.primary
                                  : AppColors.grey300,
                              width: 2,
                            ),
                          ),
                          child: isCompleted && !isActive
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          node['label']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isCompleted
                                ? FontWeight.w800
                                : FontWeight.w500,
                            color: isCompleted
                                ? AppColors.textHeader
                                : AppColors.textSlate,
                          ),
                        ),
                      ],
                    ),
                    // Line
                    if (!isLast)
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 4,
                            right: 4,
                            bottom: 20,
                          ),
                          height: 2,
                          color: isCompleted && index < currentIndex
                              ? AppColors.primary
                              : AppColors.grey200,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          if (isCancelled) ...[
            const SizedBox(height: 16),
            const Center(
              child: Text(
                "LỊCH KHÁM ĐÃ HỦY",
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  int _getStatusIndex(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 0;
      case 'CONFIRMED':
        return 1;
      case 'CHECKED_IN':
        return 2;
      case 'IN_PROGRESS':
        return 3;
      case 'COMPLETED':
        return 4;
      default:
        return 0;
    }
  }
}
