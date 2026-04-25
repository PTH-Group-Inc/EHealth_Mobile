import 'package:e_health/domain/doctor_detail.dart';
import 'package:e_health/domain/doctor_availability.dart';
import 'package:e_health/domain/patient.dart';
import 'package:e_health/domain/slot.dart';
import 'package:e_health/domain/doctor_service.dart';

enum BookingStep { profile, facility, dateTime, slots, service, notes, confirm }

enum DoctorBookingStatus { initial, loading, success, failure, submitting, submitted }

class DoctorBookingState {
  final BookingStep currentStep;
  final DoctorBookingStatus status;
  final String? errorMessage;
  
  final Patient? selectedPatient;
  final DoctorFacility? selectedFacility;
  final DateTime? selectedDate;
  final DoctorAvailability? selectedShift;
  final Slot? selectedSlot;
  final DoctorService? selectedDoctorService;
  
  final List<Slot> slots;
  final bool isLoadingSlots;
  
  final List<DoctorService> doctorServices;
  final bool isLoadingServices;
  
  final String reason;
  final String symptoms;

  const DoctorBookingState({
    this.currentStep = BookingStep.profile,
    this.status = DoctorBookingStatus.initial,
    this.errorMessage,
    this.selectedPatient,
    this.selectedFacility,
    this.selectedDate,
    this.selectedShift,
    this.selectedSlot,
    this.selectedDoctorService,
    this.slots = const [],
    this.isLoadingSlots = false,
    this.doctorServices = const [],
    this.isLoadingServices = false,
    this.reason = "",
    this.symptoms = "",
  });

  DoctorBookingState copyWith({
    BookingStep? currentStep,
    DoctorBookingStatus? status,
    String? errorMessage,
    Patient? selectedPatient,
    DoctorFacility? selectedFacility,
    DateTime? selectedDate,
    DoctorAvailability? selectedShift,
    Slot? selectedSlot,
    DoctorService? selectedDoctorService,
    List<Slot>? slots,
    bool? isLoadingSlots,
    List<DoctorService>? doctorServices,
    bool? isLoadingServices,
    String? reason,
    String? symptoms,
    bool clearError = false,
  }) {
    return DoctorBookingState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedPatient: selectedPatient ?? this.selectedPatient,
      selectedFacility: selectedFacility ?? this.selectedFacility,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedShift: selectedShift ?? this.selectedShift,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      selectedDoctorService: selectedDoctorService ?? this.selectedDoctorService,
      slots: slots ?? this.slots,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
      doctorServices: doctorServices ?? this.doctorServices,
      isLoadingServices: isLoadingServices ?? this.isLoadingServices,
      reason: reason ?? this.reason,
      symptoms: symptoms ?? this.symptoms,
    );
  }
}
