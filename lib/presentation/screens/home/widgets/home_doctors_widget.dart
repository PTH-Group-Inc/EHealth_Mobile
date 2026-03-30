import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/theme/app_shadow.dart';
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
                const Text(
                  "Bác sĩ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push('/all-doctors'),
                  child: const Text(
                    "Xem tất cả",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          BlocBuilder<HomeDoctorCubit, HomeDoctorState>(
            builder: (context, state) {
              if (state is HomeDoctorLoading) {
                return const SizedBox(height: 200, child: AppLoadingWidget());
              } else if (state is HomeDoctorError) {
                return SizedBox(
                  height: 200,
                  child: EmptyStateWidget(
                    icon: Icons.error_outline_rounded,
                    title: "Lỗi tải dữ liệu",
                    subtitle: state.message,
                    onAction: () =>
                        context.read<HomeDoctorCubit>().loadDoctors(),
                    actionLabel: "Thử lại",
                  ),
                );
              } else if (state is HomeDoctorLoaded) {
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
                final displayDoctors = state.doctors.take(5).toList();
                return SizedBox(
                  height: 200,
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
              return const SizedBox(height: 200);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Doctor doctor) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, bottom: 10, top: 2),
      child: InkWell(
        onTap: () => context.push('/doctor-detail/${doctor.userId}'),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(color: AppColors.primary, width: 0.3),
            boxShadow: AppShadow.cardShadow,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: doctor.avatarUrl != null
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: doctor.avatarUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const AppLoadingWidget(strokeWidth: 2),
                          errorWidget: (context, url, error) => const Icon(
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
              const SizedBox(height: 12),
              Text(
                doctor.fullName ?? "Bác sĩ",
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                doctor.specialtyName ?? "Chuyên khoa",
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  doctor.title ?? "BS",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
