import 'package:e_health/domain/doctor_detail.dart';
import 'package:e_health/domain/doctor_availability.dart';

abstract class DoctorDetailState {}

class DoctorDetailInitial extends DoctorDetailState {}

class DoctorDetailLoading extends DoctorDetailState {}

class DoctorDetailLoaded extends DoctorDetailState {
  final DoctorDetail doctor;
  final Map<String, List<DoctorAvailability>>? availability;
  final bool availabilityLoading;

  DoctorDetailLoaded({
    required this.doctor,
    this.availability,
    this.availabilityLoading = false,
  });

  DoctorDetailLoaded copyWith({
    DoctorDetail? doctor,
    Map<String, List<DoctorAvailability>>? availability,
    bool? availabilityLoading,
  }) {
    return DoctorDetailLoaded(
      doctor: doctor ?? this.doctor,
      availability: availability ?? this.availability,
      availabilityLoading: availabilityLoading ?? this.availabilityLoading,
    );
  }
}

class DoctorDetailError extends DoctorDetailState {
  final String message;

  DoctorDetailError({required this.message});
}
