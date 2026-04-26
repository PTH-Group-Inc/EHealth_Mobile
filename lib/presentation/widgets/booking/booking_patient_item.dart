import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/patient.dart';
import 'package:e_health/domain/avatar.dart';
import 'booking_selection_card.dart';

class BookingPatientItem extends StatelessWidget {
  final Patient patient;
  final bool isSelected;
  final VoidCallback onTap;

  const BookingPatientItem({
    super.key,
    required this.patient,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get latest avatar
    final avatars = List<Avatar>.from(patient.avatarUrl);
    avatars.sort((Avatar a, Avatar b) {
      final dateA = a.uploadedAt ?? DateTime(0);
      final dateB = b.uploadedAt ?? DateTime(0);
      return dateB.compareTo(dateA);
    });
    final String? avatarUrl = avatars.isNotEmpty ? avatars.first.url : null;

    return BookingSelectionCard(
      isSelected: isSelected,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 2,
              ),
              image: avatarUrl != null
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(avatarUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: avatarUrl == null
                ? Icon(
                    Icons.person_rounded,
                    color: isSelected ? AppColors.primary : AppColors.grey400,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.fullName,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: isSelected ? AppColors.primary : AppColors.textHeader,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Mã BN: ${patient.patientCode}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSlate,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
            ),
        ],
      ),
    );
  }
}
