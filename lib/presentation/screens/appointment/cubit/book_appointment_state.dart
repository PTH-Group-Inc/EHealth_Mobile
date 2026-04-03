import 'package:e_health/domain/shift.dart';
import 'package:e_health/domain/slot.dart';
import 'package:e_health/domain/facility_service.dart';
import 'package:e_health/domain/booked_appointment.dart';
import 'package:equatable/equatable.dart';

class BookAppointmentState extends Equatable {
  final bool isLoading;
  final bool isLoadingSlots;
  final String? error;
  final List<Shift> shifts;
  final List<Slot> slots;
  final List<FacilityService> services;
  final Shift? selectedShift;
  final Slot? selectedSlot;
  final FacilityService? selectedService;
  final DateTime? appointmentDate;
  final String reasonForVisit;
  final String symptomsNotes;
  final bool isSubmitting;
  final bool isSubmitted;
  final BookedAppointment? bookedAppointment;
  final bool isSearchingServices;

  const BookAppointmentState({
    this.isLoading = false,
    this.isLoadingSlots = false,
    this.error,
    this.shifts = const [],
    this.slots = const [],
    this.services = const [],
    this.selectedShift,
    this.selectedSlot,
    this.selectedService,
    this.appointmentDate,
    this.reasonForVisit = "",
    this.symptomsNotes = "",
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.bookedAppointment,
    this.isSearchingServices = false,
  });

  BookAppointmentState copyWith({
    bool? isLoading,
    bool? isLoadingSlots,
    String? error,
    List<Shift>? shifts,
    List<Slot>? slots,
    List<FacilityService>? services,
    Shift? selectedShift,
    Slot? selectedSlot,
    FacilityService? selectedService,
    DateTime? appointmentDate,
    String? reasonForVisit,
    String? symptomsNotes,
    bool? isSubmitting,
    bool? isSubmitted,
    BookedAppointment? bookedAppointment,
    bool? isSearchingServices,
  }) {
    return BookAppointmentState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
      error: error ?? this.error,
      shifts: shifts ?? this.shifts,
      slots: slots ?? this.slots,
      services: services ?? this.services,
      selectedShift: selectedShift ?? this.selectedShift,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      selectedService: selectedService ?? this.selectedService,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      reasonForVisit: reasonForVisit ?? this.reasonForVisit,
      symptomsNotes: symptomsNotes ?? this.symptomsNotes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      bookedAppointment: bookedAppointment ?? this.bookedAppointment,
      isSearchingServices: isSearchingServices ?? this.isSearchingServices,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoadingSlots,
    error,
    shifts,
    slots,
    services,
    selectedShift,
    selectedSlot,
    selectedService,
    appointmentDate,
    reasonForVisit,
    symptomsNotes,
    isSubmitting,
    isSubmitted,
    bookedAppointment,
    isSearchingServices,
  ];
}
