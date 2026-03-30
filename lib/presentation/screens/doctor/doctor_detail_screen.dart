import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/doctor_detail.dart';
import 'package:e_health/presentation/screens/doctor/cubit/doctor_detail_cubit.dart';
import 'package:e_health/presentation/screens/doctor/cubit/doctor_detail_state.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';

class DoctorDetailScreen extends StatefulWidget {
  final String userId;

  const DoctorDetailScreen({super.key, required this.userId});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorDetailCubit>().loadDoctorDetail(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<DoctorDetailCubit, DoctorDetailState>(
        builder: (context, state) {
          if (state is DoctorDetailLoading) {
            return const AppLoadingWidget();
          } else if (state is DoctorDetailError) {
            return EmptyStateWidget(
              icon: Icons.error_outline_rounded,
              title: "Lỗi tải dữ liệu",
              subtitle: state.message,
              onAction: () => context
                  .read<DoctorDetailCubit>()
                  .loadDoctorDetail(widget.userId),
              actionLabel: "Thử lại",
            );
          } else if (state is DoctorDetailLoaded) {
            return _buildContent(context, state.doctor);
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () =>
              AppToast.showInfo(context, "Tính năng đang được xây dựng"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            "Đặt lịch khám ngay",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, DoctorDetail doctor) {
    return CustomScrollView(
      slivers: [
        // App Bar with Centered Profile
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          elevation: 0,
          backgroundColor: AppColors.primary,
          surfaceTintColor: AppColors.primary,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              onPressed: () =>
                  AppToast.showInfo(context, "Tính năng đang được xây dựng"),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, Color(0xFF1E40AF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Decorative Circles
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: -30,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),

                  // Profile Info
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      // Image Container
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: doctor.avatarUrl != null
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: doctor.avatarUrl!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const AppLoadingWidget(
                                          strokeWidth: 2,
                                        ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                          Icons.person,
                                          size: 60,
                                          color: AppColors.textLight,
                                        ),
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: AppColors.textLight,
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Name & title
                      Text(
                        doctor.fullName ?? "Bác sĩ",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.doctorTitle ?? "Bác sĩ chuyên khoa",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Quick action icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildHeaderAction(Icons.call_rounded, () {}),
                          const SizedBox(width: 20),
                          _buildHeaderAction(Icons.chat_bubble_rounded, () {}),
                          const SizedBox(width: 20),
                          _buildHeaderAction(Icons.videocam_rounded, () {}),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Content Body
        SliverToBoxAdapter(
          child: Container(
            transform: Matrix4.translationValues(0, -25, 0),
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  _buildSectionTitle("Giới thiệu"),
                  const SizedBox(height: 12),
                  _buildBodyCard(
                    child: Text(
                      doctor.biography ??
                          "Chưa có thông tin giới thiệu cho bác sĩ này.",
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSlate,
                        height: 1.6,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Experience Stats
                  Row(
                    children: [
                      _buildStatCard(
                        Icons.star_rounded,
                        "4.8",
                        "Rating",
                        Colors.amber,
                      ),
                      _buildStatCard(
                        Icons.person_pin_rounded,
                        "1.2k+",
                        "Patients",
                        Colors.blue,
                      ),
                      _buildStatCard(
                        Icons.history_rounded,
                        "12+",
                        "Exp Years",
                        Colors.green,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Contact Info
                  _buildSectionTitle("Thông tin liên hệ"),
                  const SizedBox(height: 12),
                  _buildBodyCard(
                    child: Column(
                      children: [
                        _buildContactRow(
                          Icons.phone_iphone_rounded,
                          "Điện thoại",
                          doctor.phone ?? "N/A",
                        ),
                        const Divider(height: 24, color: AppColors.grey100),
                        _buildContactRow(
                          Icons.email_outlined,
                          "Email",
                          doctor.email ?? "N/A",
                        ),
                        const Divider(height: 24, color: AppColors.grey100),
                        _buildContactRow(
                          Icons.location_on_outlined,
                          "Địa chỉ",
                          doctor.address ?? "N/A",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Professional details
                  _buildSectionTitle("Chuyên môn & Phí"),
                  const SizedBox(height: 12),
                  _buildBodyCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildProfessionalRow(
                          Icons.medical_services_rounded,
                          "Chuyên khoa",
                          doctor.specialtyName ?? "N/A",
                          Colors.blue.shade50,
                          Colors.blue,
                        ),
                        _buildProfessionalRow(
                          Icons.payments_rounded,
                          "Phí tư vấn",
                          _formatCurrency(doctor.consultationFee),
                          Colors.green.shade50,
                          Colors.green,
                        ),
                        _buildProfessionalRow(
                          Icons.transgender_rounded,
                          "Giới tính",
                          (doctor.gender == "MALE"
                              ? "Nam"
                              : (doctor.gender == "FEMALE" ? "Nữ" : "Khác")),
                          Colors.purple.shade50,
                          Colors.purple,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Workplaces
                  _buildSectionTitle("Nơi công tác"),
                  const SizedBox(height: 12),
                  if (doctor.facilities == null || doctor.facilities!.isEmpty)
                    _buildEmptyBox("Đang cập nhật danh sách cơ sở...")
                  else
                    ...doctor.facilities!
                        .map((f) => _buildWorkplaceCard(f))
                        .toList(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderAction(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textHeader,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildBodyCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.grey100),
      ),
      child: child,
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: AppColors.grey100),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textDark,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalRow(
    IconData icon,
    String label,
    String value,
    Color bgColor,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkplaceCard(DoctorFacility facility) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryBorder.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.apartment_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  facility.facilityName ?? "Bệnh viện/Phòng khám",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textHeader,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.room_outlined,
                      size: 14,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${facility.departmentName} - ${facility.branchName}",
                        style: const TextStyle(
                          color: AppColors.textSlate,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    facility.roleTitle ?? "Chức vụ",
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey100, style: BorderStyle.solid),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.textLight,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  String _formatCurrency(String? amount) {
    if (amount == null) return "N/A";
    try {
      final double val = double.parse(amount);
      return "${val.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ";
    } catch (_) {
      return amount;
    }
  }
}
