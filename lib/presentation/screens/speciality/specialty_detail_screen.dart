import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/theme/app_color.dart';
import 'cubit/specialty_detail_cubit.dart';
import 'cubit/specialty_detail_state.dart';

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
            return const Center(
              child: CircularProgressIndicator(color: AppColors.success),
            );
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
                SingleChildScrollView(
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
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _buildServiceChip(dept.name ?? 'Đa khoa'),
                                _buildServiceChip('Sản phụ khoa'),
                                _buildServiceChip('Nhi khoa'),
                                _buildServiceChip('Nội tổng quát'),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildSectionTitle('Vị trí'),
                            const SizedBox(height: 12),
                            _buildMapPlaceholder(),
                            const SizedBox(height: 24),
                            _buildSectionTitle('Đánh giá'),
                            const SizedBox(height: 12),
                            _buildReviewsPlaceholder(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Top Buttons
                _buildTopActionButtons(context),
                // Bottom Action
                _buildBottomAction(),
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
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
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

  Widget _buildServiceChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        image: const DecorationImage(
          image: NetworkImage(
            'https://static.vinwonders.com/production/vinmec-nha-trang-1.jpg',
          ), // placeholder map
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: const Icon(
            Icons.location_on,
            color: AppColors.primary,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsPlaceholder() {
    return Text(
      'Chưa có đánh giá nào cho chuyên khoa này.',
      style: TextStyle(
        fontSize: 14,
        color: AppColors.textSlate.withValues(alpha: 0.7),
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildBottomAction() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Đặt lịch ngay',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
