import 'package:e_health/domain/shift.dart';
import 'package:e_health/domain/slot.dart';
import 'package:e_health/domain/facility_service.dart';
import 'package:e_health/domain/booked_appointment.dart';
import 'package:e_health/domain/pre_booking.dart';
import 'package:equatable/equatable.dart';

class BookAppointmentState extends Equatable {
  final bool isLoading;
  final bool isLoadingSlots;
  final bool isLoadingDateSlots;
  final bool isLoadingCalendar;
  final String? error;
  final List<Shift> shifts;
  final List<Slot> slots;
  final List<Slot> availableDateSlots;
  final List<FacilityService> services;
  final Map<DateTime, bool> calendarAvailability;
  final Shift? selectedShift;
  final Slot? selectedSlot;
  final FacilityService? selectedService;
  final DateTime? appointmentDate;
  final String reasonForVisit;
  final String symptomsNotes;
  final bool isSubmitting;
  final bool isSubmitted;
  final PreBookingEntity? preBookingResult;
  final bool isSearchingServices;
  final String? facilityId;
  final int servicePage;
  final int calendarMonth;
  final int calendarYear;
  final bool hasReachedMaxServices;
  final bool isFetchingMoreServices;
  final String? lastServiceQuery;

  const BookAppointmentState({
    this.isLoading = false,
    this.isLoadingSlots = false,
    this.isLoadingDateSlots = false,
    this.isLoadingCalendar = false,
    this.error,
    this.shifts = const [],
    this.slots = const [],
    this.availableDateSlots = const [],
    this.services = const [],
    this.calendarAvailability = const {},
    this.selectedShift,
    this.selectedSlot,
    this.selectedService,
    this.appointmentDate,
    this.reasonForVisit = "",
    this.symptomsNotes = "",
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.preBookingResult,
    this.isSearchingServices = false,
    this.facilityId,
    this.servicePage = 1,
    this.calendarMonth = 0,
    this.calendarYear = 0,
    this.hasReachedMaxServices = false,
    this.isFetchingMoreServices = false,
    this.lastServiceQuery,
  });

  BookAppointmentState copyWith({
    bool? isLoading,
    bool? isLoadingSlots,
    bool? isLoadingDateSlots,
    bool? isLoadingCalendar,
    String? error,
    List<Shift>? shifts,
    List<Slot>? slots,
    List<Slot>? availableDateSlots,
    List<FacilityService>? services,
    Map<DateTime, bool>? calendarAvailability,
    Shift? selectedShift,
    Slot? selectedSlot,
    FacilityService? selectedService,
    DateTime? appointmentDate,
    String? reasonForVisit,
    String? symptomsNotes,
    bool? isSubmitting,
    bool? isSubmitted,
    PreBookingEntity? preBookingResult,
    bool? isSearchingServices,
    String? facilityId,
    int? servicePage,
    int? calendarMonth,
    int? calendarYear,
    bool? hasReachedMaxServices,
    bool? isFetchingMoreServices,
    String? lastServiceQuery,
    bool clearServiceQuery = false,
    bool clearDate = false,
    bool clearShift = false,
    bool clearSlot = false,
  }) {
    return BookAppointmentState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
      isLoadingDateSlots: isLoadingDateSlots ?? this.isLoadingDateSlots,
      isLoadingCalendar: isLoadingCalendar ?? this.isLoadingCalendar,
      error: error ?? this.error,
      shifts: shifts ?? this.shifts,
      slots: clearShift ? const [] : (slots ?? this.slots),
      availableDateSlots:
          clearDate ? const [] : (availableDateSlots ?? this.availableDateSlots),
      services: services ?? this.services,
      calendarAvailability: calendarAvailability ?? this.calendarAvailability,
      selectedShift: clearShift ? null : (selectedShift ?? this.selectedShift),
      selectedSlot: clearSlot ? null : (selectedSlot ?? this.selectedSlot),
      selectedService: selectedService ?? this.selectedService,
      appointmentDate:
          clearDate ? null : (appointmentDate ?? this.appointmentDate),
      reasonForVisit: reasonForVisit ?? this.reasonForVisit,
      symptomsNotes: symptomsNotes ?? this.symptomsNotes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      preBookingResult: preBookingResult ?? this.preBookingResult,
      isSearchingServices: isSearchingServices ?? this.isSearchingServices,
      facilityId: facilityId ?? this.facilityId,
      servicePage: servicePage ?? this.servicePage,
      calendarMonth: calendarMonth ?? this.calendarMonth,
      calendarYear: calendarYear ?? this.calendarYear,
      hasReachedMaxServices:
          hasReachedMaxServices ?? this.hasReachedMaxServices,
      isFetchingMoreServices:
          isFetchingMoreServices ?? this.isFetchingMoreServices,
      lastServiceQuery: clearServiceQuery
          ? null
          : (lastServiceQuery ?? this.lastServiceQuery),
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isLoadingSlots,
        isLoadingDateSlots,
        isLoadingCalendar,
        error,
        shifts,
        slots,
        availableDateSlots,
        services,
        calendarAvailability,
        selectedShift,
        selectedSlot,
        selectedService,
        appointmentDate,
        reasonForVisit,
        symptomsNotes,
        isSubmitting,
        isSubmitted,
        preBookingResult,
        isSearchingServices,
        facilityId,
        servicePage,
        calendarMonth,
        calendarYear,
        hasReachedMaxServices,
        isFetchingMoreServices,
        lastServiceQuery,
      ];
}
