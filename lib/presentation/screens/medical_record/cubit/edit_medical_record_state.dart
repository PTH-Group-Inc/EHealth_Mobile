import 'package:equatable/equatable.dart';
import '../../../../domain/patient.dart';

abstract class EditMedicalRecordState extends Equatable {
  const EditMedicalRecordState();

  @override
  List<Object?> get props => [];
}

class EditMedicalRecordInitial extends EditMedicalRecordState {}

class EditMedicalRecordLoading extends EditMedicalRecordState {}

class EditMedicalRecordSuccess extends EditMedicalRecordState {
  final Patient patient;
  const EditMedicalRecordSuccess({required this.patient});

  @override
  List<Object?> get props => [patient];
}

class EditMedicalRecordError extends EditMedicalRecordState {
  final String message;
  const EditMedicalRecordError({required this.message});

  @override
  List<Object?> get props => [message];
}
