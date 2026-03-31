import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository.dart';
import 'medical_history_state.dart';

@injectable
class MedicalHistoryCubit extends Cubit<MedicalHistoryState> {
  final Repository _repository;

  MedicalHistoryCubit(this._repository) : super(const MedicalHistoryState());

  Future<void> loadMedicalHistory(String patientId) async {
    emit(state.copyWith(
      status: MedicalHistoryStatus.loading,
      page: 1,
      hasReachedMax: false,
    ));
    final result = await _repository.getMedicalHistory(patientId, page: 1, limit: 20);
    result.fold(
      (failure) => emit(state.copyWith(
        status: MedicalHistoryStatus.failure,
        errorMessage: failure.message,
      )),
      (histories) {
        emit(state.copyWith(
          status: MedicalHistoryStatus.success,
          histories: histories,
          hasReachedMax: histories.length < 20,
        ));
      },
    );
  }

  Future<void> loadMoreMedicalHistory(String patientId) async {
    if (state.isFetchingMore || state.hasReachedMax) return;

    emit(state.copyWith(isFetchingMore: true));
    final nextPage = state.page + 1;
    final result = await _repository.getMedicalHistory(patientId, page: nextPage, limit: 20);

    result.fold(
      (failure) => emit(state.copyWith(
        isFetchingMore: false,
        errorMessage: failure.message,
      )),
      (newHistories) {
        if (newHistories.isEmpty) {
          emit(state.copyWith(
            isFetchingMore: false,
            hasReachedMax: true,
          ));
        } else {
          emit(state.copyWith(
            isFetchingMore: false,
            histories: [...state.histories, ...newHistories],
            page: nextPage,
            hasReachedMax: newHistories.length < 20,
          ));
        }
      },
    );
  }
}
