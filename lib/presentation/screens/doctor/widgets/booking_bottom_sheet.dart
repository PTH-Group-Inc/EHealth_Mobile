import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_health/domain/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/doctor_detail.dart';
import 'package:e_health/domain/doctor_availability.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_cubit.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_state.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_cubit.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_state.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:e_health/presentation/screens/doctor/cubit/doctor_booking_cubit.dart';
import 'package:e_health/presentation/screens/doctor/cubit/doctor_booking_state.dart';
import 'package:e_health/presentation/screens/doctor/widgets/doctor_availability_selector.dart';

class BookingBottomSheet extends StatefulWidget {
  final DoctorDetail doctor;
  final Map<String, List<DoctorAvailability>> availability;

  const BookingBottomSheet({
    super.key,
    required this.doctor,
    required this.availability,
  });

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profileState = context.read<UserProfileCubit>().state;
    if (profileState is UserProfileLoaded) {
      context.read<MedicalRecordCubit>().loadMedicalRecord(
        profileState.profile.id,
      );
    }

    // Initialize cubit with default values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final medicalState = context.read<MedicalRecordCubit>().state;
      if (medicalState is MedicalRecordLoaded &&
          medicalState.patients.isNotEmpty) {
        context.read<DoctorBookingCubit>().selectPatient(medicalState.patients.first);
      }

