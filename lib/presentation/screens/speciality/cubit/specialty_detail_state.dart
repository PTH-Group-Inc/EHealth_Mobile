import 'package:equatable/equatable.dart';
import 'package:e_health/domain/department.dart';
import 'package:e_health/domain/branch.dart';
import 'package:e_health/domain/specialty.dart';
import 'package:e_health/domain/facility_service.dart';
import 'package:e_health/domain/slot.dart';

enum SpecialtyDetailStatus { initial, loading, success, failure }

class SpecialtyDetailState extends Equatable {
  final SpecialtyDetailStatus status;
  final Department? department;
  final Branch? branch;
  final List<Specialty> specialties;
  final Specialty? selectedSpecialty;
  final List<FacilityService> services;
  final String? errorMessage;
  final bool isLoadingServices;
  final int servicePage;
  final bool hasReachedMaxServices;
  final bool isFetchingMoreServices;

  // Calendar & Booking related fields
  final int calendarMonth;
  final int calendarYear;
  final Map<DateTime, bool> calendarAvailability;
  final bool isLoadingCalendar;
  final bool isLoadingDateSlots;
  final List<Slot> availableDateSlots;
  final DateTime? appointmentDate;

  const SpecialtyDetailState({
    this.status = SpecialtyDetailStatus.initial,
    this.department,
    this.branch,
    this.specialties = const [],
    this.selectedSpecialty,
    this.services = const [],
    this.errorMessage,
    this.isLoadingServices = false,
    this.servicePage = 1,
    this.hasReachedMaxServices = false,
    this.isFetchingMoreServices = false,
    this.calendarMonth = 0,
    this.calendarYear = 0,
    this.calendarAvailability = const {},
    this.isLoadingCalendar = false,
    this.isLoadingDateSlots = false,
    this.availableDateSlots = const [],
    this.appointmentDate,
  });

  SpecialtyDetailState copyWith({
    SpecialtyDetailStatus? status,
    Department? department,
    Branch? branch,
    List<Specialty>? specialties,
    Specialty? selectedSpecialty,
    List<FacilityService>? services,
    String? errorMessage,
    bool? isLoadingServices,
    int? servicePage,
    bool? hasReachedMaxServices,
    bool? isFetchingMoreServices,
    int? calendarMonth,
    int? calendarYear,
    Map<DateTime, bool>? calendarAvailability,
    bool? isLoadingCalendar,
    bool? isLoadingDateSlots,
    List<Slot>? availableDateSlots,
    DateTime? appointmentDate,
    bool clearError = false,
    bool clearDate = false,
  }) {
    return SpecialtyDetailState(
      status: status ?? this.status,
      department: department ?? this.department,
      branch: branch ?? this.branch,
      specialties: specialties ?? this.specialties,
      selectedSpecialty: selectedSpecialty ?? this.selectedSpecialty,
      services: services ?? this.services,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoadingServices: isLoadingServices ?? this.isLoadingServices,
      servicePage: servicePage ?? this.servicePage,
      hasReachedMaxServices:
          hasReachedMaxServices ?? this.hasReachedMaxServices,
      isFetchingMoreServices:
          isFetchingMoreServices ?? this.isFetchingMoreServices,
      calendarMonth: calendarMonth ?? this.calendarMonth,
      calendarYear: calendarYear ?? this.calendarYear,
      calendarAvailability: calendarAvailability ?? this.calendarAvailability,
      isLoadingCalendar: isLoadingCalendar ?? this.isLoadingCalendar,
      isLoadingDateSlots: isLoadingDateSlots ?? this.isLoadingDateSlots,
      availableDateSlots:
          clearDate ? const [] : (availableDateSlots ?? this.availableDateSlots),
      appointmentDate:
          clearDate ? null : (appointmentDate ?? this.appointmentDate),
    );
  }

  @override
  List<Object?> get props => [
        status,
        department,
        branch,
        specialties,
        selectedSpecialty,
        services,
        errorMessage,
        isLoadingServices,
        servicePage,
        hasReachedMaxServices,
        isFetchingMoreServices,
        calendarMonth,
        calendarYear,
        calendarAvailability,
        isLoadingCalendar,
        isLoadingDateSlots,
        availableDateSlots,
        appointmentDate,
      ];
}
