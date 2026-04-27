import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_state.dart';

class BookingFormSection extends StatelessWidget {
  final BookAppointmentState state;
  final VoidCallback onSelectService;
  final VoidCallback onSelectDate;
  final VoidCallback onSelectShift;
  final VoidCallback onSelectSlot;
  final VoidCallback onSelectDoctor;

  const BookingFormSection({
    super.key,
    required this.state,
    required this.onSelectService,
    required this.onSelectDate,
    required this.onSelectShift,
    required this.onSelectSlot,
    required this.onSelectDoctor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            "Thông tin đặt lịch",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.textHeader,
            ),
          ),
        ),
        _SelectorField(
          label: "Dịch vụ khám",
          value: state.selectedService?.serviceName ?? "Chọn dịch vụ khám",
          icon: Icons.medical_services_rounded,
          isEmpty: state.selectedService == null,
          onTap: onSelectService,
        ),
        const SizedBox(height: 16),
        _SelectorField(
          label: "Ngày khám",
          value: state.appointmentDate != null
              ? DateFormat("dd/MM/yyyy").format(state.appointmentDate!)
              : "Chọn ngày khám",
          icon: Icons.calendar_today_rounded,
          isEmpty: state.appointmentDate == null,
          onTap: onSelectDate,
        ),
        const SizedBox(height: 16),
        _SelectorField(
          label: "Ca khám",
          value: state.selectedShift?.name ?? "Chọn ca khám",
          icon: Icons.access_time_filled_rounded,
          isEmpty: state.selectedShift == null,
          onTap: onSelectShift,
        ),
        const SizedBox(height: 16),
        _SelectorField(
          label: "Khung giờ khám",
          value: state.selectedSlot != null
              ? "${state.selectedSlot!.startTime.substring(0, 5)} - ${state.selectedSlot!.endTime.substring(0, 5)}"
              : "Chọn khung giờ khám",
          icon: Icons.more_time_rounded,
          isEmpty: state.selectedSlot == null,
          onTap: onSelectSlot,
        ),
        const SizedBox(height: 24),
        const Divider(height: 1),
        const SizedBox(height: 24),
        Row(
          children: [
            const Icon(Icons.settings_suggest_rounded, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              "Nâng cao (Không bắt buộc)",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.primary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SelectorField(
          label: "Bác sĩ chỉ định",
          value: state.selectedDoctor?.doctorName ?? "Bác sĩ bất kỳ",
          imageUrl: state.selectedDoctor?.doctorAvatar,
          icon: Icons.person_search_rounded,
          isEmpty: state.selectedDoctor == null,
          onTap: onSelectDoctor,
        ),
      ],
    );
  }
}

class _SelectorField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final String? imageUrl;
  final bool isEmpty;
  final VoidCallback onTap;

  const _SelectorField({
    required this.label,
    required this.value,
    required this.icon,
    this.imageUrl,
    required this.isEmpty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            if (imageUrl != null)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Icon(
                icon,
                color: isEmpty ? AppColors.textSlate : AppColors.primary,
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSlate,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: isEmpty ? Colors.grey[400] : AppColors.textDark,
                      fontWeight: isEmpty ? FontWeight.normal : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textSlate,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