      if (widget.doctor.facilities != null &&
          widget.doctor.facilities!.length == 1) {
        context.read<DoctorBookingCubit>().selectFacility(widget.doctor.facilities!.first);
      }
    });

    _reasonController.addListener(() {
      context.read<DoctorBookingCubit>().updateNotes(_reasonController.text, _symptomsController.text);
    });
    _symptomsController.addListener(() {
      context.read<DoctorBookingCubit>().updateNotes(_reasonController.text, _symptomsController.text);
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return MultiBlocListener(
      listeners: [
        BlocListener<MedicalRecordCubit, MedicalRecordState>(
          listener: (context, state) {
            if (state is MedicalRecordLoaded &&
                context.read<DoctorBookingCubit>().state.selectedPatient == null &&
                state.patients.isNotEmpty) {
              context.read<DoctorBookingCubit>().selectPatient(state.patients.first);
            }
          },
        ),
        BlocListener<DoctorBookingCubit, DoctorBookingState>(
          listenWhen: (prev, curr) => prev.status != curr.status || prev.errorMessage != curr.errorMessage,
          listener: (context, state) {
            if (state.errorMessage != null) {
              AppToast.showError(context, state.errorMessage!);
            }
            if (state.status == DoctorBookingStatus.submitted) {
              AppToast.showSuccess(context, "Đặt lịch thành công!");
              Navigator.pop(context, true);
            }
          },
        ),
      ],
      child: BlocBuilder<DoctorBookingCubit, DoctorBookingState>(
        builder: (context, state) {
          return Container(
            constraints: BoxConstraints(
              minHeight: screenHeight * 0.4,
              maxHeight: screenHeight * 0.9,
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                _buildHeader(state),
                const Divider(height: 1, color: AppColors.border),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      alignment: Alignment.topCenter,
                      child: KeyedSubtree(
                        key: ValueKey(state.currentStep),
                        child: _buildBody(state),
                      ),
                    ),
                  ),
                ),
                _buildFooter(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(DoctorBookingState state) {
    String title = "Đặt lịch khám";
    switch (state.currentStep) {
      case BookingStep.profile:
        title = "Chọn người khám";
        break;
      case BookingStep.facility:
        title = "Chọn cơ sở khám";
        break;
      case BookingStep.dateTime:
        title = "Chọn thời gian";
        break;
      case BookingStep.slots:
        title = "Chọn khung giờ";
        break;
      case BookingStep.service:
        title = "Chọn dịch vụ khám";
        break;
      case BookingStep.notes:
        title = "Thông tin triệu chứng";
        break;
      case BookingStep.confirm:
        title = "Xác nhận đặt lịch";
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        children: [
          if (state.currentStep != BookingStep.profile)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => context.read<DoctorBookingCubit>().prevStep(widget.doctor),
            )
          else
            const SizedBox(width: 48),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textHeader,
                letterSpacing: -0.5,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(DoctorBookingState state) {
    switch (state.currentStep) {
      case BookingStep.profile:
        return _buildProfileStep(state);
      case BookingStep.facility:
        return _buildFacilityStep(state);
      case BookingStep.dateTime:
        return _buildDateTimeStep(state);
      case BookingStep.slots:
        return _buildSlotsStep(state);
      case BookingStep.service:
        return _buildServiceStep(state);
      case BookingStep.notes:
        return _buildNotesStep(state);
      case BookingStep.confirm:
        return _buildConfirmStep(state);
    }
  }

  Widget _buildProfileStep(DoctorBookingState state) {
    return BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
      builder: (context, medicalState) {
        if (medicalState is MedicalRecordLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (medicalState is MedicalRecordEmpty) {
          return EmptyStateWidget(
            icon: Icons.person_off_rounded,
            title: "Chưa có hồ sơ",
            subtitle: "Vui lòng tạo hồ sơ y tế trước khi đặt lịch.",
            onAction: () => context.push('/create-medical-record'),
            actionLabel: "Tạo hồ sơ",
          );
        }
        if (medicalState is MedicalRecordLoaded) {
          return Column(
            children: medicalState.patients.map((patient) {
              final isSelected = state.selectedPatient?.id == patient.id;

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

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => context.read<DoctorBookingCubit>().selectPatient(patient),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.05)
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.1),
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
                                  Icons.person_rounded,
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.textHeader,
                                ),
                              ),
                              Text(
                                "Mã BN: ${patient.patientCode}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSlate,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildFacilityStep(DoctorBookingState state) {
    final facilities = widget.doctor.facilities ?? [];
    return Column(
      children: facilities.map((facility) {
        final isSelected =
            state.selectedFacility?.userBranchDeptId == facility.userBranchDeptId;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => context.read<DoctorBookingCubit>().selectFacility(facility),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.05)
                    : AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          facility.branchName ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.textHeader,
                          ),
                        ),
                        if (facility.departmentName != null)
                          Text(
                            facility.departmentName!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSlate,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateTimeStep(DoctorBookingState state) {
    return DoctorAvailabilitySelector(
      availability: widget.availability,
      onSelected: (date, shift) {
        context.read<DoctorBookingCubit>().selectDateTime(date, shift);
      },
    );
  }

  Widget _buildSlotsStep(DoctorBookingState state) {
    if (state.isLoadingSlots) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (state.slots.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.timer_off_rounded,
        title: "Hết giờ khám",
        subtitle: "Ca khám này hiện đã hết khung giờ khả dụng.",
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Khung giờ khám cụ thể",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: state.slots.map((slot) {
            final isSelected = state.selectedSlot?.id == slot.id;
            final isAvailable = slot.isAvailable;

            return InkWell(
              onTap: isAvailable
                  ? () => context.read<DoctorBookingCubit>().selectSlot(slot)
                  : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: (MediaQuery.of(context).size.width - 64) / 3,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : isAvailable
                      ? AppColors.white
                      : AppColors.grey100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : isAvailable
                        ? AppColors.border
                        : AppColors.grey300,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Center(
                  child: Text(
                    slot.startTime.substring(0, 5),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : isAvailable
                          ? AppColors.primary
                          : AppColors.grey400,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildServiceStep(DoctorBookingState state) {
    if (state.isLoadingServices) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.doctorServices.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.search_off_rounded,
        title: "Không tìm thấy dịch vụ",
        subtitle: "Bác sĩ chưa có dịch vụ khám nào khả dụng.",
      );
    }

    return Column(
      children: state.doctorServices.map((service) {
        final isSelected =
            state.selectedDoctorService?.facilityServiceId ==
            service.facilityServiceId;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => context.read<DoctorBookingCubit>().selectService(service),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.05)
                    : AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.medical_services_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.serviceName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.textHeader,
                          ),
                        ),
                        Text(
                          NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                              .format(double.tryParse(service.basePrice) ?? 0),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotesStep(DoctorBookingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Lý do khám & Triệu chứng",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _reasonController,
          decoration: InputDecoration(
            labelText: "Lý do khám",
            hintText: "Ví dụ: Khám định kỳ, Đau đầu...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.white,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _symptomsController,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: "Triệu chứng cụ thể",
            hintText: "Mô tả các triệu chứng bạn đang gặp phải...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmStep(DoctorBookingState state) {
    // Get latest avatar for selected patient
    String? avatarUrl;
    if (state.selectedPatient != null) {
      final avatars = List<Avatar>.from(state.selectedPatient!.avatarUrl);
      avatars.sort((Avatar a, Avatar b) {
        final dateA = a.uploadedAt ?? DateTime(0);
        final dateB = b.uploadedAt ?? DateTime(0);
        return dateB.compareTo(dateA);
      });
      avatarUrl = avatars.isNotEmpty ? avatars.first.url : null;
    }

    return Column(
      children: [
        _buildSectionTitle("Tổng quan lịch khám"),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildConfirmRow(
                "Bệnh nhân",
                state.selectedPatient?.fullName ?? "",
                imageUrl: avatarUrl,
              ),
              const Divider(height: 24),
              _buildConfirmRow(
                "Dịch vụ",
                state.selectedDoctorService?.serviceName ?? "",
              ),
              const Divider(height: 24),
              _buildConfirmRow(
                "Ngày khám",
                state.selectedDate != null
                    ? DateFormat("dd/MM/yyyy").format(state.selectedDate!)
                    : "",
              ),
              const Divider(height: 24),
              _buildConfirmRow(
                "Giờ khám",
                state.selectedSlot != null
                    ? "${state.selectedSlot!.startTime.substring(0, 5)} (${state.selectedShift?.shiftName ?? ""})"
                    : "",
              ),
              const Divider(height: 24),
              _buildConfirmRow(
                "Địa điểm",
                "${state.selectedFacility?.branchName ?? ""} - ${state.selectedFacility?.departmentName ?? ""}",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmRow(String label, String value, {String? imageUrl}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textSlate, fontSize: 13),
          ),
        ),
        const SizedBox(width: 12),
        if (imageUrl != null)
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textHeader,
      ),
    );
  }

  Widget _buildFooter(DoctorBookingState state) {
    bool canNext = false;
    switch (state.currentStep) {
      case BookingStep.profile:
        canNext = state.selectedPatient != null;
        break;
      case BookingStep.facility:
        canNext = state.selectedFacility != null;
        break;
      case BookingStep.dateTime:
        canNext = state.selectedShift != null;
        break;
      case BookingStep.slots:
        canNext = state.selectedSlot != null;
        break;
      case BookingStep.service:
        canNext = state.selectedDoctorService != null;
        break;
      case BookingStep.notes:
        canNext = true;
        break;
      case BookingStep.confirm:
        canNext = true;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.errorMessage != null)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: (canNext &&
                          state.status != DoctorBookingStatus.submitting)
                      ? () => context
                          .read<DoctorBookingCubit>()
                          .nextStep(widget.doctor)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: state.status == DoctorBookingStatus.submitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          state.currentStep == BookingStep.confirm
                              ? "Xác nhận đặt lịch"
                              : "Tiếp tục",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
