import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/doctor_detail.dart';
import 'package:e_health/domain/doctor_availability.dart';
import 'package:e_health/domain/patient.dart';
import 'package:e_health/domain/slot.dart';
import 'package:e_health/domain/doctor_service.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_cubit.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_state.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_cubit.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_state.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/app/dependency_injection/configure_injectable.dart';
import 'package:e_health/data/request/book_patient_appointment_request.dart';
import 'doctor_availability_selector.dart';

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

enum BookingStep { profile, facility, dateTime, slots, service, notes, confirm }

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  final _repository = getIt<Repository>();
  BookingStep _currentStep = BookingStep.profile;
  bool _isSubmitting = false;

  Patient? _selectedPatient;
  DoctorFacility? _selectedFacility;
  DateTime? _selectedDate;
  DoctorAvailability? _selectedShift;
  Slot? _selectedSlot;

  bool _isLoadingSlots = false;
  List<Slot> _slots = [];

  DoctorService? _selectedDoctorService;
  bool _isLoadingServices = false;
  List<DoctorService> _doctorServices = [];

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

    // Default patient if already loaded
    final medicalState = context.read<MedicalRecordCubit>().state;
    if (medicalState is MedicalRecordLoaded &&
        medicalState.patients.isNotEmpty) {
      _selectedPatient = medicalState.patients.first;
    }

    // Default facility if only one
    if (widget.doctor.facilities != null &&
        widget.doctor.facilities!.length == 1) {
      _selectedFacility = widget.doctor.facilities!.first;
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  void _nextStep() {
    debugPrint("Booking Flow Navigation: Next from $_currentStep");

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
          if ((widget.doctor.facilities?.length ?? 0) > 1) {
            _currentStep = BookingStep.facility;
          } else {
            _currentStep = BookingStep.dateTime;
          }
          break;

        case BookingStep.facility:
          if (_selectedFacility == null) {
            AppToast.showInfo(context, "Vui lòng chọn cơ sở khám");
            return;
          }
          _currentStep = BookingStep.dateTime;
          break;

        case BookingStep.dateTime:
          if (_selectedShift == null) {
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
          _loadDoctorServices();
          _currentStep = BookingStep.service;
          break;

        case BookingStep.service:
          if (_selectedDoctorService == null) {
            AppToast.showInfo(context, "Vui lòng chọn dịch vụ khám");
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

        case BookingStep.facility:
          _currentStep = BookingStep.profile;
          break;

        case BookingStep.dateTime:
          if ((widget.doctor.facilities?.length ?? 0) > 1) {
            _currentStep = BookingStep.facility;
          } else {
            _currentStep = BookingStep.profile;
          }
          break;

        case BookingStep.slots:
          _currentStep = BookingStep.dateTime;
          break;

        case BookingStep.service:
          _currentStep = BookingStep.slots;
          break;

        case BookingStep.notes:
          _currentStep = BookingStep.service;
          break;

        case BookingStep.confirm:
          _currentStep = BookingStep.notes;
          break;
      }
    });
  }

  Future<void> _loadSlots() async {
    if (_selectedShift == null ||
        _selectedDate == null ||
        _selectedFacility == null) {
      return;
    }
    setState(() {
      _isLoadingSlots = true;
      _slots = [];
    });

    final dateStr = DateFormat("yyyy-MM-dd").format(_selectedDate!);
    final result = await _repository.getAvailableSlots(
      date: dateStr,
      doctorId: widget.doctor.doctorsId ?? "",
      facilityId: _selectedFacility!.facilityId!,
    );


    if (!mounted) return;

    result.fold(
      (failure) {
        AppToast.showError(context, failure.message);
        setState(() => _isLoadingSlots = false);
      },
      (data) {
        setState(() {
          // Filter slots by shiftId to match the current selection
          _slots = data
              .where((slot) => slot.shiftId == _selectedShift!.shiftId)
              .toList();
          _isLoadingSlots = false;
        });
      },
    );
  }


  Future<void> _loadDoctorServices() async {
    if (widget.doctor.doctorsId == null) return;
    setState(() => _isLoadingServices = true);

    final result = await _repository.getDoctorServices(
      widget.doctor.doctorsId!,
    );
    if (!mounted) return;

    result.fold(
      (failure) {
        AppToast.showError(context, failure.message);
        setState(() => _isLoadingServices = false);
      },
      (data) {
        setState(() {
          _doctorServices = data;
          _isLoadingServices = false;
          if (data.isNotEmpty) {
            final primary =
                data.where((e) => e.isPrimary).firstOrNull ?? data.first;
            _selectedDoctorService = primary;
          }
        });
      },
    );
  }

  Future<void> _performFinalBooking() async {
    if (_isSubmitting) return;

    try {
      if (_selectedPatient == null ||
          _selectedShift == null ||
          _selectedDate == null ||
          _selectedSlot == null ||
          _selectedDoctorService == null) {
        AppToast.showError(context, "Vui lòng kiểm tra đầy đủ các thông tin");
        return;
      }

      setState(() => _isSubmitting = true);

      final request = BookPatientAppointmentRequest(
        patientId: _selectedPatient!.id,
        branchId: _selectedFacility!.branchId!,
        shiftId: _selectedShift!.shiftId,
        appointmentDate: DateFormat("yyyy-MM-dd").format(_selectedDate!),
        bookingChannel: "APP",
        reasonForVisit: _reasonController.text,
        doctorId: widget.doctor.doctorsId ?? "",
        slotId: _selectedSlot!.id,
        roomId: _selectedShift!.roomId,
        facilityServiceId: _selectedDoctorService!.facilityServiceId,
      );

      final result = await _repository.bookPatientAppointment(
        _selectedPatient!.id,
        request,
      );

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
      case BookingStep.facility:
        return _buildFacilityStep();
      case BookingStep.dateTime:
        return _buildDateTimeStep();
      case BookingStep.slots:
        return _buildSlotsStep();
      case BookingStep.service:
        return _buildServiceStep();
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
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => setState(() => _selectedPatient = patient),
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
                          child: const Icon(Icons.person_rounded, color: AppColors.primary),
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

  Widget _buildFacilityStep() {
    final facilities = widget.doctor.facilities ?? [];
    return Column(
      children: facilities.map((facility) {
        final isSelected =
            _selectedFacility?.userBranchDeptId == facility.userBranchDeptId;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => setState(() => _selectedFacility = facility),
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
                    const Icon(Icons.check_circle_rounded, color: AppColors.primary),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateTimeStep() {
    return DoctorAvailabilitySelector(
      availability: widget.availability,
      onSelected: (date, shift) {
        setState(() {
          _selectedDate = date;
          _selectedShift = shift;
        });
      },
    );
  }

  Widget _buildSlotsStep() {
    if (_isLoadingSlots) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
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
        const Text(
          "Khung giờ khám cụ thể",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
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
                      )
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

  Widget _buildServiceStep() {
    if (_isLoadingServices) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_doctorServices.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.search_off_rounded,
        title: "Không tìm thấy dịch vụ",
        subtitle: "Bác sĩ chưa có dịch vụ khám nào khả dụng.",
      );
    }

    return Column(
      children: _doctorServices.map((service) {
        final isSelected =
            _selectedDoctorService?.facilityServiceId ==
            service.facilityServiceId;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => setState(() => _selectedDoctorService = service),
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
                          service.serviceName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.textHeader,
                          ),
                        ),
                        Text(
                          "Mã: ${service.serviceCode}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSlate,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${NumberFormat.decimalPattern().format(double.tryParse(service.basePrice) ?? 0)} Đ",
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      if (service.isPrimary)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.info.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "Mặc định",
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.info,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (isSelected)
                    const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Icon(Icons.check_circle_rounded, color: AppColors.primary),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Lý do khám*",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _reasonController,
          decoration: InputDecoration(
            hintText: "Nhập lý do bạn đi khám (vd: Đau họng, sốt...)",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 20),
        const Text(
          "Triệu chứng chi tiết (Tùy chọn)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _symptomsController,
          decoration: InputDecoration(
            hintText: "Mô tả cụ thể hơn về tình trạng sức khỏe của bạn",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
          Icons.person,
          "Bệnh nhân",
          _selectedPatient?.fullName ?? "",
        ),
        _buildConfirmItem(
          Icons.location_on,
          "Cơ sở",
          _selectedFacility?.branchName ?? "",
        ),
        _buildConfirmItem(
          Icons.calendar_today,
          "Ngày khám",
          _selectedDate != null
              ? DateFormat("dd/MM/yyyy").format(_selectedDate!)
              : "",
        ),
        _buildConfirmItem(
          Icons.access_time,
          "Giờ khám",
          "${_selectedSlot?.startTime.substring(0, 5)} (${_selectedShift?.shiftName})",
        ),
        _buildConfirmItem(
          Icons.notes,
          "Dịch vụ",
          _selectedDoctorService?.serviceName ?? "",
        ),
        _buildConfirmItem(Icons.notes, "Lý do", _reasonController.text),
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
