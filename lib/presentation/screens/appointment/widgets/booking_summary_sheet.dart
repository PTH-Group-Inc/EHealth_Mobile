import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/booking_model.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_state.dart';

class BookingSummarySheet extends StatelessWidget {
  final BookAppointmentState state;
  final BookingModel model;
  final VoidCallback onConfirm;

  const BookingSummarySheet({
    super.key,
    required this.state,
    required this.model,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              children: [
                Container(
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
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.confirmation_num_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "CHỜ XÁC NHẬN",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            _buildTicketRow(
                              "Bệnh nhân",
                              model.patientName,
                              icon: Icons.person_rounded,
                            ),
                            if (model.doctorName != null) ...[
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Divider(
                                  height: 1,
                                  color: AppColors.grey100,
                                ),
                              ),
                              _buildTicketRow(
                                "Bác sĩ",
                                model.doctorName!,
                                icon: Icons.medical_services_rounded,
                              ),
                            ],
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Divider(
                                height: 1,
                                color: AppColors.grey100,
                              ),
                            ),
                            _buildTicketRow(
                              "Dịch vụ",
                              state.selectedService?.serviceName ?? "",
                              icon: Icons.medical_services_rounded,
                              valueColor: AppColors.primary,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Divider(
                                height: 1,
                                color: AppColors.grey100,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTicketRow(
                                    "Ngày",
                                    state.appointmentDate != null
                                        ? DateFormat(
                                            "dd/MM/yyyy",
                                          ).format(state.appointmentDate!)
                                        : "",
                                    icon: Icons.calendar_today_rounded,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: AppColors.grey100,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                ),
                                Expanded(
                                  child: _buildTicketRow(
                                    "Giờ",
                                    state.selectedSlot != null
                                        ? state.selectedSlot!.startTime
                                              .substring(0, 5)
                                        : "",
                                    icon: Icons.access_time_rounded,
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Divider(
                                height: 1,
                                color: AppColors.grey100,
                              ),
                            ),
                            _buildTicketRow(
                              "Địa điểm",
                              "${model.branchName ?? ""}\n${model.departmentName ?? ""}",
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
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(24),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Giá dịch vụ: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(double.tryParse(state.selectedService?.basePrice ?? "0") ?? 0)}",
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
                ),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildTicketRow(
    String label,
    String value, {
    required IconData icon,
    Color? valueColor,
  }) {
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
                style: const TextStyle(
                  color: AppColors.textSlate,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
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

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              "Xác nhận đặt lịch",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textHeader,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            "XÁC NHẬN THANH TOÁN",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
