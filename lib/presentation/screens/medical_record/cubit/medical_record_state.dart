import 'package:equatable/equatable.dart';
import '../../../../domain/patient.dart';

abstract class MedicalRecordState extends Equatable {
  const MedicalRecordState();

  @override
  List<Object?> get props => [];
}

class MedicalRecordInitial extends MedicalRecordState {}

class MedicalRecordLoading extends MedicalRecordState {}

class MedicalRecordLoaded extends MedicalRecordState {
  final List<Patient> patients;
  const MedicalRecordLoaded({required this.patients});

  @override
  List<Object?> get props => [patients];
}

class MedicalRecordEmpty extends MedicalRecordState {}

class MedicalRecordError extends MedicalRecordState {
  final String message;
  const MedicalRecordError({required this.message});

  @override
  List<Object?> get props => [message];
}
