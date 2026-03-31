import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository.dart';
import 'medical_history_state.dart';

@injectable
class MedicalHistoryCubit extends Cubit<MedicalHistoryState> {
  final Repository _repository;

  MedicalHistoryCubit(this._repository) : super(MedicalHistoryInitial());

  Future<void> getMedicalHistory(String patientId) async {
    emit(MedicalHistoryLoading());

    final result = await _repository.getMedicalHistory(patientId);

    result.fold(
      (failure) => emit(MedicalHistoryError(message: failure.message)),
      (histories) {
        if (histories.isEmpty) {
          emit(MedicalHistoryEmpty());
        } else {
          emit(MedicalHistoryLoaded(histories: histories));
        }
      },
    );
  }
}
