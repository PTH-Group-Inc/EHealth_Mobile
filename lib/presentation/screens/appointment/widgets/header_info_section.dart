import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/booking_model.dart';

class HeaderInfoSection extends StatelessWidget {
  final BookingModel model;

  const HeaderInfoSection({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoCard(
          icon: Icons.person_rounded,
          title: "Bệnh nhân",
          subtitle: model.patientName,
          imageUrl: model.patientAvatar,
        ),
        const SizedBox(height: 16),
        _InfoCard(
          icon: Icons.location_city_rounded,
          title: "Chi nhánh",
          subtitle: model.branchName ?? "Chưa chọn chi nhánh",
        ),
        if (model.departmentName != null) ...[
          const SizedBox(height: 16),
          _InfoCard(
            icon: Icons.local_hospital_rounded,
            title: "Khoa",
            subtitle: model.departmentName!,
          ),
        ],
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? imageUrl;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              image: imageUrl != null
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null
                ? Icon(icon, color: AppColors.primary, size: 24)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSlate,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeader,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
