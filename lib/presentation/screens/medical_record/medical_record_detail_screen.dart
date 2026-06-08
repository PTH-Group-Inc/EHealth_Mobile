import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_health/presentation/widgets/data_display/full_screen_image_viewer.dart';
import 'package:flutter_easyloading_plus/flutter_easyloading_plus.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/theme/app_shadow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_health/domain/patient.dart';
import 'package:e_health/domain/patient_vitals.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_detail_cubit.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_detail_state.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/patient_vitals_cubit.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/patient_vitals_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:e_health/domain/avatar.dart';

class MedicalRecordDetailScreen extends StatefulWidget {
  final Patient patient;
  const MedicalRecordDetailScreen({super.key, required this.patient});

  @override
  State<MedicalRecordDetailScreen> createState() =>
      _MedicalRecordDetailScreenState();
}

class _MedicalRecordDetailScreenState extends State<MedicalRecordDetailScreen> {
  late Patient _patient;
  int _currentImageIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
    context.read<MedicalRecordDetailCubit>().updatePatientLocally(_patient);
    context.read<PatientVitalsCubit>().loadLatestVitals(_patient.id);
  }

  Future<void> _pickAndUploadAvatar() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (!mounted) return;
      if (image == null) return;

      context.read<MedicalRecordDetailCubit>().uploadAvatar(
        _patient.id,
        image.path,
        _patient,
      );
    } catch (e) {
      if (!mounted) return;
      AppToast.showError(context, "Đã xảy ra lỗi khi chọn ảnh");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicalRecordDetailCubit, MedicalRecordDetailState>(
      listener: (context, state) {
        if (state is MedicalRecordDetailDeleteLoading) {
          EasyLoading.show(
            status: "Đang xoá hồ sơ...",
            maskType: EasyLoadingMaskType.black,
          );
        } else {
          EasyLoading.dismiss();
          if (state is MedicalRecordDetailLoaded) {
            _patient = state.patient;
          } else if (state is MedicalRecordDetailAvatarSuccess) {
            _patient = state.updatedPatient;
            _currentImageIndex = 0;
            AppToast.showSuccess(context, state.message);
          } else if (state is MedicalRecordDetailError) {
            AppToast.showError(context, state.message);
          } else if (state is MedicalRecordDetailDeleteSuccess) {
            AppToast.showSuccess(context, "Xoá hồ sơ thành công");
            context.pop(true);
          }
        }
      },
      builder: (context, state) {
        bool isUploading = state is MedicalRecordDetailAvatarUploading;
        if (state is MedicalRecordDetailAvatarUploading) {
          _patient = state.currentPatient;
        }

        return Scaffold(
          backgroundColor: AppColors.primaryBackground,
          body: Stack(
            children: [
              RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageSection(isUploading),
                      _buildContentSection(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              _buildCustomAppBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomAppBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      child: InkWell(
        onTap: () => context.pop(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(bool isUploading) {
    final avatars = List<Avatar>.from(_patient.avatarUrl);
    avatars.sort((a, b) {
      final dateA = a.uploadedAt ?? DateTime(0);
      final dateB = b.uploadedAt ?? DateTime(0);
      return dateB.compareTo(dateA);
    });

    final hasMultipleImages = avatars.length >= 2;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
      ),
      child: Stack(
        children: [
          if (avatars.isNotEmpty)
            CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                height: MediaQuery.of(context).size.width * 1.1,
                viewportFraction: 1.0,
                initialPage: 0,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
              ),
              items: avatars.asMap().entries.map((entry) {
                final index = entry.key;
                final avatar = entry.value;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImageViewer(
                          imageUrls: avatars.map((e) => e.url).toList(),
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: "avatar_$index",
                    child: CachedNetworkImage(
                      imageUrl: avatar.url,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                );
              }).toList(),
            )
          else
            Container(
              height: MediaQuery.of(context).size.width * 1.1,
              width: double.infinity,
              color: AppColors.grey100,
              child: const Icon(
                Icons.person,
                size: 100,
                color: AppColors.grey300,
              ),
            ),

          if (hasMultipleImages)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 50,
              right: 50,
              child: Row(
                children: List.generate(
                  avatars.length,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 3,
                      decoration: BoxDecoration(
                        color: _currentImageIndex == index
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          if (isUploading)
            Positioned.fill(
              child: Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                _patient.fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textHeader,
                ),
              ),
              if (_patient.isDefault) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Mặc định",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (_patient.email != null && _patient.email!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              _patient.email!,
              style: const TextStyle(fontSize: 14, color: AppColors.textSlate),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.camera_alt_outlined,
                  label: "Đặt ảnh",
                  onTap: _pickAndUploadAvatar,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.edit_outlined,
                  label: "Sửa thông tin",
                  onTap: () async {
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
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.delete_outline_rounded,
                  label: "Xoá hồ sơ",
                  onTap: () => _confirmDeletePatient(context),
                  iconColor: AppColors.roseDark,
                  borderColor: AppColors.roseBorder,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildVitalsSection(),
          const SizedBox(height: 24),
          _buildInfoCard(
            icon: Icons.phone_outlined,
            title: _patient.phoneNumber,
            subtitle: "Di động",
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.wc_outlined,
            title: _getGenderText(_patient.gender),
            subtitle: "Giới tính",
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.badge_outlined,
            title: _patient.idCardNumber ?? "Chưa cập nhật",
            subtitle: "CMND/CCCD",
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.location_on_outlined,
            title: _patient.address ?? "Chưa cập nhật",
            subtitle: "Địa chỉ",
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.cake_outlined,
            title:
                "${DateFormat('dd/MM/yyyy').format(_patient.dateOfBirth)} (${DateTime.now().year - _patient.dateOfBirth.year} tuổi)",
            subtitle: "Sinh nhật",
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.family_restroom_outlined,
            title: _getRelationshipText(_patient.relationship),
            subtitle: "Mối quan hệ",
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.shield_outlined,
            title: _patient.hasInsurance
                ? "Có bảo hiểm y tế"
                : "Không có bảo hiểm y tế",
            subtitle: "Bảo hiểm",
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.fingerprint_outlined,
            title: _patient.patientCode,
            subtitle: "Mã bệnh nhân",
          ),
          const SizedBox(height: 24),
          _buildEmergencySection(),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = AppColors.primary,
    Color borderColor = AppColors.primaryBorder,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor ?? (iconColor == AppColors.primary ? AppColors.textHeader : iconColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeletePatient(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Xoá hồ sơ y tế",
          style: TextStyle(
            color: AppColors.textHeader,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Bạn có chắc chắn muốn xoá hồ sơ y tế của ${_patient.fullName}? Hành động này không thể hoàn tác.",
          style: const TextStyle(
            color: AppColors.textSlate,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "Hủy",
              style: TextStyle(
                color: AppColors.textSlate,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.roseDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              "Xoá",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      context.read<MedicalRecordDetailCubit>().deletePatient(_patient.id);
    }
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeader,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSlate,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Liên hệ khẩn cấp",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textHeader,
          ),
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.contact_phone_outlined,
          title: _patient.emergencyContactName ?? "N/A",
          subtitle: "Người liên hệ",
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.phone_forwarded_outlined,
          title: _patient.emergencyContactPhone ?? "N/A",
          subtitle: "SĐT liên hệ",
        ),
      ],
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
              "Chỉ số sinh hiệu",
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
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.activeBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
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
                  ),
                  _buildVitalVerticalDivider(),
                  _buildVitalItem(
                    Icons.speed_rounded,
                    "Huyết áp",
                    "${vitals.bloodPressureSystolic ?? '--'}/${vitals.bloodPressureDiastolic ?? '--'}",
                    "mmHg",
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Colors.white24, height: 1),
              ),
              Row(
                children: [
                  _buildVitalItem(
                    Icons.thermostat_rounded,
                    "Nhiệt độ",
                    "${vitals.temperature ?? '--'}",
                    "°C",
                  ),
                  _buildVitalVerticalDivider(),
                  _buildVitalItem(
                    Icons.air_rounded,
                    "Nhịp thở",
                    "${vitals.respiratoryRate ?? '--'}",
                    "Lần/P",
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Colors.white24, height: 1),
              ),
              Row(
                children: [
                  _buildVitalItem(
                    Icons.monitor_weight_outlined,
                    "Cân nặng",
                    "${vitals.weight ?? '--'}",
                    "kg",
                  ),
                  _buildVitalVerticalDivider(),
                  _buildVitalItem(
                    Icons.height_rounded,
                    "Chiều cao",
                    "${vitals.height ?? '--'}",
                    "cm",
                  ),
                ],
              ),
            ],
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
  ) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
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
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white24,
    );
  }

  Widget _buildNoVitalsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(Icons.analytics_outlined, color: Colors.grey[300], size: 40),
          const SizedBox(height: 8),
          const Text(
            "Chưa có chỉ số sinh hiệu",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeader,
            ),
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
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    final cubit = context.read<MedicalRecordDetailCubit>();
    await cubit.loadPatientDetail(_patient.id);
    if (mounted) {
      await context.read<PatientVitalsCubit>().loadLatestVitals(_patient.id);
    }
  }

  String _getGenderText(String gender) {
    switch (gender.toUpperCase()) {
      case "MALE":
        return "Nam";
      case "FEMALE":
        return "Nữ";
      default:
        return "Khác";
    }
  }

  String _getRelationshipText(String? rel) {
    if (rel == null || rel.isEmpty) return "Chủ tài khoản";
    switch (rel.toUpperCase()) {
      case "SELF":
        return "Chủ tài khoản";
      case "FATHER":
        return "Cha";
      case "MOTHER":
        return "Mẹ";
      case "WIFE":
        return "Vợ";
      case "HUSBAND":
        return "Chồng";
      case "CHILD":
        return "Con";
      default:
        return rel;
    }
  }
}
