import 'package:equatable/equatable.dart';
import '../../../../domain/patient.dart';

abstract class CreateMedicalRecordState extends Equatable {
  const CreateMedicalRecordState();

  @override
  List<Object?> get props => [];
}

class CreateMedicalRecordInitial extends CreateMedicalRecordState {}

class CreateMedicalRecordLoading extends CreateMedicalRecordState {}

class CreateMedicalRecordSuccess extends CreateMedicalRecordState {
  final Patient patient;
  const CreateMedicalRecordSuccess({required this.patient});

  @override
  List<Object?> get props => [patient];
}

class CreateMedicalRecordError extends CreateMedicalRecordState {
  final String message;
  const CreateMedicalRecordError({required this.message});

  @override
  List<Object?> get props => [message];
}
