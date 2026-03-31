import 'package:e_health/domain/shift.dart';
import 'package:e_health/domain/facility_service.dart';
import 'package:e_health/domain/booked_appointment.dart';

class BookAppointmentState {
  final List<Shift> shifts;
  final List<FacilityService> services;
  final Shift? selectedShift;
  final FacilityService? selectedService;
  final DateTime? appointmentDate;
  final String reasonForVisit;
  final String symptomsNotes;
  
  final bool isLoading;
  final bool isSearchingServices;
  final bool isSubmitting;
  final bool isSubmitted;
  
  final BookedAppointment? bookedAppointment;
  final String? error;

  BookAppointmentState({
    this.shifts = const [],
    this.services = const [],
    this.selectedShift,
    this.selectedService,
    this.appointmentDate,
    this.reasonForVisit = '',
    this.symptomsNotes = '',
    this.isLoading = false,
    this.isSearchingServices = false,
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.bookedAppointment,
    this.error,
  });

  BookAppointmentState copyWith({
    List<Shift>? shifts,
    List<FacilityService>? services,
    Shift? selectedShift,
    FacilityService? selectedService,
    DateTime? appointmentDate,
    String? reasonForVisit,
    String? symptomsNotes,
    bool? isLoading,
    bool? isSearchingServices,
    bool? isSubmitting,
    bool? isSubmitted,
    BookedAppointment? bookedAppointment,
    String? error,
  }) {
    return BookAppointmentState(
      shifts: shifts ?? this.shifts,
      services: services ?? this.services,
      selectedShift: selectedShift ?? this.selectedShift,
      selectedService: selectedService ?? this.selectedService,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      reasonForVisit: reasonForVisit ?? this.reasonForVisit,
      symptomsNotes: symptomsNotes ?? this.symptomsNotes,
      isLoading: isLoading ?? this.isLoading,
      isSearchingServices: isSearchingServices ?? this.isSearchingServices,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      bookedAppointment: bookedAppointment ?? this.bookedAppointment,
      error: error,
    );
  }
}
