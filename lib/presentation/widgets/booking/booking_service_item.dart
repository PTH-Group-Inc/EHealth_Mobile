import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'booking_selection_card.dart';

class BookingServiceItem extends StatelessWidget {
  final String serviceName;
  final String basePrice;
  final bool isSelected;
  final VoidCallback onTap;

  const BookingServiceItem({
    super.key,
    required this.serviceName,
    required this.basePrice,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BookingSelectionCard(
      isSelected: isSelected,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.medical_services_outlined,
              color: isSelected ? Colors.white : AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: isSelected ? AppColors.primary : AppColors.textHeader,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  NumberFormat.currency(
                    locale: 'vi_VN',
                    symbol: 'đ',
                  ).format(double.tryParse(basePrice) ?? 0),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
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
