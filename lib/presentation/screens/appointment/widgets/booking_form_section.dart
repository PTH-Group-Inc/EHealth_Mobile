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

  const BookingFormSection({
    super.key,
    required this.state,
    required this.onSelectService,
    required this.onSelectDate,
    required this.onSelectShift,
    required this.onSelectSlot,
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
      ],
    );
  }
}

class _SelectorField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isEmpty;
  final VoidCallback onTap;

  const _SelectorField({
    required this.label,
    required this.value,
    required this.icon,
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
