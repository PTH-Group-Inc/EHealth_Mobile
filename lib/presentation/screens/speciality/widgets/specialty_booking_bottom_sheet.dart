import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_health/domain/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/department.dart';
import 'package:e_health/domain/facility_service.dart';
import 'package:e_health/domain/patient.dart';
import 'package:e_health/domain/shift.dart';
import 'package:e_health/domain/slot.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_cubit.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_state.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_cubit.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_state.dart';
import 'package:e_health/presentation/screens/speciality/cubit/specialty_detail_cubit.dart';
import 'package:e_health/presentation/screens/speciality/cubit/specialty_detail_state.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/app/dependency_injection/configure_injectable.dart';
import 'package:e_health/data/request/book_appointment_request.dart';

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

enum BookingStep { profile, service, dateTime, slots, notes, confirm }

class _SpecialtyBookingBottomSheetState
    extends State<SpecialtyBookingBottomSheet> {
  final _repository = getIt<Repository>();
  BookingStep _currentStep = BookingStep.profile;
  bool _isSubmitting = false;

  Patient? _selectedPatient;
  FacilityService? _selectedService;
  DateTime? _selectedDate;
  Shift? _selectedShift;
  Slot? _selectedSlot;

  bool _isLoadingShifts = false;
  List<Shift> _availableShifts = [];

  bool _isLoadingSlots = false;
  List<Slot> _slots = [];

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

    // Default service if available
    if (widget.services.isNotEmpty) {
      _selectedService = widget.services.first;
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == BookingStep.confirm) {
      _performFinalBooking();
      return;
    }

    setState(() {
      switch (_currentStep) {
        case BookingStep.profile:
          if (_selectedPatient == null) {
            AppToast.showInfo(context, "Vui lòng chọn hồ sơ bệnh nhân");
            return;
          }
          _currentStep = BookingStep.service;
          break;

        case BookingStep.service:
          if (_selectedService == null) {
            AppToast.showInfo(context, "Vui lòng chọn dịch vụ khám");
            return;
          }
          _currentStep = BookingStep.dateTime;
          break;

        case BookingStep.dateTime:
          if (_selectedDate == null || _selectedShift == null) {
            AppToast.showInfo(context, "Vui lòng chọn ngày và ca khám");
            return;
          }
          _loadSlots();
          _currentStep = BookingStep.slots;
          break;

        case BookingStep.slots:
          if (_selectedSlot == null) {
            AppToast.showInfo(context, "Vui lòng chọn khung giờ cụ thể");
            return;
          }
          _currentStep = BookingStep.notes;
          break;

        case BookingStep.notes:
          _currentStep = BookingStep.confirm;
          break;

        case BookingStep.confirm:
          break;
      }
    });
  }

  void _prevStep() {
    setState(() {
      switch (_currentStep) {
        case BookingStep.profile:
          Navigator.pop(context);
          break;
        case BookingStep.service:
          _currentStep = BookingStep.profile;
          break;
        case BookingStep.dateTime:
          _currentStep = BookingStep.service;
          break;
        case BookingStep.slots:
          _currentStep = BookingStep.dateTime;
          break;
        case BookingStep.notes:
          _currentStep = BookingStep.slots;
          break;
        case BookingStep.confirm:
          _currentStep = BookingStep.notes;
          break;
      }
    });
  }

  void _selectDate() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CalendarSelectorSheet(
        onDateSelected: (date) {
          setState(() {
            _selectedDate = date;
            _selectedShift = null; // Reset shift when date changes
            _selectedSlot = null;
          });
          _loadShifts();
        },
      ),
    );
  }

  Future<void> _loadShifts() async {
    setState(() => _isLoadingShifts = true);
    final result = await _repository.getShifts();
    if (!mounted) return;

    result.fold(
      (failure) {
        AppToast.showError(context, failure.message);
        setState(() => _isLoadingShifts = false);
      },
      (data) {
        setState(() {
          // Filter out evening shifts for general booking too
          _availableShifts = data.where((s) {
            final code = s.code.toUpperCase();
            return !code.contains("EVENING") &&
                !code.contains("TOI") &&
                !code.contains("TỐI");
          }).toList();
          _isLoadingShifts = false;
        });
      },
    );
  }

  Future<void> _loadSlots() async {
    if (_selectedDate == null || _selectedShift == null) return;
    setState(() {
      _isLoadingSlots = true;
      _slots = [];
    });

    final dateStr = DateFormat("yyyy-MM-dd").format(_selectedDate!);
    final result = await _repository.getAvailableSlots(
      date: dateStr,
      facilityId: widget.department.facilityId!,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        AppToast.showError(context, failure.message);
        setState(() => _isLoadingSlots = false);
      },
      (data) {
        setState(() {
          _slots = data
              .where((slot) => slot.shiftId == _selectedShift!.id)
              .toList();
          _isLoadingSlots = false;
        });
      },
    );
  }

  Future<void> _performFinalBooking() async {
    if (_isSubmitting) return;

    try {
      if (_selectedPatient == null ||
          _selectedDate == null ||
          _selectedShift == null ||
          _selectedSlot == null ||
          _selectedService == null) {
        AppToast.showError(context, "Vui lòng kiểm tra đầy đủ các thông tin");
        return;
      }

      setState(() => _isSubmitting = true);

      final dateStr = DateFormat("yyyy-MM-dd").format(_selectedDate!);
      final request = BookAppointmentRequest(
        patientId: _selectedPatient!.id,
        branchId: widget.department.branchId ?? "",
        shiftId: _selectedShift!.id,
        appointmentDate: dateStr,
        bookingChannel: "APP",
        reasonForVisit: _reasonController.text,
        symptomsNotes: _symptomsController.text,
        facilityServiceId: _selectedService!.id,
        slotId: _selectedSlot!.id,
      );

      final result = await _repository.bookAppointment(request);

      if (!mounted) return;

      result.fold(
        (failure) {
          AppToast.showError(context, failure.message);
          setState(() => _isSubmitting = false);
        },
        (booked) {
          AppToast.showSuccess(context, "Đặt lịch thành công!");
          Navigator.pop(context, true);
        },
      );
    } catch (e) {
      if (!mounted) return;
      AppToast.showError(context, "Lỗi khi gửi yêu cầu: ${e.toString()}");
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<MedicalRecordCubit, MedicalRecordState>(
      listener: (context, state) {
        if (state is MedicalRecordLoaded &&
            _selectedPatient == null &&
            state.patients.isNotEmpty) {
          setState(() {
            _selectedPatient = state.patients.first;
          });
        }
      },
      child: Container(
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
            _buildHeader(),
            _buildStepper(),
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
                  key: ValueKey(_currentStep),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: _buildBody(),
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Back button
            if (_currentStep != BookingStep.profile)
              Positioned(
                left: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: _prevStep,
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

  Widget _buildStepper() {
    final steps = BookingStep.values;
    final currentIndex = steps.indexOf(_currentStep);
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          Stack(
            children: [
              // Lines layer
              Positioned(
                left: 0,
                right: 0,
                top: 12, // Half of circle height (24/2)
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: (MediaQuery.of(context).size.width - 40) /
                        (steps.length * 2),
                  ),
                  child: Row(
                    children: List.generate(steps.length - 1, (index) {
                      final isCompleted = index < currentIndex;
                      return Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? AppColors.primary
                              : AppColors.grey200,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              // Circles layer
              Row(
                children: List.generate(steps.length, (index) {
                  final isCompleted = index < currentIndex;
                  final isCurrent = index == currentIndex;

                  return Expanded(
                    child: Center(
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isCompleted || isCurrent
                              ? AppColors.primary
                              : AppColors.grey200,
                          shape: BoxShape.circle,
                          border: isCurrent
                              ? Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 4,
                                )
                              : null,
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(Icons.check,
                                  size: 14, color: Colors.white)
                              : Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isCurrent
                                        ? Colors.white
                                        : AppColors.textSlate,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getStepTitle(_currentStep),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
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

  Widget _buildBody() {
    switch (_currentStep) {
      case BookingStep.profile:
        return _buildProfileStep();
      case BookingStep.service:
        return _buildServiceStep();
      case BookingStep.dateTime:
        return _buildDateTimeStep();
      case BookingStep.slots:
        return _buildSlotsStep();
      case BookingStep.notes:
        return _buildNotesStep();
      case BookingStep.confirm:
        return _buildConfirmStep();
    }
  }

  Widget _buildProfileStep() {
    return BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
      builder: (context, state) {
        if (state is MedicalRecordLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is MedicalRecordEmpty) {
          return EmptyStateWidget(
            icon: Icons.person_off_rounded,
            title: "Chưa có hồ sơ",
            subtitle: "Vui lòng tạo hồ sơ y tế trước khi đặt lịch.",
            onAction: () => context.push('/create-medical-record'),
            actionLabel: "Tạo hồ sơ",
          );
        }
        if (state is MedicalRecordLoaded) {
          return Column(
            children: state.patients.map((patient) {
              final isSelected = _selectedPatient?.id == patient.id;

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

              return _buildSelectionCard(
                isSelected: isSelected,
                onTap: () => setState(() => _selectedPatient = patient),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.1),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: 2,
                        ),
                        image: avatarUrl != null
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(avatarUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: avatarUrl == null
                          ? Icon(
                              Icons.person_rounded,
                              color: isSelected ? AppColors.primary : AppColors.grey400,
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
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              color: isSelected ? AppColors.primary : AppColors.textHeader,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Mã BN: ${patient.patientCode}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSlate,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildServiceStep() {
    if (widget.services.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.search_off_rounded,
        title: "Không tìm thấy dịch vụ",
        subtitle: "Khoa chưa có dịch vụ khám nào khả dụng.",
      );
    }
    return Column(
      children: widget.services.map((service) {
        final isSelected = _selectedService?.id == service.id;
        return _buildSelectionCard(
          isSelected: isSelected,
          onTap: () => setState(() => _selectedService = service),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.medical_services_outlined,
                  color: isSelected ? Colors.white : AppColors.primary,
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
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: isSelected ? AppColors.primary : AppColors.textHeader,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      NumberFormat.currency(
                        locale: 'vi_VN',
                        symbol: 'đ',
                      ).format(double.tryParse(service.basePrice) ?? 0),
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelected ? AppColors.primary : AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateTimeStep() {
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
                  color: _selectedDate == null
                      ? AppColors.textSlate
                      : AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ngày khám",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSlate,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _selectedDate == null
                            ? "Chọn ngày khám"
                            : DateFormat("dd/MM/yyyy").format(_selectedDate!),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: _selectedDate == null
                              ? FontWeight.normal
                              : FontWeight.bold,
                          color: _selectedDate == null
                              ? Colors.grey[400]
                              : AppColors.textHeader,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.textSlate,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle("Ca khám"),
        const SizedBox(height: 12),
        if (_isLoadingShifts)
          const Center(child: CircularProgressIndicator())
        else if (_selectedDate == null)
          const Text(
            "Vui lòng chọn ngày khám trước",
            style: TextStyle(
              color: AppColors.textSlate,
              fontStyle: FontStyle.italic,
            ),
          )
        else if (_availableShifts.isEmpty)
          const Text(
            "Không có ca khám khả dụng",
            style: TextStyle(color: AppColors.textSlate),
          )
        else
          ..._availableShifts.map((shift) {
            final isSelected = _selectedShift?.id == shift.id;
            return _buildSelectionCard(
              isSelected: isSelected,
              onTap: () => setState(() => _selectedShift = shift),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shift.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${shift.startTime} - ${shift.endTime}",
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
            );
          }),
      ],
    );
  }

  Widget _buildSlotsStep() {
    if (_isLoadingSlots) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_slots.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.timer_off_rounded,
        title: "Hết giờ khám",
        subtitle: "Ca khám này hiện đã hết khung giờ khả dụng.",
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Chọn khung giờ khám"),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: _slots.length,
          itemBuilder: (context, index) {
            final slot = _slots[index];
            final isSelected = _selectedSlot?.id == slot.id;
            final isAvailable = slot.isAvailable;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isAvailable
                      ? () => setState(() => _selectedSlot = slot)
                      : null,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : (isAvailable ? AppColors.white : AppColors.grey100),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isAvailable ? AppColors.border : AppColors.grey200),
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
                              : (isAvailable
                                    ? AppColors.primary
                                    : AppColors.grey400),
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

  Widget _buildNotesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Ghi chú (Tùy chọn)"),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _reasonController,
          label: "Lý do khám",
          hint: "Vd: Tái khám, kiểm tra định kỳ...",
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _symptomsController,
          label: "Triệu chứng",
          hint: "Mô tả cụ thể triệu chứng của bạn...",
        ),
      ],
    );
  }

  Widget _buildConfirmStep() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.confirmation_num_rounded, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    const Text(
                      "Chi tiết lịch khám",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "CHỜ XÁC NHẬN",
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildTicketRow(
                      "Bệnh nhân",
                      _selectedPatient?.fullName ?? "",
                      icon: Icons.person_rounded,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1, color: AppColors.grey100),
                    ),
                    _buildTicketRow(
                      "Dịch vụ",
                      _selectedService?.serviceName ?? "",
                      icon: Icons.medical_services_rounded,
                      valueColor: AppColors.primary,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1, color: AppColors.grey100),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTicketRow(
                            "Ngày",
                            _selectedDate != null
                                ? DateFormat("dd/MM/yyyy").format(_selectedDate!)
                                : "",
                            icon: Icons.calendar_today_rounded,
                          ),
                        ),
                        Container(width: 1, height: 30, color: AppColors.grey100, margin: const EdgeInsets.symmetric(horizontal: 16)),
                        Expanded(
                          child: _buildTicketRow(
                            "Giờ",
                            _selectedSlot != null
                                ? _selectedSlot!.startTime.substring(0, 5)
                                : "",
                            icon: Icons.access_time_rounded,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1, color: AppColors.grey100),
                    ),
                    _buildTicketRow(
                      "Địa điểm",
                      "${widget.department.branchName ?? ""}\n${widget.department.name ?? ""}",
                      icon: Icons.location_on_rounded,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                child: Center(
                  child: Text(
                    "Giá dịch vụ: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(double.tryParse(_selectedService?.basePrice ?? "0") ?? 0)}",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketRow(String label, String value, {required IconData icon, Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSlate),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.textSlate, fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: valueColor ?? AppColors.textHeader,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionCard({
    required bool isSelected,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected 
                ? AppColors.primary.withValues(alpha: 0.1) 
                : AppColors.shadow,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: AppColors.textHeader,
        ),
      ),
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textHeader,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textSlate, fontSize: 14),
            filled: true,
            fillColor: AppColors.grey50,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    bool canNext = false;
    switch (_currentStep) {
      case BookingStep.profile:
        canNext = _selectedPatient != null;
        break;
      case BookingStep.service:
        canNext = _selectedService != null;
        break;
      case BookingStep.dateTime:
        canNext = _selectedDate != null && _selectedShift != null;
        break;
      case BookingStep.slots:
        canNext = _selectedSlot != null;
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
              onPressed: (canNext && !_isSubmitting) ? _nextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
                disabledBackgroundColor: AppColors.grey200,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _currentStep == BookingStep.confirm
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

class _CalendarSelectorSheet extends StatelessWidget {
  final Function(DateTime) onDateSelected;

  const _CalendarSelectorSheet({required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: BlocBuilder<SpecialtyDetailCubit, SpecialtyDetailState>(
        builder: (context, state) {
          final cubit = context.read<SpecialtyDetailCubit>();
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          final month = state.calendarMonth;
          final year = state.calendarYear;

          final firstDayOfMonth = DateTime(year, month, 1);
          final daysInMonth = DateTime(year, month + 1, 0).day;
          final startingWeekdayIndex = firstDayOfMonth.weekday - 1; // Mon = 0

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      int newMonth = month - 1;
                      int newYear = year;
                      if (newMonth < 1) {
                        newMonth = 12;
                        newYear--;
                      }
                      cubit.loadCalendarData(month: newMonth, year: newYear);
                    },
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Text(
                    "Tháng $month, $year",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHeader,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      int newMonth = month + 1;
                      int newYear = year;
                      if (newMonth > 12) {
                        newMonth = 1;
                        newYear++;
                      }
                      cubit.loadCalendarData(month: newMonth, year: newYear);
                    },
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Day headers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
                    .map(
                      (d) => SizedBox(
                        width: 40,
                        child: Text(
                          d,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSlate,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              if (state.isLoadingCalendar)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    itemCount: startingWeekdayIndex + daysInMonth,
                    itemBuilder: (context, index) {
                      if (index < startingWeekdayIndex) {
                        return const SizedBox.shrink();
                      }

                      final dayNum = index - startingWeekdayIndex + 1;
                      final date = DateTime(year, month, dayNum);
                      final isPast = date.isBefore(today);
                      final isOpen = state.calendarAvailability[date] ?? false;
                      final isSelected =
                          state.appointmentDate != null &&
                          state.appointmentDate!.year == date.year &&
                          state.appointmentDate!.month == date.month &&
                          state.appointmentDate!.day == date.day;

                      final isEnable = !isPast && isOpen;

                      return GestureDetector(
                        onTap: isEnable
                            ? () {
                                onDateSelected(date);
                                Navigator.pop(context);
                              }
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : (isEnable
                                      ? AppColors.primary.withValues(
                                          alpha: 0.05,
                                        )
                                      : Colors.grey[100]),
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? null
                                : (isEnable
                                      ? Border.all(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.2,
                                          ),
                                        )
                                      : null),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "$dayNum",
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.white
                                  : (isEnable
                                        ? AppColors.textHeader
                                        : Colors.grey[400]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
