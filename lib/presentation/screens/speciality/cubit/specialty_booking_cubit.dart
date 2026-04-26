import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/data/request/pre_booking_request.dart';
import 'package:e_health/domain/patient.dart';
import 'package:e_health/domain/facility_service.dart';
import 'package:e_health/domain/shift.dart';
import 'package:e_health/domain/slot.dart';
import 'package:e_health/domain/department.dart';
import 'package:e_health/presentation/screens/speciality/cubit/specialty_booking_state.dart';

@injectable
class SpecialtyBookingCubit extends Cubit<SpecialtyBookingState> {
  final Repository _repository;

  SpecialtyBookingCubit(this._repository) : super(const SpecialtyBookingState());

  void selectPatient(Patient patient) {
    emit(state.copyWith(selectedPatient: patient));
  }

  void selectService(FacilityService service) {
    emit(state.copyWith(selectedService: service));
  }

  Future<void> selectDate(DateTime date, Department department) async {
    emit(state.copyWith(
      selectedDate: date,
      selectedShift: null,
      selectedSlot: null,
      clearError: true,
    ));
    await loadShifts();
    await loadSlots(department);
  }

  void selectShift(Shift shift) {
    emit(state.copyWith(selectedShift: shift, selectedSlot: null));
    // Filter slots for the selected shift
    if (state.slots.isNotEmpty) {
       // We already loaded all slots for the day, so we just filter them in the UI or here.
       // The UI uses state.slots, but it should probably filter by shiftId.
    }
  }

  void selectSlot(Slot slot) {
    emit(state.copyWith(selectedSlot: slot));
  }

  void updateNotes(String reason, String symptoms) {
    emit(state.copyWith(reason: reason, symptoms: symptoms));
  }

  Future<void> loadCalendarData(String facilityId, {int? month, int? year}) async {
    final currentMonth = month ?? (state.calendarMonth != 0 ? state.calendarMonth : DateTime.now().month);
    final currentYear = year ?? (state.calendarYear != 0 ? state.calendarYear : DateTime.now().year);

    emit(state.copyWith(
      isLoadingCalendar: true,
      calendarMonth: currentMonth,
      calendarYear: currentYear,
    ));

    final result = await _repository.getFacilityCalendar(
      facilityId: facilityId,
      month: currentMonth,
      year: currentYear,
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoadingCalendar: false, errorMessage: failure.message)),
      (data) {
        final availabilityMap = {
          for (var item in data)
            DateTime(item.date.year, item.date.month, item.date.day): item.isOpen,
        };
        emit(state.copyWith(
          isLoadingCalendar: false,
          calendarAvailability: availabilityMap,
        ));
      },
    );
  }

  void nextStep(Department department) {
    switch (state.currentStep) {
      case BookingStep.profile:
        if (state.selectedPatient == null) return;
        emit(state.copyWith(currentStep: BookingStep.service, clearError: true));
        break;
      case BookingStep.service:
        if (state.selectedService == null) return;
        // Initialize calendar data when entering date selection
        loadCalendarData(department.facilityId ?? "");
        emit(state.copyWith(currentStep: BookingStep.dateTime, clearError: true));
        break;
      case BookingStep.dateTime:
        if (state.selectedDate == null) return;
        if (state.selectedShift == null) return;
        emit(state.copyWith(currentStep: BookingStep.slots, clearError: true));
        break;
      case BookingStep.slots:
        if (state.selectedSlot == null) return;
        emit(state.copyWith(currentStep: BookingStep.notes, clearError: true));
        break;
      case BookingStep.notes:
        emit(state.copyWith(currentStep: BookingStep.confirm, clearError: true));
        break;
      case BookingStep.confirm:
        submitBooking(department);
        break;
    }
  }

  void prevStep() {
    switch (state.currentStep) {
      case BookingStep.profile:
        break;
      case BookingStep.service:
        emit(state.copyWith(currentStep: BookingStep.profile, clearError: true));
        break;
      case BookingStep.dateTime:
        emit(state.copyWith(currentStep: BookingStep.service, clearError: true));
        break;
      case BookingStep.slots:
        emit(state.copyWith(currentStep: BookingStep.dateTime, clearError: true));
        break;
      case BookingStep.notes:
        emit(state.copyWith(currentStep: BookingStep.slots, clearError: true));
        break;
      case BookingStep.confirm:
        emit(state.copyWith(currentStep: BookingStep.notes, clearError: true));
        break;
    }
  }

  Future<void> loadShifts() async {
    emit(state.copyWith(isLoadingShifts: true, availableShifts: []));
    final result = await _repository.getShifts();
    
    result.fold(
      (failure) => emit(state.copyWith(isLoadingShifts: false, errorMessage: failure.message)),
      (data) {
        final filteredShifts = data.where((s) {
          final code = s.code.toUpperCase();
          return !code.contains("EVENING") &&
              !code.contains("TOI") &&
              !code.contains("TỐI");
        }).toList();
        emit(state.copyWith(isLoadingShifts: false, availableShifts: filteredShifts));
      },
    );
  }

  Future<void> loadSlots(Department department) async {
    if (state.selectedDate == null) return;
    
    emit(state.copyWith(isLoadingSlots: true, slots: []));
    
    final dateStr = DateFormat("yyyy-MM-dd").format(state.selectedDate!);
    final result = await _repository.getAvailableSlots(
      date: dateStr,
      facilityId: department.facilityId ?? "",
    );
    
    result.fold(
      (failure) => emit(state.copyWith(isLoadingSlots: false, errorMessage: failure.message)),
      (data) {
        // Store all slots for the day
        emit(state.copyWith(isLoadingSlots: false, slots: data));
      },
    );
  }

  Future<void> submitBooking(Department department) async {
    if (state.status == SpecialtyBookingStatus.submitting) return;

    if (state.selectedPatient == null ||
        state.selectedDate == null ||
        state.selectedShift == null ||
        state.selectedSlot == null ||
        state.selectedService == null) {
      emit(state.copyWith(errorMessage: "Vui lòng kiểm tra đầy đủ các thông tin"));
      return;
    }

    emit(state.copyWith(status: SpecialtyBookingStatus.submitting, clearError: true));

    final request = PreBookingRequest(
      patientId: state.selectedPatient!.id,
      branchId: department.branchId ?? "",
      shiftId: state.selectedShift!.id,
      appointmentDate: DateFormat("yyyy-MM-dd").format(state.selectedDate!),
      bookingChannel: "APP",
      notes: state.reason.isNotEmpty ? "${state.reason} - ${state.symptoms}" : state.symptoms,
      facilityServiceId: state.selectedService!.id,
      slotId: state.selectedSlot!.id,
      doctorId: null,
    );

    final result = await _repository.preBookAppointment(request);

    result.fold(
      (failure) => emit(state.copyWith(status: SpecialtyBookingStatus.failure, errorMessage: failure.message)),
      (data) => emit(state.copyWith(status: SpecialtyBookingStatus.success, preBookingResult: data)),
    );
  }
}
