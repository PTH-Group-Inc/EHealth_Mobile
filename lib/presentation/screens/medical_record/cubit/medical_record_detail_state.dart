import 'package:e_health/domain/patient.dart';

abstract class MedicalRecordDetailState {}

class MedicalRecordDetailInitial extends MedicalRecordDetailState {}

class MedicalRecordDetailLoading extends MedicalRecordDetailState {}

class MedicalRecordDetailLoaded extends MedicalRecordDetailState {
  final Patient patient;
  MedicalRecordDetailLoaded({required this.patient});
}

class MedicalRecordDetailError extends MedicalRecordDetailState {
  final String message;
  MedicalRecordDetailError({required this.message});
}

class MedicalRecordDetailAvatarUploading extends MedicalRecordDetailState {
  final Patient currentPatient;
  MedicalRecordDetailAvatarUploading({required this.currentPatient});
}

class MedicalRecordDetailAvatarSuccess extends MedicalRecordDetailState {
  final Patient updatedPatient;
  final String message;
  MedicalRecordDetailAvatarSuccess({
    required this.updatedPatient,
    required this.message,
  });
}

class MedicalRecordDetailDeleteLoading extends MedicalRecordDetailState {}

class MedicalRecordDetailDeleteSuccess extends MedicalRecordDetailState {}
