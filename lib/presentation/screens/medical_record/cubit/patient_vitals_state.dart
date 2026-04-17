import 'package:equatable/equatable.dart';
import '../../../../domain/patient_vitals.dart';

abstract class PatientVitalsState extends Equatable {
  const PatientVitalsState();

  @override
  List<Object?> get props => [];
}

class PatientVitalsInitial extends PatientVitalsState {}

class PatientVitalsLoading extends PatientVitalsState {}

class PatientVitalsSuccess extends PatientVitalsState {
  final PatientVitals vitals;
  const PatientVitalsSuccess(this.vitals);

  @override
  List<Object?> get props => [vitals];
}

class PatientVitalsNoData extends PatientVitalsState {}

class PatientVitalsFailure extends PatientVitalsState {
  final String message;
  const PatientVitalsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
