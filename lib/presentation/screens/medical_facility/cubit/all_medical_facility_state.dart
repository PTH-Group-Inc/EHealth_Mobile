import 'package:equatable/equatable.dart';
import '../../../../domain/medical_facility.dart';

abstract class AllMedicalFacilityState extends Equatable {
  const AllMedicalFacilityState();

  @override
  List<Object?> get props => [];
}

class AllMedicalFacilityInitial extends AllMedicalFacilityState {}

class AllMedicalFacilityLoading extends AllMedicalFacilityState {}

class AllMedicalFacilityLoaded extends AllMedicalFacilityState {
  final List<MedicalFacility> facilities;

  const AllMedicalFacilityLoaded({required this.facilities});

  @override
  List<Object?> get props => [facilities];
}

class AllMedicalFacilityError extends AllMedicalFacilityState {
  final String message;

  const AllMedicalFacilityError({required this.message});

  @override
  List<Object?> get props => [message];
}
