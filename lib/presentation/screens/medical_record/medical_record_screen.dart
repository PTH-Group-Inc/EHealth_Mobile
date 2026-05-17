import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/theme/app_shadow.dart';
import 'package:e_health/domain/avatar.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_cubit.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_state.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';
import 'package:e_health/presentation/widgets/feedback/app_refresh.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_cubit.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_state.dart';

class MedicalRecordScreen extends StatefulWidget {
  const MedicalRecordScreen({super.key});

  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final userProfileState = context.read<UserProfileCubit>().state;
    if (userProfileState is UserProfileLoaded) {
      context.read<MedicalRecordCubit>().loadMedicalRecord(
        userProfileState.profile.id,
      );
    } else {
      context.read<UserProfileCubit>().loadProfile().then((_) {
        if (!mounted) return;
        final newState = context.read<UserProfileCubit>().state;
        if (newState is UserProfileLoaded) {
          context.read<MedicalRecordCubit>().loadMedicalRecord(
            newState.profile.id,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text(
          "Hồ sơ y tế",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: AppRefresh(
        onRefresh: () async {
          _loadData();
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<MedicalRecordCubit, MedicalRecordState>(
              listener: (context, state) {
                if (state is MedicalRecordError) {
                  AppToast.showError(context, state.message);
                }
              },
            ),
            BlocListener<UserProfileCubit, UserProfileState>(
              listener: (context, state) {
                if (state is UserProfileError) {
                  AppToast.showError(context, state.message);
                }
              },
            ),
          ],
          child: BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, userState) {
              return BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
                builder: (context, state) {
                  if (userState is UserProfileLoading ||
                      state is MedicalRecordLoading) {
                    return LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: const Center(child: AppLoadingWidget()),
                        ),
                      ),
                    );
                  }

                  if (userState is UserProfileError) {
                    return LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: EmptyStateWidget(
                            icon: Icons.error_outline_rounded,
                            title: "Lỗi tải thông tin cá nhân",
                            subtitle: userState.message,
                            onAction: _loadData,
                            actionLabel: "Thử lại",
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is MedicalRecordError) {
                    return LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: EmptyStateWidget(
                            icon: Icons.error_outline_rounded,
                            title: "Lỗi tải dữ liệu",
                            subtitle: state.message,
                            onAction: _loadData,
                            actionLabel: "Thử lại",
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is MedicalRecordEmpty) {
                    return LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: EmptyStateWidget(
                            icon: Icons.medical_information_outlined,
                            title: "Chưa có hồ sơ y tế",
                            subtitle:
                                "Bạn chưa tạo hồ sơ y tế nào. Vui lòng thêm hồ sơ để dễ dàng quản lý sức khỏe.",
                            actionLabel: "Thêm hồ sơ ngay",
                            onAction: () =>
                                context.push('/create-medical-record'),
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is MedicalRecordLoaded) {
                    final patients = state.patients;
                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: patients.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final patient = patients[index];
                        // Get latest avatar
                        final avatars = List<Avatar>.from(patient.avatarUrl);
                        avatars.sort((Avatar a, Avatar b) {
                          final dateA = a.uploadedAt ?? DateTime(0);
                          final dateB = b.uploadedAt ?? DateTime(0);
                          return dateB.compareTo(dateA);
                        });
                        final String? avatarUrl = avatars.isNotEmpty
                            ? avatars.first.url
                            : null;

                        return GestureDetector(
                          onTap: () async {
                            final result = await context.push(
                              '/medical-record-detail',
                              extra: patient,
                            );
                            if (result == true) {
                              _loadData();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: AppShadow.cardShadow,
                              border: Border.all(
                                color: AppColors.primaryBorder.withValues(
                                  alpha: 0.5,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    image: avatarUrl != null
                                        ? DecorationImage(
                                            image: CachedNetworkImageProvider(
                                              avatarUrl,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: avatarUrl == null
                                      ? const Icon(
                                          Icons.person_pin_outlined,
                                          color: AppColors.primary,
                                          size: 28,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        patient.fullName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textHeader,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Mã bệnh nhân: ${patient.patientCode}",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSlate,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: patient.gender == "FEMALE"
                                                  ? Colors.pink.withValues(
                                                      alpha: 0.1,
                                                    )
                                                  : Colors.cyan.withValues(
                                                      alpha: 0.1,
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              patient.gender == "FEMALE"
                                                  ? "Nữ"
                                                  : "Nam",
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    patient.gender == "FEMALE"
                                                    ? Colors.pink
                                                    : Colors.cyan,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            DateFormat(
                                              'dd/MM/yyyy',
                                            ).format(patient.dateOfBirth),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSlate,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: AppColors.textSlate,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(height: constraints.maxHeight),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-medical-record'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Thêm hồ sơ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
