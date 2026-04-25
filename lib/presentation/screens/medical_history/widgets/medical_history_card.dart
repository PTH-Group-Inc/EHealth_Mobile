import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/theme/app_shadow.dart';
import 'package:e_health/domain/medical_history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class MedicalHistoryCard extends StatelessWidget {
  final MedicalHistory history;

  const MedicalHistoryCard({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = history.status == 'COMPLETED';
    final Color statusColor = isCompleted
        ? AppColors.success
        : AppColors.primary;
    final String dateStr = DateFormat(
      'dd/MM/yyyy • HH:mm',
    ).format(history.startTime);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () =>
            context.push('/appointment-detail/${history.appointmentId}'),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppShadow.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Status and Date
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isCompleted ? "Đã hoàn thành" : "Đang diễn ra",
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      dateStr,
                      style: TextStyle(
                        color: AppColors.textSlate.withValues(alpha: 0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: AppColors.grey100),

              // Doctor and Specialty Info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.medical_services_outlined,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${history.doctorTitle} ${history.doctorName}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textHeader,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            history.specialtyName,
                            style: TextStyle(
                              color: AppColors.textSlate.withValues(alpha: 0.8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Details Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _DetailRow(
                        icon: Icons.meeting_room_outlined,
                        label: "Phòng khám",
                        value: "${history.roomName} (${history.roomCode})",
                      ),
                      if (history.chiefComplaint != null) ...[
                        const SizedBox(height: 12),
                        _DetailRow(
                          icon: Icons.notes_outlined,
                          label: "Lý do khám",
                          value: history.chiefComplaint!,
                        ),
                      ],
                      if (history.primaryDiagnosis != null) ...[
                        const SizedBox(height: 12),
                        _DetailRow(
                          icon: Icons.assignment_outlined,
                          label: "Chẩn đoán",
                          value: history.primaryDiagnosis!,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary.withValues(alpha: 0.8)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSlate.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHeader,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
