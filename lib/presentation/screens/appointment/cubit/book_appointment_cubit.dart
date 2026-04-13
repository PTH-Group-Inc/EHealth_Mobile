import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_health/app/dependency_injection/configure_injectable.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/data/request/book_appointment_request.dart';
import 'package:e_health/domain/shift.dart';
import 'package:e_health/domain/slot.dart';
import 'package:e_health/domain/facility_service.dart';
import 'book_appointment_state.dart';
import 'package:intl/intl.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  static final _repository = getIt<Repository>();

  BookAppointmentCubit() : super(BookAppointmentState());

  void reset() {
    emit(BookAppointmentState());
  }

  Future<void> loadInitialData(
    String? facilityId, {
    String? departmentId,
  }) async {
    if (facilityId == null) {
      emit(state.copyWith(error: "Thiếu thông tin cơ sở khám"));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null, facilityId: facilityId));

    try {
      final results = await Future.wait([
        _repository.getShifts(),
        _repository.getFacilityServices(facilityId, departmentId: departmentId),
      ]);

      final shiftsResult = results[0];
      final servicesResult = results[1];

      shiftsResult.fold(
        (failure) =>
            emit(state.copyWith(isLoading: false, error: failure.message)),
        (shiftsData) {
          final allShifts = shiftsData as List<Shift>;
          // Lọc chỉ lấy ca Sáng và Chiều (bỏ ca Tối)
          final filteredShifts = allShifts.where((s) {
            final code = s.code.toUpperCase();
            return !code.contains("EVENING") &&
                !code.contains("TOI") &&
                !code.contains("TỐI");
          }).toList();

          servicesResult.fold(
            (failure) =>
                emit(state.copyWith(isLoading: false, error: failure.message)),
            (servicesData) {
              final services = servicesData as List<FacilityService>;
              emit(
                state.copyWith(
                  isLoading: false,
                  shifts: filteredShifts,
                  services: services,
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> searchServices(String? facilityId, String query) async {
    if (facilityId == null) return;

    emit(state.copyWith(isSearchingServices: true));
    final result = await _repository.getFacilityServices(
      facilityId,
      search: query,
    );

    result.fold(
      (failure) => emit(state.copyWith(isSearchingServices: false)),
      (data) =>
          emit(state.copyWith(isSearchingServices: false, services: data)),
    );
  }

  void selectShift(Shift shift) {
    emit(
      state.copyWith(
        selectedShift: shift,
        selectedSlot: null,
        slots: [],
        error: null,
      ),
    );
    loadSlots(shift.id);
  }

  Future<void> loadSlots(String shiftId) async {
    if (state.facilityId == null || state.appointmentDate == null) {
      emit(state.copyWith(error: "Vui lòng chọn ngày khám trước"));
      return;
    }

    emit(state.copyWith(isLoadingSlots: true, error: null));

    final String dateFormatted = DateFormat(
      "yyyy-MM-dd",
    ).format(state.appointmentDate!);

    final result = await _repository.getAvailableSlots(
      date: dateFormatted,
      facilityId: state.facilityId!,
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingSlots: false, error: failure.message)),
      (data) {
        // Lọc slot theo shiftId đã chọn
        final filteredSlots = data
            .where((slot) => slot.shiftId == shiftId)
            .toList();
        emit(state.copyWith(isLoadingSlots: false, slots: filteredSlots));
      },
    );
  }

  void selectSlot(Slot slot) =>
      emit(state.copyWith(selectedSlot: slot, error: null));

  void selectService(FacilityService service) =>
      emit(state.copyWith(selectedService: service, error: null));
  void selectDate(DateTime date) =>
      emit(state.copyWith(appointmentDate: date, error: null));

  void updateForm(String reason, String notes) {
    emit(
      state.copyWith(reasonForVisit: reason, symptomsNotes: notes, error: null),
    );
  }

  Future<void> submitAppointment({
    required String patientId,
    required String? branchId,
    required String slotId,
  }) async {
    if (branchId == null) {
      emit(state.copyWith(error: "Thiếu thông tin chi nhánh"));
      return;
    }

    if (state.selectedShift == null ||
        state.selectedSlot == null ||
        state.selectedService == null ||
        state.appointmentDate == null) {
      emit(state.copyWith(error: "Vui lòng điền đầy đủ thông tin bắt buộc"));
      return;
    }

    emit(state.copyWith(isSubmitting: true, error: null));

    final String dateFormatted = DateFormat(
      "yyyy-MM-dd",
    ).format(state.appointmentDate!);

    final request = BookAppointmentRequest(
      patientId: patientId,
      branchId: branchId,
      shiftId: state.selectedShift!.id,
      appointmentDate: dateFormatted,
      bookingChannel: "APP",
      reasonForVisit: state.reasonForVisit,
      symptomsNotes: state.symptomsNotes,
      facilityServiceId: state.selectedService!.id,
      slotId: slotId,
    );

    final result = await _repository.bookAppointment(request);

    result.fold(
      (failure) =>
          emit(state.copyWith(isSubmitting: false, error: failure.message)),
      (data) => emit(
        state.copyWith(
          isSubmitting: false,
          isSubmitted: true,
          bookedAppointment: data,
        ),
      ),
    );
  }
}
