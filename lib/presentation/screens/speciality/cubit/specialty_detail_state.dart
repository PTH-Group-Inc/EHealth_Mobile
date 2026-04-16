import 'package:equatable/equatable.dart';
import '../../../../domain/department.dart';
import '../../../../domain/specialty.dart';
import '../../../../domain/facility_service.dart';

enum SpecialtyDetailStatus { initial, loading, success, failure }

class SpecialtyDetailState extends Equatable {
  final SpecialtyDetailStatus status;
  final Department? department;
  final List<Specialty> specialties;
  final Specialty? selectedSpecialty;
  final List<FacilityService> services;
  final String? errorMessage;
  final bool isLoadingServices;
  final int servicePage;
  final bool hasReachedMaxServices;
  final bool isFetchingMoreServices;

  const SpecialtyDetailState({
    this.status = SpecialtyDetailStatus.initial,
    this.department,
    this.specialties = const [],
    this.selectedSpecialty,
    this.services = const [],
    this.errorMessage,
    this.isLoadingServices = false,
    this.servicePage = 1,
    this.hasReachedMaxServices = false,
    this.isFetchingMoreServices = false,
  });

  SpecialtyDetailState copyWith({
    SpecialtyDetailStatus? status,
    Department? department,
    List<Specialty>? specialties,
    Specialty? selectedSpecialty,
    List<FacilityService>? services,
    String? errorMessage,
    bool? isLoadingServices,
    int? servicePage,
    bool? hasReachedMaxServices,
    bool? isFetchingMoreServices,
    bool clearError = false,
  }) {
    return SpecialtyDetailState(
      status: status ?? this.status,
      department: department ?? this.department,
      specialties: specialties ?? this.specialties,
      selectedSpecialty: selectedSpecialty ?? this.selectedSpecialty,
      services: services ?? this.services,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoadingServices: isLoadingServices ?? this.isLoadingServices,
      servicePage: servicePage ?? this.servicePage,
      hasReachedMaxServices: hasReachedMaxServices ?? this.hasReachedMaxServices,
      isFetchingMoreServices: isFetchingMoreServices ?? this.isFetchingMoreServices,
    );
  }

  @override
  List<Object?> get props => [
        status,
        department,
        specialties,
        selectedSpecialty,
        services,
        errorMessage,
        isLoadingServices,
        servicePage,
        hasReachedMaxServices,
        isFetchingMoreServices,
      ];
}
