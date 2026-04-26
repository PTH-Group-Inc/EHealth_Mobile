import 'package:equatable/equatable.dart';
import 'package:e_health/domain/patient.dart';
import 'package:e_health/domain/facility_service.dart';
import 'package:e_health/domain/shift.dart';
import 'package:e_health/domain/slot.dart';

enum SpecialtyBookingStatus { initial, loading, submitting, success, failure }

enum BookingStep { profile, service, dateTime, slots, notes, confirm }

class SpecialtyBookingState extends Equatable {
  final BookingStep currentStep;
  final Patient? selectedPatient;
  final FacilityService? selectedService;
  final DateTime? selectedDate;
  final Shift? selectedShift;
  final Slot? selectedSlot;
  final String reason;
  final String symptoms;
  final bool isLoadingShifts;
  final List<Shift> availableShifts;
  final bool isLoadingSlots;
  final List<Slot> slots;
  final Map<DateTime, bool> calendarAvailability;
  final int calendarMonth;
  final int calendarYear;
  final bool isLoadingCalendar;
  final dynamic preBookingResult;
  final String? errorMessage;
  final SpecialtyBookingStatus status;

  const SpecialtyBookingState({
    this.currentStep = BookingStep.profile,
    this.selectedPatient,
    this.selectedService,
    this.selectedDate,
    this.selectedShift,
    this.selectedSlot,
    this.reason = '',
    this.symptoms = '',
    this.isLoadingShifts = false,
    this.availableShifts = const [],
    this.isLoadingSlots = false,
    this.slots = const [],
    this.calendarAvailability = const {},
    this.calendarMonth = 0,
    this.calendarYear = 0,
    this.isLoadingCalendar = false,
    this.preBookingResult,
    this.errorMessage,
    this.status = SpecialtyBookingStatus.initial,
  });

  SpecialtyBookingState copyWith({
    BookingStep? currentStep,
    Patient? selectedPatient,
    FacilityService? selectedService,
    DateTime? selectedDate,
    Shift? selectedShift,
    Slot? selectedSlot,
    String? reason,
    String? symptoms,
    bool? isLoadingShifts,
    List<Shift>? availableShifts,
    bool? isLoadingSlots,
    List<Slot>? slots,
    Map<DateTime, bool>? calendarAvailability,
    int? calendarMonth,
    int? calendarYear,
    bool? isLoadingCalendar,
    dynamic preBookingResult,
    String? errorMessage,
    bool clearError = false,
    SpecialtyBookingStatus? status,
  }) {
    return SpecialtyBookingState(
      currentStep: currentStep ?? this.currentStep,
      selectedPatient: selectedPatient ?? this.selectedPatient,
      selectedService: selectedService ?? this.selectedService,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedShift: selectedShift ?? this.selectedShift,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      reason: reason ?? this.reason,
      symptoms: symptoms ?? this.symptoms,
      isLoadingShifts: isLoadingShifts ?? this.isLoadingShifts,
      availableShifts: availableShifts ?? this.availableShifts,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
      slots: slots ?? this.slots,
      calendarAvailability: calendarAvailability ?? this.calendarAvailability,
      calendarMonth: calendarMonth ?? this.calendarMonth,
      calendarYear: calendarYear ?? this.calendarYear,
      isLoadingCalendar: isLoadingCalendar ?? this.isLoadingCalendar,
      preBookingResult: preBookingResult ?? this.preBookingResult,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        selectedPatient,
        selectedService,
        selectedDate,
        selectedShift,
        selectedSlot,
        reason,
        symptoms,
        isLoadingShifts,
        availableShifts,
        isLoadingSlots,
        slots,
        calendarAvailability,
        calendarMonth,
        calendarYear,
        isLoadingCalendar,
        preBookingResult,
        errorMessage,
        status,
      ];
}
