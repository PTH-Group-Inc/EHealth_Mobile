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
import 'package:e_health/presentation/widgets/feedback/app_refresh.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';

class AllDoctorScreen extends StatefulWidget {
  const AllDoctorScreen({super.key});

  @override
  State<AllDoctorScreen> createState() => _AllDoctorScreenState();
}

class _AllDoctorScreenState extends State<AllDoctorScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    // No need to load if already loaded on home, but good for safety
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<HomeDoctorCubit>().state.status !=
          HomeDoctorStatus.success) {
        context.read<HomeDoctorCubit>().loadDoctors();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HomeDoctorCubit>().loadMoreDoctors();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textDark,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Danh sách bác sĩ',
          style: TextStyle(
            color: AppColors.textHeader,
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: AppRefresh(
              onRefresh: () async {
                await context.read<HomeDoctorCubit>().loadDoctors();
              },
              child: BlocBuilder<HomeDoctorCubit, HomeDoctorState>(
                builder: (context, state) {
                  if (state.status == HomeDoctorStatus.loading &&
                      state.doctors.isEmpty) {
                    return const Center(child: AppLoadingWidget());
                  } else if (state.status == HomeDoctorStatus.failure &&
                      state.doctors.isEmpty) {
                    return EmptyStateWidget(
                      icon: Icons.error_outline_rounded,
                      title: "Lỗi tải dữ liệu",
                      subtitle:
                          state.errorMessage ?? "Đã xảy ra lỗi không xác định",
                      onAction: () =>
                          context.read<HomeDoctorCubit>().loadDoctors(),
                      actionLabel: "Thử lại",
                    );
                  } else {
                    final doctors = state.doctors;
                    if (doctors.isEmpty) {
                      return const EmptyStateWidget(
                        icon: Icons.person_search_outlined,
                        title: "Không tìm thấy bác sĩ",
                        subtitle:
                            "Hiện tại hệ thống chưa có bác sĩ nào sẵn sàng.",
                      );
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                      itemCount:
                          doctors.length + (state.isFetchingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < doctors.length) {
                          return _buildDoctorItem(context, doctors[index]);
                        }
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: AppLoadingWidget(size: 24)),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorItem(BuildContext context, Doctor doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryBorder.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: AppShadow.cardShadow,
      ),
      child: InkWell(
        onTap: () => context.push('/doctor-detail/${doctor.userId}'),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: doctor.avatarUrl.isNotEmpty
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: doctor.avatarUrl[0].url,
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
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.fullName ?? "Bác sĩ",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textHeader,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      doctor.specialtyName ?? "Chuyên khoa",
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSlate,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            doctor.title ?? "BS",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
