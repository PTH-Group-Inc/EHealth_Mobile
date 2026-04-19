import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_state.dart';

@injectable
class MedicalRecordCubit extends Cubit<MedicalRecordState> {
  final Repository _repository;

  MedicalRecordCubit(this._repository) : super(MedicalRecordInitial());

  Future<void> loadMedicalRecord(String accountId) async {
    emit(MedicalRecordLoading());

    final result = await _repository.getPatientRecord(accountId);

    result.fold(
      (failure) => emit(MedicalRecordError(message: failure.message)),
      (patients) {
        if (patients.isEmpty) {
          emit(MedicalRecordEmpty());
        } else {
          emit(MedicalRecordLoaded(patients: patients));
        }
      },
    );
  }
}
