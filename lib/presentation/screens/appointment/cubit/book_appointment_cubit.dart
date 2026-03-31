import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_health/app/dependency_injection/configure_injectable.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/data/request/book_appointment_request.dart';
import 'package:e_health/domain/shift.dart';
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

  Future<void> loadInitialData(String? facilityId) async {
    if (facilityId == null) {
      emit(state.copyWith(error: "Thiếu thông tin cơ sở khám"));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final results = await Future.wait([
        _repository.getShifts(),
        _repository.getFacilityServices(facilityId),
      ]);

      final shiftsResult = results[0];
      final servicesResult = results[1];

      shiftsResult.fold(
        (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
        (shiftsData) {
          final shifts = shiftsData as List<Shift>;
          servicesResult.fold(
            (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
            (servicesData) {
              final services = servicesData as List<FacilityService>;
              emit(state.copyWith(
                isLoading: false,
                shifts: shifts,
                services: services,
              ));
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
    final result = await _repository.getFacilityServices(facilityId, search: query);
    
    result.fold(
      (failure) => emit(state.copyWith(isSearchingServices: false)),
      (data) => emit(state.copyWith(isSearchingServices: false, services: data)),
    );
  }

  void selectShift(Shift shift) => emit(state.copyWith(selectedShift: shift, error: null));
  void selectService(FacilityService service) => emit(state.copyWith(selectedService: service, error: null));
  void selectDate(DateTime date) => emit(state.copyWith(appointmentDate: date, error: null));
  
  void updateForm(String reason, String notes) {
    emit(state.copyWith(reasonForVisit: reason, symptomsNotes: notes, error: null));
  }

  Future<void> submitAppointment({
    required String patientId,
    required String? branchId,
  }) async {
    if (branchId == null) {
      emit(state.copyWith(error: "Thiếu thông tin chi nhánh"));
      return;
    }

    if (state.selectedShift == null ||
        state.selectedService == null ||
        state.appointmentDate == null ||
        state.reasonForVisit.isEmpty) {
      emit(state.copyWith(error: "Vui lòng điền đầy đủ thông tin bắt buộc"));
      return;
    }

    emit(state.copyWith(isSubmitting: true, error: null));

    final String dateFormatted = DateFormat("yyyy-MM-dd").format(state.appointmentDate!);

    final request = BookAppointmentRequest(
      patientId: patientId,
      branchId: branchId,
      shiftId: state.selectedShift!.id,
      appointmentDate: dateFormatted,
      bookingChannel: "APP",
      reasonForVisit: state.reasonForVisit,
      symptomsNotes: state.symptomsNotes,
      facilityServiceId: state.selectedService!.id,
    );

    final result = await _repository.bookAppointment(request);

    result.fold(
      (failure) => emit(state.copyWith(isSubmitting: false, error: failure.message)),
      (data) => emit(state.copyWith(
        isSubmitting: false,
        isSubmitted: true,
        bookedAppointment: data,
      )),
    );
  }
}
