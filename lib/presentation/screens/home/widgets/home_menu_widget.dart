import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/theme/app_shadow.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeMenuWidget extends StatelessWidget {
  const HomeMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MenuItem(
                onTap: () => context.pushNamed('all-branch'),
                assetPath:
                    "assets/calendar-year-month-date-health-schedule-hospital-svgrepo-com.png",
                label: 'Đặt lịch\nkhám',
              ),
              _MenuItem(
                onTap: () => context.push('/patient-select'),
                assetPath:
                    "assets/clipboard-note-paper-document-hospital-result-medical-svgrepo-com.png",
                label: 'Lịch sử\nkhám bệnh',
              ),
              _MenuItem(
                onTap: () => AppToast.showInfo(
                  context,
                  "Tính năng đang được phát triển",
                ),
                assetPath:
                    "assets/medicine-herbal-natural-medical-drug-leaf-health-svgrepo-com.png",
                label: 'Nhắc nhở\nthuốc',
              ),
              _MenuItem(
                onTap: () => AppToast.showInfo(
                  context,
                  "Tính năng đang được phát triển",
                ),
                assetPath:
                    'assets/medical-health-care-doctor-hospital-medicine-healthcare-svgrepo-com.png',
                label: 'Gói chăm sóc\ntoàn diện',
              ),
            ],
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final VoidCallback onTap;
  final String assetPath;
  final String label;

  const _MenuItem({
    required this.onTap,
    required this.assetPath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryLight,
                Colors.white.withValues(alpha: 0.9),
              ],
            ),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: AppShadow.cardShadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              splashColor: AppColors.primary.withValues(alpha: 0.1),
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Image.asset(assetPath, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 75,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textDark,
              height: 1.3,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    );
  }
}
