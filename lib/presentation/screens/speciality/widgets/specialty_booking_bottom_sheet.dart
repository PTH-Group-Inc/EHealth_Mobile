import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/department.dart';
import 'package:e_health/domain/specialty.dart';
import 'package:e_health/domain/specialty_service.dart';
import 'package:e_health/domain/patient.dart';
import 'package:e_health/domain/shift.dart';
import 'package:e_health/domain/slot.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_cubit.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_state.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_cubit.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_state.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/app/dependency_injection/configure_injectable.dart';
import 'package:e_health/data/request/book_appointment_request.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';

class SpecialtyBookingBottomSheet extends StatefulWidget {
  final Department department;
  final Specialty specialty;
  final List<SpecialtyService> initialServices;

  const SpecialtyBookingBottomSheet({
    super.key,
    required this.department,
    required this.specialty,
    required this.initialServices,
  });

  @override
  State<SpecialtyBookingBottomSheet> createState() => _SpecialtyBookingBottomSheetState();
}

enum BookingStep { profile, service, dateTime, slots, notes, confirm }

class _SpecialtyBookingBottomSheetState extends State<SpecialtyBookingBottomSheet> {
  final _repository = getIt<Repository>();
  BookingStep _currentStep = BookingStep.profile;
  bool _isSubmitting = false;

  Patient? _selectedPatient;
  SpecialtyService? _selectedService;
  DateTime? _selectedDate;
  Shift? _selectedShift;
  Slot? _selectedSlot;

  bool _isLoadingShifts = false;
  List<Shift> _shifts = [];
  
  bool _isLoadingSlots = false;
  List<Slot> _slots = [];

  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedService = widget.initialServices.isNotEmpty ? widget.initialServices.first : null;
    
