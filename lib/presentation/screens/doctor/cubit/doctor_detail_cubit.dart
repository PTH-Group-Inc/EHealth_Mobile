import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/presentation/screens/doctor/cubit/doctor_detail_state.dart';

@injectable
class DoctorDetailCubit extends Cubit<DoctorDetailState> {
  final Repository _repository;

  DoctorDetailCubit(this._repository) : super(DoctorDetailInitial());

  Future<void> loadDoctorDetail(String userId) async {
    emit(DoctorDetailLoading());
    final result = await _repository.getDoctorDetail(userId);
    result.fold(
      (failure) => emit(DoctorDetailError(message: failure.message)),
      (doctor) async {
        emit(DoctorDetailLoaded(doctor: doctor, availabilityLoading: true));
        if (doctor.doctorsId != null) {
          await loadDoctorAvailability(doctor.doctorsId!);
        } else {
          emit(DoctorDetailLoaded(doctor: doctor, availabilityLoading: false));
        }
      },
    );
  }

  Future<void> loadDoctorAvailability(String doctorId) async {
    final currentState = state;
    if (currentState is DoctorDetailLoaded) {
      emit(currentState.copyWith(availabilityLoading: true));

      final startDate = DateTime.now();
      final endDate = startDate.add(const Duration(days: 10));

      final result = await _repository.getDoctorAvailability(
        doctorId: doctorId,
        startDate: startDate,
        endDate: endDate,
      );

      result.fold(
        (failure) => emit(currentState.copyWith(availabilityLoading: false)),
        (availability) => emit(
          currentState.copyWith(
            availabilityLoading: false,
            availability: availability,
          ),
        ),
      );
    }
  }
}
