import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/department.dart';
import 'package:e_health/domain/facility_service.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_cubit.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_state.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_cubit.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_state.dart';
import 'package:e_health/presentation/screens/speciality/cubit/specialty_booking_cubit.dart';
import 'package:e_health/presentation/screens/speciality/cubit/specialty_booking_state.dart';
import 'package:e_health/presentation/widgets/booking/booking_stepper.dart';
import 'package:e_health/presentation/widgets/booking/booking_patient_item.dart';
import 'package:e_health/presentation/widgets/booking/booking_service_item.dart';
import 'package:e_health/presentation/widgets/booking/booking_selection_card.dart';
import 'package:e_health/presentation/widgets/booking/booking_confirmation_ticket.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';

class SpecialtyBookingBottomSheet extends StatefulWidget {
  final Department department;
  final List<FacilityService> services;

  const SpecialtyBookingBottomSheet({
    super.key,
    required this.department,
    required this.services,
  });

  @override
  State<SpecialtyBookingBottomSheet> createState() =>
      _SpecialtyBookingBottomSheetState();
}

class _SpecialtyBookingBottomSheetState
    extends State<SpecialtyBookingBottomSheet> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      final profileState = context.read<UserProfileCubit>().state;
      if (profileState is UserProfileLoaded) {
        context.read<MedicalRecordCubit>().loadMedicalRecord(
          profileState.profile.id,
        );
      }

      // Initialize cubit state
      final cubit = context.read<SpecialtyBookingCubit>();
      if (widget.services.isNotEmpty) {
        cubit.selectService(widget.services.first);
      }
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  void _selectDate() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<SpecialtyBookingCubit>(),
        child: _CalendarSelectorSheet(
          facilityId: widget.department.facilityId ?? "",
          department: widget.department,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpecialtyBookingCubit, SpecialtyBookingState>(
      listener: (context, state) {
        if (state.status == SpecialtyBookingStatus.success) {
          AppToast.showSuccess(context, "Đặt lịch thành công!");
          Navigator.pop(context, true);
          if (state.preBookingResult != null) {
            context.push('/booking-payment-qr', extra: state.preBookingResult);
          }
        } else if (state.status == SpecialtyBookingStatus.failure && state.errorMessage != null) {
          AppToast.showError(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return BlocListener<MedicalRecordCubit, MedicalRecordState>(
          listener: (context, medicalState) {
            if (medicalState is MedicalRecordLoaded &&
                state.selectedPatient == null &&
                medicalState.patients.isNotEmpty) {
              context.read<SpecialtyBookingCubit>().selectPatient(medicalState.patients.first);
            }
          },
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.4,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
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
          ),
        );
      },
    );
  }

  Widget _buildHeader(SpecialtyBookingState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (state.currentStep != BookingStep.profile)
              Positioned(
                left: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () => context.read<SpecialtyBookingCubit>().prevStep(),
                ),
              ),
            const Text(
              "Đặt lịch theo chuyên khoa",
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
      case BookingStep.profile: return "Chọn người khám";
      case BookingStep.service: return "Chọn dịch vụ khám";
      case BookingStep.dateTime: return "Chọn thời gian";
      case BookingStep.slots: return "Chọn khung giờ";
      case BookingStep.notes: return "Thông tin triệu chứng";
      case BookingStep.confirm: return "Xác nhận đặt lịch";
    }
  }

  Widget _buildBody(SpecialtyBookingState state) {
    switch (state.currentStep) {
      case BookingStep.profile:
        return _buildProfileStep(state);
      case BookingStep.service:
        return _buildServiceStep(state);
      case BookingStep.dateTime:
        return _buildDateTimeStep(state);
      case BookingStep.slots:
        return _buildSlotsStep(state);
      case BookingStep.notes:
        return _buildNotesStep(state);
      case BookingStep.confirm:
        return _buildConfirmStep(state);
    }
  }

  Widget _buildProfileStep(SpecialtyBookingState state) {
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
                onTap: () => context.read<SpecialtyBookingCubit>().selectPatient(patient),
              );
            }).toList(),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildServiceStep(SpecialtyBookingState state) {
    if (widget.services.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.search_off_rounded,
        title: "Không tìm thấy dịch vụ",
        subtitle: "Khoa chưa có dịch vụ khám nào khả dụng.",
      );
    }
    return Column(
      children: widget.services.map((service) {
        return BookingServiceItem(
          serviceName: service.serviceName,
          basePrice: service.basePrice,
          isSelected: state.selectedService?.id == service.id,
          onTap: () => context.read<SpecialtyBookingCubit>().selectService(service),
        );
      }).toList(),
    );
  }

  Widget _buildDateTimeStep(SpecialtyBookingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Ngày khám"),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: state.selectedDate == null ? AppColors.textSlate : AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ngày khám",
                        style: TextStyle(fontSize: 12, color: AppColors.textSlate, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        state.selectedDate == null ? "Chọn ngày khám" : DateFormat("dd/MM/yyyy").format(state.selectedDate!),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: state.selectedDate == null ? FontWeight.normal : FontWeight.bold,
                          color: state.selectedDate == null ? Colors.grey[400] : AppColors.textHeader,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textSlate, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle("Ca khám"),
        const SizedBox(height: 12),
        if (state.isLoadingShifts)
          const Center(child: CircularProgressIndicator())
        else if (state.selectedDate == null)
          const Text("Vui lòng chọn ngày khám trước", style: TextStyle(color: AppColors.textSlate, fontStyle: FontStyle.italic))
        else if (state.availableShifts.isEmpty)
          const Text("Không có ca khám khả dụng", style: TextStyle(color: AppColors.textSlate))
        else
          ...state.availableShifts.map((shift) {
            final isSelected = state.selectedShift?.id == shift.id;
            return BookingSelectionCard(
              isSelected: isSelected,
              onTap: () => context.read<SpecialtyBookingCubit>().selectShift(shift),
              child: Row(
                children: [
                  const Icon(Icons.access_time_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shift.name,
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: isSelected ? AppColors.primary : AppColors.textHeader),
                        ),
                        Text(
                          "Giờ: ${shift.startTime} - ${shift.endTime}",
                          style: const TextStyle(fontSize: 12, color: AppColors.textSlate, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.check, color: Colors.white, size: 14),
                    ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildSlotsStep(SpecialtyBookingState state) {
    if (state.isLoadingSlots) {
      return const Center(child: Padding(padding: EdgeInsets.all(40.0), child: CircularProgressIndicator()));
    }
    if (state.slots.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.timer_off_rounded,
        title: "Hết giờ khám",
        subtitle: "Ca khám này hiện đã hết khung giờ khả dụng.",
      );
    }
    
    // Filter slots by selected shift
    final filteredSlots = state.slots.where((slot) => slot.shiftId == state.selectedShift?.id).toList();
    
    if (filteredSlots.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.timer_off_rounded,
        title: "Hết giờ khám",
        subtitle: "Ca khám này hiện đã hết khung giờ khả dụng.",
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Khung giờ khám cụ thể"),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: filteredSlots.length,
          itemBuilder: (context, index) {
            final slot = filteredSlots[index];
            final isSelected = state.selectedSlot?.id == slot.id;
            return GestureDetector(
              onTap: slot.isAvailable ? () => context.read<SpecialtyBookingCubit>().selectSlot(slot) : null,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : (slot.isAvailable ? AppColors.white : AppColors.grey100),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                ),
                child: Center(
                  child: Text(
                    slot.startTime.substring(0, 5),
                    style: TextStyle(
                      color: isSelected ? Colors.white : (slot.isAvailable ? AppColors.primary : AppColors.grey400),
                      fontWeight: FontWeight.bold,
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

  Widget _buildNotesStep(SpecialtyBookingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Lý do khám & Triệu chứng"),
        TextField(
          controller: _reasonController,
          onChanged: (v) => context.read<SpecialtyBookingCubit>().updateNotes(v, _symptomsController.text),
          decoration: InputDecoration(
            labelText: "Lý do khám",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.white,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _symptomsController,
          maxLines: 4,
          onChanged: (v) => context.read<SpecialtyBookingCubit>().updateNotes(_reasonController.text, v),
          decoration: InputDecoration(
            labelText: "Triệu chứng cụ thể",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmStep(SpecialtyBookingState state) {
    return Column(
      children: [
        BookingConfirmationTicket(
          patientName: state.selectedPatient?.fullName ?? "",
          serviceName: state.selectedService?.serviceName ?? "",
          date: state.selectedDate != null ? DateFormat("dd/MM/yyyy").format(state.selectedDate!) : "",
          time: state.selectedSlot != null ? state.selectedSlot!.startTime.substring(0, 5) : "",
          location: widget.department.branchName ?? "",
          price: state.selectedService?.basePrice ?? "0",
        ),
      ],
    );
  }

  Widget _buildFooter(SpecialtyBookingState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: state.status == SpecialtyBookingStatus.submitting
              ? null
              : () => context.read<SpecialtyBookingCubit>().nextStep(widget.department),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: state.status == SpecialtyBookingStatus.submitting
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(state.currentStep == BookingStep.confirm ? "Xác nhận đặt lịch" : "Tiếp tục",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textHeader),
      ),
    );
  }
}

class _CalendarSelectorSheet extends StatefulWidget {
  final String facilityId;
  final Department department;

  const _CalendarSelectorSheet({
    required this.facilityId,
    required this.department,
  });

  @override
  State<_CalendarSelectorSheet> createState() => _CalendarSelectorSheetState();
}

class _CalendarSelectorSheetState extends State<_CalendarSelectorSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: BlocBuilder<SpecialtyBookingCubit, SpecialtyBookingState>(
        builder: (context, state) {
          final cubit = context.read<SpecialtyBookingCubit>();
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          final focusedDay = DateTime(
            state.calendarYear != 0 ? state.calendarYear : now.year,
            state.calendarMonth != 0 ? state.calendarMonth : now.month,
            1,
          );

          return Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Chọn ngày khám",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textHeader),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TableCalendar(
                  locale: 'vi_VN',
                  firstDay: DateTime(now.year, now.month, 1),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: focusedDay,
                  currentDay: today,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  selectedDayPredicate: (day) {
                    return isSameDay(state.selectedDate, day);
                  },
                  enabledDayPredicate: (day) {
                    final normalizedDay = DateTime(day.year, day.month, day.day);
                    final isPast = normalizedDay.isBefore(today);
                    final isOpen = state.calendarAvailability[normalizedDay] ?? false;
                    return !isPast && isOpen;
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    cubit.selectDate(selectedDay, widget.department);
                    Navigator.pop(context);
                  },
                  onPageChanged: (focusedDay) {
                    cubit.loadCalendarData(
                      widget.facilityId,
                      month: focusedDay.month,
                      year: focusedDay.year,
                    );
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHeader,
                    ),
                    leftChevronIcon: const Icon(Icons.chevron_left_rounded, color: AppColors.textHeader),
                    rightChevronIcon: const Icon(Icons.chevron_right_rounded, color: AppColors.textHeader),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: AppColors.textSlate, fontWeight: FontWeight.bold),
                    weekendStyle: TextStyle(color: AppColors.textSlate, fontWeight: FontWeight.bold),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    defaultTextStyle: const TextStyle(color: AppColors.textHeader),
                    weekendTextStyle: const TextStyle(color: AppColors.textHeader),
                    outsideDaysVisible: false,
                    disabledTextStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final normalizedDay = DateTime(day.year, day.month, day.day);
                      final isOpen = state.calendarAvailability[normalizedDay] ?? false;
                      
                      if (isOpen) {
                        return Center(
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              "${day.day}",
                              style: const TextStyle(color: AppColors.textHeader),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
