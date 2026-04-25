import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/presentation/screens/doctor/cubit/all_doctor_state.dart';

@injectable
class AllDoctorCubit extends Cubit<AllDoctorState> {
  final Repository _repository;

  AllDoctorCubit(this._repository) : super(const AllDoctorState());

  Future<void> loadDoctors({String? query}) async {
    final searchParam = query ?? state.query;
    emit(
      state.copyWith(
        status: AllDoctorStatus.loading,
        doctors: [],
        currentPage: 1,
        hasReachedMax: false,
        query: searchParam,
      ),
    );

    final result = await _repository.searchDoctors(
      search: searchParam,
      page: 1,
      limit: 10,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AllDoctorStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: AllDoctorStatus.success,
          doctors: data,
          hasReachedMax: data.length < 10,
        ),
      ),
    );
  }

  Future<void> loadMoreDoctors() async {
    if (state.isFetchingMore || state.hasReachedMax) return;

    emit(state.copyWith(isFetchingMore: true));
    final nextPage = state.currentPage + 1;

    final result = await _repository.searchDoctors(
      search: state.query,
      page: nextPage,
      limit: 10,
    );

    result.fold((failure) => emit(state.copyWith(isFetchingMore: false)), (
      data,
    ) {
      if (data.isEmpty) {
        emit(state.copyWith(isFetchingMore: false, hasReachedMax: true));
      } else {
        emit(
          state.copyWith(
            isFetchingMore: false,
            doctors: [...state.doctors, ...data],
            currentPage: nextPage,
            hasReachedMax: data.length < 10,
          ),
        );
      }
    });
  }
}
