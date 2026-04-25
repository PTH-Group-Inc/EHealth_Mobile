import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_health/domain/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/theme/app_shadow.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_cubit.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_state.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_cubit.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_state.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:e_health/domain/booking_model.dart';

class PatientSelectScreen extends StatefulWidget {
  final String mode;
  final BookingModel? bookingModel;

  const PatientSelectScreen({
    super.key,
    this.mode = 'history',
    this.bookingModel,
  });

  @override
  State<PatientSelectScreen> createState() => _PatientSelectScreenState();
}

class _PatientSelectScreenState extends State<PatientSelectScreen> {
  @override
  void initState() {
    super.initState();
    final profileState = context.read<UserProfileCubit>().state;
    if (profileState is UserProfileLoaded) {
      context.read<MedicalRecordCubit>().loadMedicalRecord(
        profileState.profile.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text(
          "Chọn hồ sơ khám bệnh",
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
      body: BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
        builder: (context, state) {
          if (state is MedicalRecordLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MedicalRecordEmpty) {
            return EmptyStateWidget(
              icon: Icons.person_off_rounded,
              title: "Chưa có hồ sơ y tế",
              subtitle: widget.mode == 'appointment'
                  ? "Vui lòng tạo hồ sơ y tế trước khi đặt lịch khám."
                  : "Vui lòng tạo hồ sơ để xem lịch sử khám bệnh.",
              onAction: () => context.push('/create-medical-record'),
              actionLabel: "Tạo hồ sơ ngay",
            );
          }

          if (state is MedicalRecordLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: state.patients.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final patient = state.patients[index];

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
                  onTap: () {
                    if (widget.mode == 'appointment') {
                      final baseModel =
                          widget.bookingModel ??
                          BookingModel(
                            patientId: patient.id,
                            patientName: patient.fullName,
                            patientAvatar: avatarUrl,
                          );

                      final updatedModel = baseModel.copyWith(
                        patientId: patient.id,
                        patientName: patient.fullName,
                        patientAvatar: avatarUrl,
                      );

                      if (updatedModel.branchId != null) {
                        context.pushNamed(
                          'book-appointment',
                          extra: updatedModel,
                        );
                      } else {
                        context.pushNamed('all-branch', extra: updatedModel);
                      }
                    } else {
                      context.push(
                        '/medical-history/${patient.id}',
                        extra: patient.fullName,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppShadow.cardShadow,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
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
                                  Icons.person_outline,
                                  color: AppColors.primary,
                                )
                              : null,
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
                                "Mã BN: ${patient.patientCode}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSlate.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (state is MedicalRecordError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
