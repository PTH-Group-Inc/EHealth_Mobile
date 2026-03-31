import 'package:equatable/equatable.dart';
import '../../../../domain/medical_history.dart';

abstract class MedicalHistoryState extends Equatable {
  const MedicalHistoryState();

  @override
  List<Object?> get props => [];
}

class MedicalHistoryInitial extends MedicalHistoryState {}

class MedicalHistoryLoading extends MedicalHistoryState {}

class MedicalHistoryLoaded extends MedicalHistoryState {
  final List<MedicalHistory> histories;

  const MedicalHistoryLoaded({required this.histories});

  @override
  List<Object?> get props => [histories];
}

class MedicalHistoryEmpty extends MedicalHistoryState {}

class MedicalHistoryError extends MedicalHistoryState {
  final String message;

  const MedicalHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
