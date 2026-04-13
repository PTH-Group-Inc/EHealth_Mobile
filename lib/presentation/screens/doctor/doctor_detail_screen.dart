import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/doctor_detail.dart';
import 'package:e_health/domain/avatar.dart';
import 'package:e_health/presentation/screens/doctor/cubit/doctor_detail_cubit.dart';
import 'package:e_health/presentation/screens/doctor/cubit/doctor_detail_state.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';
import 'package:e_health/presentation/widgets/data_display/full_screen_image_viewer.dart';
import 'widgets/booking_bottom_sheet.dart';

class DoctorDetailScreen extends StatefulWidget {
  final String userId;

  const DoctorDetailScreen({super.key, required this.userId});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  int _currentImageIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

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
      backgroundColor: AppColors.primaryBackground,
      body: BlocBuilder<DoctorDetailCubit, DoctorDetailState>(
        builder: (context, state) {
          if (state is DoctorDetailLoading) {
            return const AppLoadingWidget();
          } else if (state is DoctorDetailError) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<DoctorDetailCubit>().loadDoctorDetail(
                  widget.userId,
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: EmptyStateWidget(
                    icon: Icons.error_outline_rounded,
                    title: "Lỗi tải dữ liệu",
                    subtitle: state.message,
                    onAction: () => context
                        .read<DoctorDetailCubit>()
                        .loadDoctorDetail(widget.userId),
                    actionLabel: "Thử lại",
                  ),
                ),
              ),
            );
          } else if (state is DoctorDetailLoaded) {
            return _buildContent(context, state);
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: _buildBottomAction(context),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return BlocBuilder<DoctorDetailCubit, DoctorDetailState>(
      builder: (context, state) {
        bool isEnabled = false;
        String buttonText = "Đặt lịch khám ngay";
        VoidCallback? onPressed;

        if (state is DoctorDetailLoaded) {
          final hasAvailability =
              state.availability != null && state.availability!.isNotEmpty;

          if (state.availabilityLoading) {
            buttonText = "Đang kiểm tra lịch khám...";
            isEnabled = false;
          } else if (!hasAvailability) {
            buttonText = "Bác sĩ này chưa có lịch khám";
            isEnabled = false;
          } else {
            buttonText = "Đặt lịch khám ngay";
            isEnabled = true;
            onPressed = () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => BookingBottomSheet(
                  doctor: state.doctor,
                  availability: state.availability ?? {},
                ),
              );
            };
          }
        }

        return Container(
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
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnabled ? AppColors.primary : AppColors.grey300,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }


  Widget _buildContent(BuildContext context, DoctorDetailLoaded state) {
    final doctor = state.doctor;
    final avatars = List<Avatar>.from(doctor.avatars ?? []);
    // Sort by uploadedAt descending (Latest first)
    avatars.sort((a, b) {
      final dateA = a.uploadedAt ?? DateTime(0);
      final dateB = b.uploadedAt ?? DateTime(0);
      return dateB.compareTo(dateA);
    });

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<DoctorDetailCubit>().loadDoctorDetail(widget.userId);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildImageSection(doctor, avatars),
            _buildPrimaryBorder(),
            _buildMainInfoSection(doctor),
            _buildProfessionalDetails(doctor),
            _buildWorkplaces(doctor),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(DoctorDetail doctor, List<Avatar> avatars) {
    final hasMultipleImages = avatars.length >= 2;

    return Stack(
      children: [
        // Carousel
        if (avatars.isNotEmpty)
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.width * 1.2,
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
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    placeholder: (context, url) =>
                        const AppLoadingWidget(strokeWidth: 2),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.person,
                      size: 100,
                      color: AppColors.grey300,
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        else
          Container(
            height: MediaQuery.of(context).size.width * 1.2,
            width: double.infinity,
            color: AppColors.grey100,
            child: const Icon(
              Icons.person,
              size: 100,
              color: AppColors.grey300,
            ),
          ),

        // Back Button
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 10,
          child: IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.3),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
            onPressed: () => context.pop(),
          ),
        ),

        // Share Button
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          right: 10,
          child: IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.3),
              child: const Icon(
                Icons.share_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
            onPressed: () =>
                AppToast.showInfo(context, "Tính năng đang được xây dựng"),
          ),
        ),

        // Story Indicators (Index)
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
      ],
    );
  }

  Widget _buildPrimaryBorder() {
    return Container(
      height: 4,
      width: double.infinity,
      color: AppColors.primary,
    );
  }

  Widget _buildMainInfoSection(DoctorDetail doctor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doctor.fullName ?? "Bác sĩ",
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            doctor.doctorTitle ?? "Bác sĩ chuyên khoa",
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (doctor.email != null) ...[
            const SizedBox(height: 4),
            Text(
              doctor.email!,
              style: const TextStyle(color: AppColors.grey500, fontSize: 14),
            ),
          ],
          const SizedBox(height: 24),

          // Quick Action Buttons
          Row(
            children: [
              _buildHeaderAction(Icons.call_rounded, "Gọi điện"),
              const SizedBox(width: 12),
              _buildHeaderAction(Icons.chat_bubble_rounded, "Nhắn tin"),
              const SizedBox(width: 12),
              _buildHeaderAction(Icons.videocam_rounded, "Video call"),
            ],
          ),

          const SizedBox(height: 32),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, String label) {
    return Expanded(
      child: InkWell(
        onTap: () => AppToast.showInfo(context, "Tính năng đang được xây dựng"),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalDetails(DoctorDetail doctor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                const Divider(height: 1, color: AppColors.grey100),
                _buildProfessionalRow(
                  Icons.payments_rounded,
                  "Phí tư vấn",
                  _formatCurrency(doctor.consultationFee),
                  Colors.green.shade50,
                  Colors.green,
                ),
                const Divider(height: 1, color: AppColors.grey100),
                _buildProfessionalRow(
                  Icons.phone_outlined,
                  "Liên hệ",
                  doctor.phone ?? "N/A",
                  Colors.orange.shade50,
                  Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkplaces(DoctorDetail doctor) {
    if (doctor.facilities == null || doctor.facilities!.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Nơi công tác"),
          const SizedBox(height: 12),
          ...doctor.facilities!.map((f) => _buildWorkplaceCard(f)),
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
        border: Border.all(color: AppColors.grey100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
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
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${facility.departmentName} - ${facility.branchName}",
                  style: const TextStyle(
                    color: AppColors.textSlate,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
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
        border: Border.all(color: AppColors.grey100),
      ),
      child: child,
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
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Text(
            label,
            style: const TextStyle(color: AppColors.textSlate, fontSize: 14),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
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
