import 'package:e_health/presentation/screens/doctor/cubit/doctor_booking_cubit.dart';
import 'package:e_health/presentation/screens/doctor/cubit/doctor_booking_state.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
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
import 'package:e_health/presentation/widgets/booking/booking_stepper.dart';
import 'package:e_health/presentation/widgets/booking/booking_patient_item.dart';
import 'package:e_health/presentation/widgets/booking/booking_service_item.dart';
import 'package:e_health/presentation/widgets/booking/booking_selection_card.dart';
import 'package:e_health/presentation/widgets/booking/booking_confirmation_ticket.dart';
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
        context.read<DoctorBookingCubit>().selectPatient(
          medicalState.patients.first,
        );
      }

      if (widget.doctor.facilities != null &&
          widget.doctor.facilities!.length == 1) {
        context.read<DoctorBookingCubit>().selectFacility(
          widget.doctor.facilities!.first,
        );
      }
    });

    _reasonController.addListener(() {
      context.read<DoctorBookingCubit>().updateNotes(
        _reasonController.text,
        _symptomsController.text,
      );
    });
    _symptomsController.addListener(() {
      context.read<DoctorBookingCubit>().updateNotes(
        _reasonController.text,
        _symptomsController.text,
      );
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
                context.read<DoctorBookingCubit>().state.selectedPatient ==
                    null &&
                state.patients.isNotEmpty) {
              context.read<DoctorBookingCubit>().selectPatient(
                state.patients.first,
              );
            }
          },
        ),
        BlocListener<DoctorBookingCubit, DoctorBookingState>(
          listenWhen: (prev, curr) =>
              prev.status != curr.status ||
              prev.errorMessage != curr.errorMessage,
          listener: (context, state) {
            if (state.errorMessage != null) {
              AppToast.showError(context, state.errorMessage!);
            }
            if (state.status == DoctorBookingStatus.success) {
              AppToast.showSuccess(context, "Đặt lịch thành công!");
              Navigator.pop(context, true);
              if (state.preBookingResult != null) {
                context.push(
                  '/booking-payment-qr',
                  extra: state.preBookingResult,
                );
              }
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: Offset(0, -5),
                ),
              ],
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
                BookingStepper(
                  totalSteps: BookingStep.values.length,
                  currentIndex: BookingStep.values.indexOf(state.currentStep),
                  stepTitle: _getStepTitle(state.currentStep),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutQuart,
                    switchOutCurve: Curves.easeInQuart,
                    transitionBuilder: (child, animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0.05, 0.0),
                        end: Offset.zero,
                      ).animate(animation);
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: SingleChildScrollView(
                      key: ValueKey(state.currentStep),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: _buildBody(state),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Back button
            if (state.currentStep != BookingStep.profile)
              Positioned(
                left: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () => context.read<DoctorBookingCubit>().prevStep(
                    widget.doctor,
                  ),
                ),
              ),
            const Text(
              "Đặt lịch khám",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textHeader,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _getStepTitle(BookingStep step) {
    switch (step) {
      case BookingStep.profile:
        return "Chọn người khám";
      case BookingStep.facility:
        return "Chọn cơ sở khám";
      case BookingStep.dateTime:
        return "Chọn thời gian";
      case BookingStep.slots:
        return "Chọn khung giờ";
      case BookingStep.service:
        return "Chọn dịch vụ khám";
      case BookingStep.notes:
        return "Thông tin triệu chứng";
      case BookingStep.confirm:
        return "Xác nhận đặt lịch";
    }
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
              return BookingPatientItem(
                patient: patient,
                isSelected: state.selectedPatient?.id == patient.id,
                onTap: () =>
                    context.read<DoctorBookingCubit>().selectPatient(patient),
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
        return BookingSelectionCard(
          isSelected:
              state.selectedFacility?.userBranchDeptId ==
              facility.userBranchDeptId,
          onTap: () =>
              context.read<DoctorBookingCubit>().selectFacility(facility),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      (state.selectedFacility?.userBranchDeptId ==
                          facility.userBranchDeptId)
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color:
                      (state.selectedFacility?.userBranchDeptId ==
                          facility.userBranchDeptId)
                      ? Colors.white
                      : AppColors.primary,
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
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color:
                            (state.selectedFacility?.userBranchDeptId ==
                                facility.userBranchDeptId)
                            ? AppColors.primary
                            : AppColors.textHeader,
                      ),
                    ),
                    if (facility.departmentName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          facility.departmentName!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSlate,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (state.selectedFacility?.userBranchDeptId ==
                  facility.userBranchDeptId)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 14),
                ),
            ],
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
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            "Khung giờ khám cụ thể",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: AppColors.textHeader,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: state.slots.length,
          itemBuilder: (context, index) {
            final slot = state.slots[index];
            final isSelected = state.selectedSlot?.id == slot.id;
            final isAvailable = slot.isAvailable;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isAvailable
                      ? () =>
                            context.read<DoctorBookingCubit>().selectSlot(slot)
                      : null,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : isAvailable
                          ? AppColors.white
                          : AppColors.grey100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : isAvailable
                            ? AppColors.border
                            : AppColors.grey200,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        else if (isAvailable)
                          const BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 8,
                            offset: Offset(0, 4),
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
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
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
        return BookingServiceItem(
          serviceName: service.serviceName,
          basePrice: service.basePrice,
          isSelected:
              state.selectedDoctorService?.facilityServiceId ==
              service.facilityServiceId,
          onTap: () =>
              context.read<DoctorBookingCubit>().selectService(service),
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
    return Column(
      children: [
        BookingConfirmationTicket(
          patientName: state.selectedPatient?.fullName ?? "",
          serviceName: state.selectedDoctorService?.serviceName ?? "",
          date: state.selectedDate != null
              ? DateFormat("dd/MM/yyyy").format(state.selectedDate!)
              : "",
          time: state.selectedSlot != null
              ? state.selectedSlot!.startTime.substring(0, 5)
              : "",
          location: "${state.selectedFacility?.branchName ?? ""}\n${state.selectedFacility?.departmentName ?? ""}",
          price: state.selectedDoctorService?.basePrice ?? "0",
        ),
      ],
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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed:
                  (canNext && state.status != DoctorBookingStatus.submitting)
                  ? () => context.read<DoctorBookingCubit>().nextStep(
                      widget.doctor,
                    )
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
                disabledBackgroundColor: AppColors.grey200,
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
    );
  }
}
