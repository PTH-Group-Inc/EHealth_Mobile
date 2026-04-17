import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_color.dart';
import '../../../app/theme/app_shadow.dart';
import '../../widgets/feedback/app_refresh.dart';
import '../../widgets/feedback/empty_state_widget.dart';

import '../../widgets/feedback/app_loading_widget.dart';
import '../user_profile/cubit/user_profile_cubit.dart';
import '../user_profile/cubit/user_profile_state.dart';
import 'cubit/medical_record_cubit.dart';
import 'cubit/medical_record_state.dart';

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
              colors: [AppColors.primary, Color(0xFF1E40AF)],
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
        child: BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
          builder: (context, state) {
            if (state is MedicalRecordLoading) {
              return const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 500,
                  child: Center(child: AppLoadingWidget()),
                ),
              );
            }

            if (state is MedicalRecordError) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 500,
                  child: EmptyStateWidget(
                    icon: Icons.error_outline_rounded,
                    title: "Lỗi tải dữ liệu",
                    subtitle: state.message,
                    onAction: _loadData,
                    actionLabel: "Thử lại",
                  ),
                ),
              );
            }

            if (state is MedicalRecordEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 500,
                  child: Center(
                    child: EmptyStateWidget(
                      icon: Icons.medical_information_outlined,
                      title: "Chưa có hồ sơ y tế",
                      subtitle:
                          "Bạn chưa tạo hồ sơ y tế nào. Vui lòng thêm hồ sơ để dễ dàng quản lý sức khỏe.",
                      actionLabel: "Thêm hồ sơ ngay",
                      onAction: () => context.push('/create-medical-record'),
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
                  return GestureDetector(
                    onTap: () {
                      context.push('/medical-record-detail', extra: patient);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppShadow.cardShadow,
                        border: Border.all(
                          color: AppColors.primaryBorder.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_pin_outlined,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                            ? Colors.pink.withValues(alpha: 0.1)
                                            : Colors.cyan.withValues(
                                                alpha: 0.1,
                                              ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        patient.gender == "FEMALE"
                                            ? "Nữ"
                                            : "Nam",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: patient.gender == "FEMALE"
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

            return const SizedBox.shrink();
          },
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
