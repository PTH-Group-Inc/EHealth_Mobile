import '../../../../domain/department.dart';
import '../../../../domain/specialty.dart';
import '../../../../domain/facility_service.dart';
import 'package:equatable/equatable.dart';

abstract class SpecialtyDetailState extends Equatable {
  const SpecialtyDetailState();

  @override
  List<Object?> get props => [];
}

class SpecialtyDetailInitial extends SpecialtyDetailState {}

class SpecialtyDetailLoading extends SpecialtyDetailState {}

class SpecialtyDetailLoaded extends SpecialtyDetailState {
  final Department department;
  final List<Specialty> specialties;
  final Specialty? selectedSpecialty;
  final List<FacilityService> services;
  final bool isLoadingServices;

  const SpecialtyDetailLoaded({
    required this.department,
    required this.specialties,
    this.selectedSpecialty,
    this.services = const [],
    this.isLoadingServices = false,
  });

  SpecialtyDetailLoaded copyWith({
    Department? department,
    List<Specialty>? specialties,
    Specialty? selectedSpecialty,
    List<FacilityService>? services,
    bool? isLoadingServices,
  }) {
    return SpecialtyDetailLoaded(
      department: department ?? this.department,
      specialties: specialties ?? this.specialties,
      selectedSpecialty: selectedSpecialty ?? this.selectedSpecialty,
      services: services ?? this.services,
      isLoadingServices: isLoadingServices ?? this.isLoadingServices,
    );
  }

  @override
  List<Object?> get props =>
      [department, specialties, selectedSpecialty, services, isLoadingServices];
}

class SpecialtyDetailError extends SpecialtyDetailState {
  final String message;

  const SpecialtyDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
