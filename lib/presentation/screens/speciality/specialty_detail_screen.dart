import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/specialty.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'cubit/specialty_detail_cubit.dart';
import 'cubit/specialty_detail_state.dart';
import 'widgets/specialty_booking_bottom_sheet.dart';

class SpecialtyDetailScreen extends StatefulWidget {
  final String departmentId;

  const SpecialtyDetailScreen({super.key, required this.departmentId});

  @override
  State<SpecialtyDetailScreen> createState() => _SpecialtyDetailScreenState();
}

class _SpecialtyDetailScreenState extends State<SpecialtyDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<SpecialtyDetailCubit>().loadDepartmentDetail(
      widget.departmentId,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SpecialtyDetailCubit>().loadMoreServices();
    }
  }

  Future<void> _launchMaps(String? address) async {
    if (address == null || address.isEmpty) return;

    // Thử mở bằng sơ đồ google.navigation (Android) hoặc maps.apple (iOS)
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}";
    final String appleMapsUrl =
        "https://maps.apple.com/?q=${Uri.encodeComponent(address)}";

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(
        Uri.parse(googleMapsUrl),
        mode: LaunchMode.externalApplication,
      );
    } else if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
      await launchUrl(
        Uri.parse(appleMapsUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      // Fallback cho trình duyệt nếu không mở được app bản đồ
      await launchUrl(
        Uri.parse(googleMapsUrl),
        mode: LaunchMode.platformDefault,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<SpecialtyDetailCubit, SpecialtyDetailState>(
        builder: (context, state) {
          if (state.status == SpecialtyDetailStatus.loading) {
            return const AppLoadingWidget();
          }

          if (state.status == SpecialtyDetailStatus.failure) {
            return EmptyStateWidget(
              icon: Icons.error_outline_rounded,
              title: "Lỗi tải dữ liệu",
              subtitle: state.errorMessage ?? "Đã xảy ra lỗi không xác định",
              onAction: () => context.read<SpecialtyDetailCubit>().loadDepartmentDetail(
                    widget.departmentId,
                  ),
              actionLabel: "Thử lại",
            );
          }

          if (state.status == SpecialtyDetailStatus.success &&
              state.department != null) {
            final dept = state.department!;
            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    await context
                        .read<SpecialtyDetailCubit>()
                        .loadDepartmentDetail(widget.departmentId);
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        _buildHeaderImage(context, dept),
                        Transform.translate(
                          offset: const Offset(0, -32),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFloatingInfoCard(dept),
                                const SizedBox(height: 32),
                                _buildSectionTitle('Dịch vụ chuyên khoa'),
                                const SizedBox(height: 12),
                                if (state.specialties.isEmpty)
                                  const Text(
                                    'Chưa cập nhật thông tin chuyên khoa.',
                                    style: TextStyle(
                                      color: AppColors.textSlate,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )
                                else
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: state.specialties.map((s) {
                                      final isSelected =
                                          state.selectedSpecialty?.id == s.id;
                                      return _buildServiceChip(s, isSelected);
                                    }).toList(),
                                  ),
                                const SizedBox(height: 24),
                                _buildSectionTitle('Vị trí'),
                                const SizedBox(height: 12),
                                _buildMapPlaceholder(state.branch?.address),
                                const SizedBox(height: 24),
                                _buildSectionTitle('Đánh giá'),
                                const SizedBox(height: 12),
                                _buildReviewsPlaceholder(),
                                const SizedBox(height: 24),
                                _buildSectionTitle('Dịch vụ của khoa'),
                                const SizedBox(height: 12),
                                if (state.isLoadingServices)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else if (state.services.isNotEmpty)
                                  Column(
                                    children: [
                                      ...state.services.map(
                                        (service) => GestureDetector(
                                          onTap: () {
                                            // TODO: Click to booking specialty service
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: AppColors.primary
                                                    .withValues(alpha: 0.1),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.02),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary
                                                        .withValues(alpha: 0.1),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons
                                                        .medical_services_outlined,
                                                    color: AppColors.primary,
                                                    size: 20,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        service.serviceName,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: AppColors
                                                              .textDark,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        "${service.basePrice.replaceAll('.00', '')} VNĐ",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (state.isFetchingMoreServices)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 20,
                                          ),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                else
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.error.withValues(
                                        alpha: 0.05,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: AppColors.error.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline_rounded,
                                          color: AppColors.error,
                                          size: 20,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'Khoa này hiện chưa được cập nhật dịch vụ khám.',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppColors.error,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 120),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildTopActionButtons(context),
                _buildBottomAction(context, state),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context, dynamic dept) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
      ),
      child: dept.logoUrl != null && dept.logoUrl!.isNotEmpty
          ? Image.network(dept.logoUrl!, fit: BoxFit.cover)
          : Container(
              color: AppColors.primary.withValues(alpha: 0.2),
              child: const Icon(
                Icons.apartment_rounded,
                size: 80,
                color: AppColors.primary,
              ),
            ),
    );
  }

  Widget _buildTopActionButtons(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.textDark,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: IconButton(
              icon: const Icon(
                Icons.favorite_border,
                color: AppColors.textDark,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingInfoCard(dynamic dept) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dept.name ?? 'Chuyên khoa E-Health',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '4.8 (1.2k+)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: const Text(
                  'Sẵn sàng 24/7',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.textSlate,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dept.branchName ?? 'Đang cập nhật địa chỉ...',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSlate,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildServiceChip(Specialty specialty, bool isSelected) {
    return GestureDetector(
      onTap: () =>
          context.read<SpecialtyDetailCubit>().selectSpecialty(specialty),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          specialty.name ?? 'Chuyên khoa',
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMapPlaceholder(String? address) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _launchMaps(address),
          child: Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Lớp nền bản đồ
                  Image.network(
                    'https://static.vecteezy.com/system/resources/thumbnails/010/801/642/small/aerial-clean-top-view-of-the-night-time-city-map-with-street-and-river-001-vector.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      child: const Center(
                        child: Icon(
                          Icons.map_outlined,
                          color: AppColors.primary,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  // Lớp phủ Gradient đen phía dưới để làm nổi bật thông tin
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                  // Pin vị trí ở giữa - Căn chỉnh chính xác
                  const Center(
                    child: Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primary,
                      size: 42,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                  ),
                  // Thông tin địa chỉ và nút Dẫn đường - Phối hợp hài hòa
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Vị trí bệnh viện',
                                  style: TextStyle(
                                    color: AppColors.textSlate,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  address ?? 'Đang tải địa chỉ...',
                                  style: const TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, Color(0xFF2563EB)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.directions_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Dẫn đường',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.rate_review_outlined,
            color: AppColors.primary.withValues(alpha: 0.3),
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            'Chưa có đánh giá nào cho chuyên khoa này.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSlate.withValues(alpha: 0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, SpecialtyDetailState state) {
    if (state.department == null) return const SizedBox.shrink();
    final hasServices = state.services.isNotEmpty;
    final canBook =
        state.selectedSpecialty != null &&
        !state.isLoadingServices &&
        hasServices;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).padding.bottom + 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: canBook
              ? () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => SpecialtyBookingBottomSheet(
                      department: state.department!,
                      services: state.services,
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.grey300,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          child: Text(
            !hasServices && state.selectedSpecialty != null
                ? 'Chưa cập nhật dịch vụ'
                : 'Đặt lịch ngay',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
