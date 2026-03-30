import 'package:e_health/domain/doctor_detail.dart';

abstract class DoctorDetailState {}

class DoctorDetailInitial extends DoctorDetailState {}

class DoctorDetailLoading extends DoctorDetailState {}

class DoctorDetailLoaded extends DoctorDetailState {
  final DoctorDetail doctor;

  DoctorDetailLoaded({required this.doctor});
}

class DoctorDetailError extends DoctorDetailState {
  final String message;

  DoctorDetailError({required this.message});
}