    // Load patient profile
    final profileState = context.read<UserProfileCubit>().state;
    if (profileState is UserProfileLoaded) {
      context.read<MedicalRecordCubit>().loadMedicalRecord(profileState.profile.id);
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
          _loadShifts();
          _currentStep = BookingStep.dateTime;
          break;

        case BookingStep.dateTime:
          if (_selectedShift == null || _selectedDate == null) {
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
          if (_reasonController.text.trim().isEmpty) {
            AppToast.showInfo(context, "Vui lòng nhập lý do khám");
            return;
          }
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

  Future<void> _loadShifts() async {
    setState(() {
      _isLoadingShifts = true;
      _shifts = [];
    });
    final result = await _repository.getShifts();
    if (!mounted) return;
    result.fold(
      (failure) {
        AppToast.showError(context, failure.message);
        setState(() => _isLoadingShifts = false);
      },
      (data) {
        setState(() {
          _shifts = data;
          _isLoadingShifts = false;
        });
      },
    );
  }

  Future<void> _loadSlots() async {
    if (_selectedShift == null) return;
    setState(() {
      _isLoadingSlots = true;
      _slots = [];
    });
    final result = await _repository.getSlots(_selectedShift!.id);
    if (!mounted) return;
    result.fold(
      (failure) {
        AppToast.showError(context, failure.message);
        setState(() => _isLoadingSlots = false);
      },
      (data) {
        setState(() {
          _slots = data;
          _isLoadingSlots = false;
        });
      },
    );
  }

  Future<void> _performFinalBooking() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final request = BookAppointmentRequest(
      patientId: _selectedPatient!.id,
      branchId: widget.department.branchId ?? "",
      shiftId: _selectedShift!.id,
      appointmentDate: DateFormat("yyyy-MM-dd").format(_selectedDate!),
      bookingChannel: "APP",
      reasonForVisit: _reasonController.text,
      symptomsNotes: _symptomsController.text,
      facilityServiceId: _selectedService!.facilityServiceId,
      slotId: _selectedSlot!.id,
    );

    final result = await _repository.bookAppointment(request);
    if (!mounted) return;

    result.fold(
      (failure) {
        AppToast.showError(context, failure.message);
        setState(() => _isSubmitting = false);
      },
      (success) {
        AppToast.showSuccess(context, "Đặt lịch thành công!");
        Navigator.pop(context, true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      constraints: BoxConstraints(
        minHeight: screenHeight * 0.4,
        maxHeight: screenHeight * 0.9,
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
              child: _buildBody(),
            ),
          ),
          _buildFooter(),
        ],
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
        title = "Chọn ngày & ca khám";
        break;
      case BookingStep.slots:
        title = "Chọn khung giờ";
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
        if (state is MedicalRecordLoading) return const AppLoadingWidget();
        if (state is MedicalRecordEmpty) {
          return EmptyStateWidget(
            icon: Icons.person_off_rounded,
            title: "Chưa có hồ sơ",
            subtitle: "Vui lòng tạo hồ sơ bệnh nhân.",
            onAction: () => Navigator.pop(context),
          );
        }
        if (state is MedicalRecordLoaded) {
          return Column(
            children: state.patients.map((p) {
              final isSelected = _selectedPatient?.id == p.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => setState(() => _selectedPatient = p),
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
                          )
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primaryLight,
                          child: Icon(
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
                                p.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.textHeader,
                                ),
                              ),
                              Text(
                                "Mã BN: ${p.patientCode}",
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

  Widget _buildServiceStep() {
    if (widget.initialServices.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.medical_services_outlined,
        title: "Chưa có dịch vụ",
        subtitle: "Khoa này hiện chưa được cập nhật các gói dịch vụ khám.",
      );
    }
    return Column(
      children: widget.initialServices.map((s) {
        final isSelected = _selectedService != null &&
            _selectedService!.facilityServiceId.isNotEmpty &&
            _selectedService!.facilityServiceId == s.facilityServiceId;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => setState(() => _selectedService = s),
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
                    )
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
                          s.serviceName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.textHeader,
                          ),
                        ),
                        Text(
                          "Chuyên khoa: ${widget.specialty.name}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSlate,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${NumberFormat.decimalPattern().format(double.tryParse(s.basePrice) ?? 0)} Đ",
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  if (isSelected)
                    const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateTimeStep() {
    if (_isLoadingShifts) return const AppLoadingWidget();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Chọn ngày khám",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textHeader,
          ),
        ),
        const SizedBox(height: 8),
        Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: CalendarDatePicker(
            initialDate: _selectedDate ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 30)),
            onDateChanged: (date) => setState(() => _selectedDate = date),
          ),
        ),
        const Divider(height: 32),
        const Text(
          "Chọn ca khám",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textHeader,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _shifts.where((s) => !s.name.contains("Tối")).map((s) {
            final isSelected = _selectedShift?.id == s.id;
            return InkWell(
              onTap: () => setState(() => _selectedShift = s),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  s.name,
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.textHeader,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSlotsStep() {
    if (_isLoadingSlots) return const AppLoadingWidget();
    if (_slots.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.timer_off_rounded,
        title: "Hết khung giờ",
        subtitle: "Ca khám này hiện không còn khung giờ trống.",
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Chọn khung giờ cụ thể",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textHeader,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _slots.map((s) {
            final isSelected = _selectedSlot?.id == s.id;
            return InkWell(
              onTap: () => setState(() => _selectedSlot = s),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: (MediaQuery.of(context).size.width - 64) / 3,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                  ],
                ),
                child: Center(
                  child: Text(
                    s.startTime.substring(0, 5),
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildNotesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Lý do khám*",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textHeader),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _reasonController,
          decoration: InputDecoration(
            hintText: "Mô tả ngắn gọn lý do (vd: Đau đầu, sốt...)",
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 20),
        const Text(
          "Triệu chứng chi tiết (không bắt buộc)",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textHeader),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _symptomsController,
          decoration: InputDecoration(
            hintText: "Nhập các biểu hiện bất thường (nếu có)",
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildConfirmStep() {
    return Column(
      children: [
        _buildConfirmItem(
          Icons.person_outline_rounded,
          "Bệnh nhân",
          _selectedPatient?.fullName ?? "",
        ),
        _buildConfirmItem(
          Icons.domain_rounded,
          "Chuyên khoa",
          widget.specialty.name ?? "",
        ),
        _buildConfirmItem(
          Icons.medical_services_outlined,
          "Dịch vụ",
          _selectedService?.serviceName ?? "",
        ),
        _buildConfirmItem(
          Icons.calendar_today_rounded,
          "Ngày khám",
          _selectedDate != null
              ? DateFormat("dd/MM/yyyy").format(_selectedDate!)
              : "",
        ),
        _buildConfirmItem(
          Icons.access_time_rounded,
          "Thời gian",
          "${_selectedSlot?.startTime.substring(0, 5)} (${_selectedShift?.name})",
        ),
        _buildConfirmItem(
          Icons.description_outlined,
          "Lý do khám",
          _reasonController.text,
        ),
      ],
    );
  }

  Widget _buildConfirmItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSlate,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeader,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
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
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
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

