import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_health/presentation/widgets/data_display/doctor_card.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/screens/home/cubit/home_doctor_cubit.dart';
import 'package:e_health/presentation/screens/home/cubit/home_doctor_state.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';

class HomeDoctorsWidget extends StatelessWidget {
  const HomeDoctorsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
                        color: AppColors.textDark,
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
                  height: 220,
                  child: EmptyStateWidget(
                    isCompact: true,
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
                    height: 220,
                    child: EmptyStateWidget(
                      isCompact: true,
                      icon: Icons.person_search_outlined,
                      title: "Không có dữ liệu",
                      subtitle: "Hiện tại chưa có bác sĩ nào sẵn sàng.",
                    ),
                  );
                }
                final displayDoctors = state.doctors.take(10).toList();
                return SizedBox(
                  height: 170,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(right: 20, bottom: 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: displayDoctors.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final doctor = displayDoctors[index];
                      return DoctorCard(doctor: doctor);
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
}
