import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_color.dart';
import '../../../app/theme/app_shadow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/patient.dart';
import '../../../domain/patient_vitals.dart';
import 'cubit/patient_vitals_cubit.dart';
import 'cubit/patient_vitals_state.dart';
import 'package:shimmer/shimmer.dart';

class MedicalRecordDetailScreen extends StatefulWidget {
  final Patient patient;
  const MedicalRecordDetailScreen({super.key, required this.patient});

  @override
  State<MedicalRecordDetailScreen> createState() =>
      _MedicalRecordDetailScreenState();
}

class _MedicalRecordDetailScreenState extends State<MedicalRecordDetailScreen> {
  late Patient _patient;

  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
    context.read<PatientVitalsCubit>().loadLatestVitals(_patient.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text(
          "Chi tiết hồ sơ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, Color(0xFF1E40AF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVitalsSection(),
            const SizedBox(height: 24),
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
          final result = await context.push(
            '/edit-medical-record',
            extra: _patient,
          );
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

  Widget _buildVitalsSection() {
    return BlocBuilder<PatientVitalsCubit, PatientVitalsState>(
      builder: (context, state) {
        if (state is PatientVitalsLoading) {
          return _buildVitalsShimmer();
        }
        if (state is PatientVitalsSuccess) {
          return _buildVitalsCard(state.vitals);
        }
        if (state is PatientVitalsNoData) {
          return _buildNoVitalsCard();
        }
        if (state is PatientVitalsFailure) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red[100]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Không thể tải chỉ số sinh hiệu: ${state.message}",
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildVitalsCard(PatientVitals vitals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Chỉ số sinh hiệu mới nhất",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textHeader,
              ),
            ),
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(vitals.createdAt),
              style: const TextStyle(fontSize: 11, color: AppColors.textSlate),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppShadow.cardShadow,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildVitalItem(
                    Icons.favorite_rounded,
                    "Nhịp tim",
                    "${vitals.pulse ?? '--'}",
                    "BPM",
                    Colors.red[100]!,
                  ),
                  _buildVitalVerticalDivider(),
                  _buildVitalItem(
                    Icons.speed_rounded,
                    "Huyết áp",
                    "${vitals.bloodPressureSystolic ?? '--'}/${vitals.bloodPressureDiastolic ?? '--'}",
                    "mmHg",
                    Colors.blue[100]!,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Colors.white24, height: 1),
              ),
              Row(
                children: [
                  _buildVitalItem(
                    Icons.thermostat_rounded,
                    "Nhiệt độ",
                    "${vitals.temperature ?? '--'}",
                    "°C",
                    Colors.orange[100]!,
                  ),
                  _buildVitalVerticalDivider(),
                  _buildVitalItem(
                    Icons.air_rounded,
                    "Nhịp thở",
                    "${vitals.respiratoryRate ?? '--'}",
                    "Lần/P",
                    Colors.cyan[100]!,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Colors.white24, height: 1),
              ),
              Row(
                children: [
                  _buildVitalItem(
                    Icons.monitor_weight_outlined,
                    "Cân nặng",
                    "${vitals.weight ?? '--'}",
                    "kg",
                    Colors.teal[100]!,
                  ),
                  _buildVitalVerticalDivider(),
                  _buildVitalItem(
                    Icons.height_rounded,
                    "Chiều cao",
                    "${vitals.height ?? '--'}",
                    "cm",
                    Colors.indigo[100]!,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Colors.white24, height: 1),
              ),
              Row(
                children: [
                  _buildVitalItem(
                    Icons.monitor_weight_outlined,
                    "Chỉ số BMI",
                    "${vitals.bmi ?? '--'}",
                    "kg/m²",
                    Colors.green[100]!,
                  ),
                  _buildVitalVerticalDivider(),
                  _buildVitalItem(
                    Icons.opacity_rounded,
                    "Chỉ số SpO2",
                    "${vitals.spo2 ?? '--'}",
                    "%",
                    Colors.cyan[100]!,
                  ),
                ],
              ),
              if (vitals.bloodGlucose != null) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Colors.white24, height: 1),
                ),
                Row(
                  children: [
                    _buildVitalItem(
                      Icons.bloodtype_rounded,
                      "Đường huyết",
                      "${vitals.bloodGlucose ?? '--'}",
                      "mmol/L",
                      Colors.purple[100]!,
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (vitals.doctorName != null || vitals.recorderName != null)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              "* Ghi nhận bởi: ${vitals.doctorName ?? vitals.recorderName}",
              style: const TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: AppColors.textSlate,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVitalItem(
    IconData icon,
    String label,
    String value,
    String unit,
    Color iconBg,
  ) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " $unit",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white24,
    );
  }

  Widget _buildNoVitalsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadow.cardShadow,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.analytics_outlined, color: Colors.grey[300], size: 48),
          const SizedBox(height: 12),
          const Text(
            "Chưa có chỉ số sinh hiệu",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeader,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Dữ liệu sinh hiệu sẽ xuất hiện sau khi bạn thực hiện thăm khám.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textSlate),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
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
