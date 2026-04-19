import 'package:equatable/equatable.dart';
import 'package:e_health/domain/medication.dart';
import 'package:e_health/domain/patient.dart';

abstract class MedicationReminderState extends Equatable {
  const MedicationReminderState();

  @override
  List<Object?> get props => [];
}

class MedicationReminderInitial extends MedicationReminderState {}

class MedicationReminderLoading extends MedicationReminderState {}

class MedicationReminderLoaded extends MedicationReminderState {
  final Map<Patient, List<Medication>> patientMedications;

  const MedicationReminderLoaded({required this.patientMedications});

  @override
  List<Object?> get props => [patientMedications];
}

class MedicationReminderError extends MedicationReminderState {
  final String message;

  const MedicationReminderError({required this.message});

  @override
  List<Object?> get props => [message];
}
