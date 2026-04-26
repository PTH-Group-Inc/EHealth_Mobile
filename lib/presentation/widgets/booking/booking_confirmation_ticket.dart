import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_health/app/theme/app_color.dart';

class BookingConfirmationTicket extends StatelessWidget {
  final String patientName;
  final String serviceName;
  final String date;
  final String time;
  final String location;
  final String price;
  final String status;

  const BookingConfirmationTicket({
    super.key,
    required this.patientName,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.location,
    required this.price,
    this.status = "CHỜ XÁC NHẬN",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                const Icon(Icons.confirmation_num_rounded, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                const Text(
                  "Chi tiết lịch khám",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildRow(
                  "Bệnh nhân",
                  patientName,
                  icon: Icons.person_rounded,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: AppColors.grey100),
                ),
                _buildRow(
                  "Dịch vụ",
                  serviceName,
                  icon: Icons.medical_services_rounded,
                  valueColor: AppColors.primary,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: AppColors.grey100),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildRow(
                        "Ngày",
                        date,
                        icon: Icons.calendar_today_rounded,
                      ),
                    ),
                    Container(width: 1, height: 30, color: AppColors.grey100, margin: const EdgeInsets.symmetric(horizontal: 16)),
                    Expanded(
                      child: _buildRow(
                        "Giờ",
                        time,
                        icon: Icons.access_time_rounded,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: AppColors.grey100),
                ),
                _buildRow(
                  "Địa điểm",
                  location,
                  icon: Icons.location_on_rounded,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Center(
              child: Text(
                "Giá dịch vụ: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(double.tryParse(price) ?? 0)}",
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {required IconData icon, Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSlate),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.textSlate, fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: valueColor ?? AppColors.textHeader,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
