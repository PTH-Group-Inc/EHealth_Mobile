import 'package:flutter/material.dart';
import 'package:e_health/domain/appointment_detail.dart';
import 'package:e_health/app/theme/app_color.dart';

class AppointmentDetailInfoCard extends StatelessWidget {
  final AppointmentDetail appointment;

  const AppointmentDetailInfoCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final data = appointment.appointment;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(data.code),
          const Divider(height: 32),
          
          _buildInfoRow(
            icon: Icons.person_outline,
            label: "Bệnh nhân",
            value: data.patientName ?? "---",
          ),
          const SizedBox(height: 16),
          
          _buildInfoRow(
            icon: Icons.medical_services_outlined,
            label: "Bác sĩ",
            value: data.doctorName ?? "---",
          ),
          const SizedBox(height: 16),
          
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            label: "Ngày khám",
            value: data.appointmentDate ?? "---",
          ),
          const SizedBox(height: 16),
          
          _buildInfoRow(
            icon: Icons.access_time_outlined,
            label: "Giờ khám",
            value: "${data.slotStartTime} - ${data.slotEndTime}",
          ),
          const SizedBox(height: 16),
          
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: "Cơ sở",
            value: data.branchName ?? "---",
          ),
          const SizedBox(height: 16),
          
          _buildInfoRow(
            icon: Icons.meeting_room_outlined,
            label: "Phòng khám",
            value: data.roomName ?? "---",
          ),
          const SizedBox(height: 16),
          
          _buildInfoRow(
            icon: Icons.assignment_outlined,
            label: "Dịch vụ",
            value: data.serviceName ?? "---",
          ),
          
          if (data.reasonForVisit != null) ...[
            const Divider(height: 32),
            const Text(
              "Lý do khám",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textSlate,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data.reasonForVisit!,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textDark,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(String code) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mã lịch khám",
              style: TextStyle(
                color: AppColors.textSlate,
                fontSize: 12,
              ),
            ),
            Text(
              code,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        Icon(Icons.qr_code, color: AppColors.primary, size: 40),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
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
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
