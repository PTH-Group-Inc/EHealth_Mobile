import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository.dart';
import 'home_doctor_state.dart';

@injectable
class HomeDoctorCubit extends Cubit<HomeDoctorState> {
  final Repository _repository;

  HomeDoctorCubit(this._repository) : super(HomeDoctorInitial());

  Future<void> loadDoctors() async {
    emit(HomeDoctorLoading());
    final result = await _repository.getActiveDoctors();
    result.fold(
      (failure) => emit(HomeDoctorError(message: failure.message)),
      (doctors) {
        emit(HomeDoctorLoaded(doctors: doctors));
      },
    );
  }
}
