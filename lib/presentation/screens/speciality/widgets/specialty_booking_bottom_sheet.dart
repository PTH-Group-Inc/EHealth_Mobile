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
            const Divider(height: 1, color: AppColors.border),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: KeyedSubtree(
                    key: ValueKey(_currentStep),
                    child: _buildBody(),
                  ),
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
    String title = "Đặt lịch khám";
    switch (_currentStep) {
      case BookingStep.profile:
        title = "Chọn người khám";
        break;
      case BookingStep.service:
        title = "Chọn dịch vụ khám";
        break;
      case BookingStep.dateTime:
        title = "Chọn thời gian";
        break;
      case BookingStep.slots:
        title = "Chọn khung giờ";
        break;
      case BookingStep.notes:
        title = "Thông tin bổ sung";
        break;
      case BookingStep.confirm:
        title = "Xác nhận đặt lịch";
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        children: [
          if (_currentStep != BookingStep.profile)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: _prevStep,
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
              return _buildSelectionCard(
                isSelected: isSelected,
                onTap: () => setState(() => _selectedPatient = patient),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.primary,
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.medical_services_outlined,
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
                      "${service.basePrice.replaceAll('.00', '')} VNĐ",
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
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
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _slots.map((slot) {
            final isSelected = _selectedSlot?.id == slot.id;
            final isAvailable = slot.isAvailable;
            return InkWell(
              onTap: isAvailable
                  ? () => setState(() => _selectedSlot = slot)
                  : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: (MediaQuery.of(context).size.width - 64) / 3,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isAvailable ? AppColors.white : AppColors.grey100),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isAvailable ? AppColors.border : AppColors.grey300),
                  ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
              _buildConfirmRow("Bệnh nhân", _selectedPatient?.fullName ?? ""),
              const Divider(height: 24),
              _buildConfirmRow("Dịch vụ", _selectedService?.serviceName ?? ""),
              const Divider(height: 24),
              _buildConfirmRow(
                "Ngày khám",
                DateFormat("dd/MM/yyyy").format(_selectedDate!),
              ),
              const Divider(height: 24),
              _buildConfirmRow(
                "Giờ khám",
                "${_selectedSlot!.startTime.substring(0, 5)} (${_selectedShift!.name})",
              ),
              const Divider(height: 24),
              _buildConfirmRow(
                "Địa điểm",
                "${widget.department.branchName} - ${widget.department.name}",
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
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
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
          ),
          child: child,
        ),
      ),
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

  Widget _buildConfirmRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textSlate, fontSize: 13),
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
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _currentStep == BookingStep.confirm
                          ? "Xác nhận đặt lịch"
                          : "Tiếp theo",
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                    .map((d) => SizedBox(
                          width: 40,
                          child: Text(
                            d,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSlate,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ))
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
                      final isSelected = state.appointmentDate != null &&
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
                                    ? AppColors.primary.withValues(alpha: 0.05)
                                    : Colors.grey[100]),
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? null
                                : (isEnable
                                    ? Border.all(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.2))
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
