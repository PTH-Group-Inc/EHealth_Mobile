import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_color.dart';
import 'cubit/specialty_detail_cubit.dart';
import 'cubit/specialty_detail_state.dart';
import '../../widgets/feedback/app_loading_widget.dart';
import '../../widgets/feedback/app_refresh.dart';
import '../../../../domain/specialty.dart';
import '../../../../domain/booking_model.dart';

class SpecialtyDetailScreen extends StatefulWidget {
  final String departmentId;

  const SpecialtyDetailScreen({super.key, required this.departmentId});

  @override
  State<SpecialtyDetailScreen> createState() => _SpecialtyDetailScreenState();
}

class _SpecialtyDetailScreenState extends State<SpecialtyDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SpecialtyDetailCubit>().loadDepartmentDetail(
      widget.departmentId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<SpecialtyDetailCubit, SpecialtyDetailState>(
        builder: (context, state) {
          if (state is SpecialtyDetailLoading) {
            return const AppLoadingWidget();
          }

          if (state is SpecialtyDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SpecialtyDetailCubit>().loadDepartmentDetail(
                        widget.departmentId,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (state is SpecialtyDetailLoaded) {
            final dept = state.department;
            return Stack(
              children: [
                AppRefresh(
                  onRefresh: () async {
                    await context
                        .read<SpecialtyDetailCubit>()
                        .loadDepartmentDetail(widget.departmentId);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header & Profile Card - Nested Stack to make Card scrollable
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _buildHeaderImage(context, dept),
                            Positioned(
                              bottom: -70,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: _buildFloatingInfoCard(dept),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 90,
                        ), // Spacing for the overlapping card
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Về chúng tôi'),
                              const SizedBox(height: 12),
                              Text(
                                dept.description ??
                                    'Hệ thống Y tế EHealth là hệ thống y tế tư nhân hàng đầu Việt Nam, cung cấp dịch vụ chăm sóc sức khỏe toàn diện với đội ngũ chuyên gia đầu ngành và trang thiết bị hiện đại bậc nhất.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textDark.withValues(
                                    alpha: 0.8,
                                  ),
                                  height: 1.6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildSectionTitle('Dịch vụ chuyên khoa'),
                              const SizedBox(height: 12),
                              if (state.specialties.isEmpty)
                                Text(
                                  'Hiện chưa có chuyên khoa cụ thể cho khoa này.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSlate.withValues(
                                      alpha: 0.7,
                                    ),
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
                              _buildMapPlaceholder(),
                              const SizedBox(height: 24),
                              _buildSectionTitle('Đánh giá'),
                              const SizedBox(height: 12),
                              _buildReviewsPlaceholder(),
                              const SizedBox(height: 24),
                              _buildSectionTitle('Dịch vụ của khoa'),
                              const SizedBox(height: 12),
                              if (state.isLoadingServices)
                                const Center(child: CircularProgressIndicator())
                              else if (state.services.isNotEmpty)
                                Column(
                                  children: state.services
                                      .map(
                                        (service) => Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            border: Border.all(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.1),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.02,
                                                ),
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      service.serviceName,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            AppColors.textDark,
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
                                      )
                                      .toList(),
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
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline_rounded,
                                        color: AppColors.error,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Khoa này hiện chưa được cập nhật dịch vụ khám.',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.error.withValues(
                                              alpha: 0.8,
                                            ),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 36),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Top Buttons
                _buildTopActionButtons(context),
                // Bottom Action
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
                  dept.branchName ?? '347 - 350 Thống Nhất, TP.HCM',
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

  Widget _buildMapPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Image.network(
              'https://static.vecteezy.com/system/resources/thumbnails/010/801/642/small/aerial-clean-top-view-of-the-night-time-city-map-with-street-and-river-001-vector.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(color: Colors.black.withValues(alpha: 0.1)),
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildBottomAction(BuildContext context, SpecialtyDetailLoaded state) {
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
                  final bookingModel = BookingModel(
                    patientId: '', // Sẽ được cập nhật tại PatientSelectScreen
                    patientName: '',
                    branchId: state.department.branchId,
                    branchName: state.department.branchName,
                    facilityId: state.department.branchId,
                    departmentId: state.department.departmentsId,
                    departmentName: state.department.name,
                  );

                  context.pushNamed(
                    'patient-select',
                    queryParameters: {'mode': 'appointment'},
                    extra: bookingModel,
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
