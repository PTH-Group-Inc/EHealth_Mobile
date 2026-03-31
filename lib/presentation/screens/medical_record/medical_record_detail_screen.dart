import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_color.dart';
import '../../../app/theme/app_shadow.dart';
import '../../../domain/patient.dart';

class MedicalRecordDetailScreen extends StatefulWidget {
  final Patient patient;
  const MedicalRecordDetailScreen({super.key, required this.patient});

  @override
  State<MedicalRecordDetailScreen> createState() => _MedicalRecordDetailScreenState();
}

class _MedicalRecordDetailScreenState extends State<MedicalRecordDetailScreen> {
  late Patient _patient;

  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text(
          "Chi tiết hồ sơ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textHeader,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Thông tin cá nhân",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textHeader,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadow.cardShadow,
                border: Border.all(
                  color: AppColors.primaryBorder.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                   _buildInfoRow(
                    Icons.person_pin_outlined,
                    "Họ và tên",
                    _patient.fullName,
                  ),
                  const Divider(height: 32, color: AppColors.surface),
                  _buildInfoRow(
                    Icons.fingerprint_outlined,
                    "Mã bệnh nhân",
                    _patient.patientCode,
                  ),
                  const Divider(height: 32, color: AppColors.surface),
                  _buildInfoRow(
                    Icons.cake_outlined,
                    "Ngày sinh",
                    DateFormat('dd/MM/yyyy').format(_patient.dateOfBirth),
                  ),
                  const Divider(height: 32, color: AppColors.surface),
                  _buildInfoRow(
                    Icons.transgender_outlined,
                    "Giới tính",
                    _patient.gender == "MALE" ? "Nam" : "Nữ",
                  ),
                  const Divider(height: 32, color: AppColors.surface),
                  _buildInfoRow(
                    Icons.phone_outlined,
                    "Số điện thoại",
                    _patient.phoneNumber,
                  ),
                  const Divider(height: 32, color: AppColors.surface),
                  _buildInfoRow(Icons.email_outlined, "Email", _patient.email),
                  const Divider(height: 32, color: AppColors.surface),
                  _buildInfoRow(
                    Icons.badge_outlined,
                    "CMND/CCCD",
                    _patient.idCardNumber ?? "N/A",
                  ),
                  const Divider(height: 32, color: AppColors.surface),
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    "Địa chỉ",
                    _patient.address ?? "N/A",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Liên hệ khẩn cấp",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textHeader,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadow.cardShadow,
                border: Border.all(
                  color: AppColors.primaryBorder.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    Icons.contact_phone_outlined,
                    "Người liên hệ",
                    _patient.emergencyContactName ?? "N/A",
                  ),
                  const Divider(height: 32, color: AppColors.surface),
                  _buildInfoRow(
                    Icons.phone_forwarded_outlined,
                    "Số điện thoại liên hệ",
                    _patient.emergencyContactPhone ?? "N/A",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.security_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _patient.hasInsurance
                          ? "Hồ sơ đã được liên kết với Bảo hiểm Y tế."
                          : "Hồ sơ chưa có thông tin Bảo hiểm Y tế.",
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await context.push('/edit-medical-record', extra: _patient);
          if (result != null && result is Patient) {
            setState(() {
              _patient = result;
            });
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text(
          "Chỉnh sửa",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSlate,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textHeader,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
