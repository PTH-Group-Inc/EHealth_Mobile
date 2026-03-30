import '../../../../domain/doctor.dart';

abstract class HomeDoctorState {}

class HomeDoctorInitial extends HomeDoctorState {}

class HomeDoctorLoading extends HomeDoctorState {}

class HomeDoctorLoaded extends HomeDoctorState {
  final List<Doctor> doctors;

  HomeDoctorLoaded({required this.doctors});
}

class HomeDoctorError extends HomeDoctorState {
  final String message;

  HomeDoctorError({required this.message});
}
