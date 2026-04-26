import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/data/request/pre_booking_request.dart';
import 'package:e_health/presentation/screens/doctor/cubit/doctor_booking_state.dart';
import 'package:e_health/domain/doctor_detail.dart';
import 'package:e_health/domain/patient.dart';
import 'package:e_health/domain/doctor_availability.dart';
import 'package:e_health/domain/slot.dart';
import 'package:e_health/domain/doctor_service.dart';

@injectable
class DoctorBookingCubit extends Cubit<DoctorBookingState> {
  final Repository _repository;

  DoctorBookingCubit(this._repository) : super(const DoctorBookingState());

  void selectPatient(Patient patient) {
    emit(state.copyWith(selectedPatient: patient));
  }

  void selectFacility(DoctorFacility facility) {
    emit(state.copyWith(selectedFacility: facility));
  }

  void selectDateTime(DateTime date, DoctorAvailability shift) {
    emit(state.copyWith(selectedDate: date, selectedShift: shift));
  }

  void selectSlot(Slot slot) {
    emit(state.copyWith(selectedSlot: slot));
  }

  void selectService(DoctorService service) {
    emit(state.copyWith(selectedDoctorService: service));
  }

  void updateNotes(String reason, String symptoms) {
    emit(state.copyWith(reason: reason, symptoms: symptoms));
  }

  void nextStep(DoctorDetail doctor) {
    switch (state.currentStep) {
      case BookingStep.profile:
        if (state.selectedPatient == null) return;
        if ((doctor.facilities?.length ?? 0) > 1) {
          emit(
            state.copyWith(currentStep: BookingStep.facility, clearError: true),
          );
        } else {
          emit(
            state.copyWith(currentStep: BookingStep.dateTime, clearError: true),
          );
        }
        break;
      case BookingStep.facility:
        if (state.selectedFacility == null) return;
        emit(
          state.copyWith(currentStep: BookingStep.dateTime, clearError: true),
        );
        break;
      case BookingStep.dateTime:
        if (state.selectedShift == null) return;
        loadSlots(doctor);
        emit(state.copyWith(currentStep: BookingStep.slots, clearError: true));
        break;
      case BookingStep.slots:
        if (state.selectedSlot == null) return;
        loadDoctorServices(doctor);
        emit(
          state.copyWith(currentStep: BookingStep.service, clearError: true),
        );
        break;
      case BookingStep.service:
        if (state.selectedDoctorService == null) return;
        emit(state.copyWith(currentStep: BookingStep.notes, clearError: true));
        break;
      case BookingStep.notes:
        emit(
          state.copyWith(currentStep: BookingStep.confirm, clearError: true),
        );
        break;
      case BookingStep.confirm:
        submitBooking(doctor);
        break;
    }
  }

  void prevStep(DoctorDetail doctor) {
    switch (state.currentStep) {
      case BookingStep.profile:
        break;
      case BookingStep.facility:
        emit(
          state.copyWith(currentStep: BookingStep.profile, clearError: true),
        );
        break;
      case BookingStep.dateTime:
        if ((doctor.facilities?.length ?? 0) > 1) {
          emit(
            state.copyWith(currentStep: BookingStep.facility, clearError: true),
          );
        } else {
          emit(
            state.copyWith(currentStep: BookingStep.profile, clearError: true),
          );
        }
        break;
      case BookingStep.slots:
        emit(
          state.copyWith(currentStep: BookingStep.dateTime, clearError: true),
        );
        break;
      case BookingStep.service:
        emit(state.copyWith(currentStep: BookingStep.slots, clearError: true));
        break;
      case BookingStep.notes:
        emit(
          state.copyWith(currentStep: BookingStep.service, clearError: true),
        );
        break;
      case BookingStep.confirm:
        emit(state.copyWith(currentStep: BookingStep.notes, clearError: true));
        break;
    }
  }

  Future<void> loadSlots(DoctorDetail doctor) async {
    if (state.selectedShift == null ||
        state.selectedDate == null ||
        state.selectedFacility == null) {
      return;
    }

    emit(state.copyWith(isLoadingSlots: true, slots: []));

    final dateStr = DateFormat("yyyy-MM-dd").format(state.selectedDate!);
    final result = await _repository.getAvailableSlots(
      date: dateStr,
      doctorId: doctor.doctorsId ?? "",
      facilityId: state.selectedFacility!.facilityId!,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingSlots: false, errorMessage: failure.message),
      ),
      (data) {
        final filteredSlots = data
            .where((slot) => slot.shiftId == state.selectedShift!.shiftId)
            .toList();
        emit(state.copyWith(isLoadingSlots: false, slots: filteredSlots));
      },
    );
  }

  Future<void> loadDoctorServices(DoctorDetail doctor) async {
    if (doctor.doctorsId == null) return;
    emit(state.copyWith(isLoadingServices: true));

    final result = await _repository.getDoctorServices(doctor.doctorsId!);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingServices: false, errorMessage: failure.message),
      ),
      (data) {
        final primary =
            data.where((e) => e.isPrimary == true).firstOrNull ??
            data.firstOrNull;
        emit(
          state.copyWith(
            isLoadingServices: false,
            doctorServices: data,
            selectedDoctorService: primary,
          ),
        );
      },
    );
  }

  Future<void> submitBooking(DoctorDetail doctor) async {
    if (state.status == DoctorBookingStatus.submitting) return;

    if (state.selectedPatient == null ||
        state.selectedShift == null ||
        state.selectedDate == null ||
        state.selectedSlot == null ||
        state.selectedDoctorService == null) {
      emit(
        state.copyWith(errorMessage: "Vui lòng kiểm tra đầy đủ các thông tin"),
      );
      return;
    }

    final request = PreBookingRequest(
      patientId: state.selectedPatient!.id,
      branchId: state.selectedFacility!.branchId!,
      shiftId: state.selectedShift!.shiftId,
      appointmentDate: DateFormat("yyyy-MM-dd").format(state.selectedDate!),
      bookingChannel: "APP",
      notes: state.reason.isNotEmpty
          ? "${state.reason} - ${state.symptoms}"
          : state.symptoms,
      doctorId: doctor.doctorsId ?? "",
      slotId: state.selectedSlot!.id,
      facilityServiceId: state.selectedDoctorService!.facilityServiceId,
    );

    final result = await _repository.preBookAppointment(request);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DoctorBookingStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: DoctorBookingStatus.success,
          preBookingResult: data,
        ),
      ),
    );
  }
}
