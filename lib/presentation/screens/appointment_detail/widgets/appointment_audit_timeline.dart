import 'package:flutter/material.dart';
import 'package:e_health/domain/appointment_audit_log.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:intl/intl.dart';

class AppointmentAuditTimeline extends StatelessWidget {
  final List<AppointmentAuditLog> auditLogs;

  const AppointmentAuditTimeline({super.key, required this.auditLogs});

  @override
  Widget build(BuildContext context) {
    if (auditLogs.isEmpty) {
      return const Center(child: Text("Không có dữ liệu lịch sử"));
    }

    // Sort audit logs by date descending
    final sortedLogs = List<AppointmentAuditLog>.from(auditLogs)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedLogs.length,
      itemBuilder: (context, index) {
        final log = sortedLogs[index];
        final isFirst = index == 0;
        final isLast = index == sortedLogs.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isFirst ? AppColors.primary : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getStatusLabel(log.newStatus),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isFirst ? AppColors.primary : AppColors.textDark,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        DateFormat('HH:mm - dd/MM').format(log.createdAt),
                        style: const TextStyle(
                          color: AppColors.textSlate,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (log.actionNote != null && log.actionNote!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 12),
                      child: Text(
                        log.actionNote!,
                        style: const TextStyle(
                          color: AppColors.textSlate,
                          fontSize: 13,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return "Tạo lịch khám";
      case 'CONFIRMED':
        return "Xác nhận";
      case 'CHECKED_IN':
        return "Check-in";
      case 'IN_PROGRESS':
        return "Bắt đầu khám";
      case 'COMPLETED':
        return "Hoàn tất khám";
      case 'CANCELLED':
        return "Đã hủy";
      case 'NO_SHOW':
        return "Không đến";
      default:
        return status;
    }
  }
}
