import 'package:flutter/material.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/theme/app_shadow.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_health/domain/specialty.dart';
import 'package:e_health/presentation/screens/home/cubit/home_specialty_cubit.dart';
import 'package:e_health/presentation/screens/home/cubit/home_specialty_state.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';

class HomeSpecialtiesWidget extends StatelessWidget {
  const HomeSpecialtiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 0, top: 5),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Chuyên khoa nổi bật",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => context.pushNamed('all-specialty'),
                  child: const Text(
                    "Xem tất cả",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          BlocBuilder<HomeSpecialtyCubit, HomeSpecialtyState>(
            builder: (context, state) {
              if (state is HomeSpecialtyLoading) {
                return const SizedBox(height: 250, child: AppLoadingWidget());
              } else if (state is HomeSpecialtyError) {
                return SizedBox(
                  height: 250,
                  child: EmptyStateWidget(
                    isCompact: true,
                    icon: Icons.error_outline_rounded,
                    title: "Lỗi tải dữ liệu",
                    subtitle: state.message,
                    onAction: () =>
                        context.read<HomeSpecialtyCubit>().loadSpecialties(),
                    actionLabel: "Thử lại",
                  ),
                );
              } else if (state is HomeSpecialtyLoaded) {
                if (state.specialties.isEmpty) {
                  return const SizedBox(
                    height: 250,
                    child: EmptyStateWidget(
                      isCompact: true,
                      icon: Icons.medical_services_outlined,
                      title: "Không có dữ liệu",
                      subtitle: "Hiện tại chưa có chuyên khoa nổi bật.",
                    ),
                  );
                }
                return SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.specialties.length,
                    itemBuilder: (context, index) {
                      final specialty = state.specialties[index];
                      return _buildSpecialtyCard(context, specialty);
                    },
                  ),
                );
              }
              return const SizedBox(height: 250);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtyCard(BuildContext context, Specialty specialty) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'specialty-detail',
            pathParameters: {'id': specialty.id ?? ""},
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primaryBorder.withValues(alpha: 0.5),
              width: 1.5,
            ),
            color: Colors.white,
            boxShadow: AppShadow.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phần hình ảnh mặc định cho chuyên khoa
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.1),
                            AppColors.primary.withValues(alpha: 0.2),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child:
                          specialty.logoUrl != null &&
                              specialty.logoUrl!.isNotEmpty
                          ? Image.network(
                              specialty.logoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.medical_services_outlined,
                                    size: 50,
                                    color: AppColors.primary,
                                  ),
                            )
                          : const Icon(
                              Icons.medical_services_outlined,
                              size: 50,
                              color: AppColors.primary,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        specialty.code ?? "N/A",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Phần thông tin
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      specialty.name ?? "Chưa có tên",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      specialty.description ?? "Nội dung đang được cập nhật",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
