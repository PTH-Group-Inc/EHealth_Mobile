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
      (doctor) {
        emit(DoctorDetailLoaded(doctor: doctor));
      },
    );
  }
}
