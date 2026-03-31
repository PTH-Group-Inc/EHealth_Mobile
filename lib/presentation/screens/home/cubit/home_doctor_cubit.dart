import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository.dart';
import 'home_doctor_state.dart';

@injectable
class HomeDoctorCubit extends Cubit<HomeDoctorState> {
  final Repository _repository;

  HomeDoctorCubit(this._repository) : super(const HomeDoctorState());

  Future<void> loadDoctors() async {
    emit(state.copyWith(
      status: HomeDoctorStatus.loading,
      page: 1,
      hasReachedMax: false,
    ));
    final result = await _repository.getActiveDoctors(page: 1, limit: 20);
    result.fold(
      (failure) => emit(state.copyWith(
        status: HomeDoctorStatus.failure,
        errorMessage: failure.message,
      )),
      (doctors) {
        emit(state.copyWith(
          status: HomeDoctorStatus.success,
          doctors: doctors,
          hasReachedMax: doctors.length < 20,
        ));
      },
    );
  }

  Future<void> loadMoreDoctors() async {
    if (state.isFetchingMore || state.hasReachedMax) return;

    emit(state.copyWith(isFetchingMore: true));
    final nextPage = state.page + 1;
    final result = await _repository.getActiveDoctors(page: nextPage, limit: 20);

    result.fold(
      (failure) => emit(state.copyWith(
        isFetchingMore: false,
        errorMessage: failure.message,
      )),
      (newDoctors) {
        if (newDoctors.isEmpty) {
          emit(state.copyWith(
            isFetchingMore: false,
            hasReachedMax: true,
          ));
        } else {
          emit(state.copyWith(
            isFetchingMore: false,
            doctors: [...state.doctors, ...newDoctors],
            page: nextPage,
            hasReachedMax: newDoctors.length < 20,
          ));
        }
      },
    );
  }
}
