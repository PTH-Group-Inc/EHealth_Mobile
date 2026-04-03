import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/doctor.dart';
import 'package:e_health/presentation/screens/home/cubit/home_doctor_cubit.dart';
import 'package:e_health/presentation/screens/home/cubit/home_doctor_state.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';

class HomeDoctorsWidget extends StatelessWidget {
  const HomeDoctorsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 0, top: 15),
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
                      "Bác sĩ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => context.push('/all-doctors'),
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
          BlocBuilder<HomeDoctorCubit, HomeDoctorState>(
            builder: (context, state) {
              if (state.status == HomeDoctorStatus.loading &&
                  state.doctors.isEmpty) {
                return const SizedBox(height: 200, child: AppLoadingWidget());
              } else if (state.status == HomeDoctorStatus.failure &&
                  state.doctors.isEmpty) {
                return SizedBox(
                  height: 200,
                  child: EmptyStateWidget(
                    icon: Icons.error_outline_rounded,
                    title: "Lỗi tải dữ liệu",
                    subtitle:
                        state.errorMessage ?? "Đã xảy ra lỗi không xác định",
                    onAction: () =>
                        context.read<HomeDoctorCubit>().loadDoctors(),
                    actionLabel: "Thử lại",
                  ),
                );
              } else {
                if (state.doctors.isEmpty) {
                  return const SizedBox(
                    height: 200,
                    child: EmptyStateWidget(
                      icon: Icons.person_search_outlined,
                      title: "Không có dữ liệu",
                      subtitle: "Hiện tại chưa có bác sĩ nào sẵn sàng.",
                    ),
                  );
                }
                final displayDoctors = state.doctors.take(10).toList();
                return SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: displayDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = displayDoctors[index];
                      return _buildDoctorCard(context, doctor);
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Doctor doctor) {
    return Padding(
      padding: const EdgeInsets.only(right: 18, bottom: 12, top: 4, left: 4),
      child: InkWell(
        onTap: () => context.push('/doctor-detail/${doctor.userId}'),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.12),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Hero(
                  tag: 'doctor_avatar_${doctor.userId}',
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child:
                          doctor.avatarUrl != null &&
                              doctor.avatarUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: doctor.avatarUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: AppLoadingWidget(strokeWidth: 2),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person_rounded,
                                size: 40,
                                color: AppColors.textLight,
                              ),
                            )
                          : const Icon(
                              Icons.person_rounded,
                              size: 40,
                              color: AppColors.textLight,
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Doctor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        doctor.title ?? "Bác sĩ",
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      doctor.fullName ?? "Họ tên",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialtyName ?? "Chuyên khoa",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSlate,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (doctor.phone != null && doctor.phone!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.phone_android_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              doctor.phone!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
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
        ),
      ),
    );
  }
}
