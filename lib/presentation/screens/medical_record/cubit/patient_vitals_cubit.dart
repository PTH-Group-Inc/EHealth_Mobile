import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository.dart';
import 'patient_vitals_state.dart';

@injectable
class PatientVitalsCubit extends Cubit<PatientVitalsState> {
  final Repository _repository;

  PatientVitalsCubit(this._repository) : super(PatientVitalsInitial());

  Future<void> loadLatestVitals(String patientId) async {
    emit(PatientVitalsLoading());
    final result = await _repository.getPatientLatestVitals(patientId);
    result.fold(
      (failure) => emit(PatientVitalsFailure(failure.message)),
      (vitals) {
        if (vitals == null) {
          emit(PatientVitalsNoData());
        } else {
          emit(PatientVitalsSuccess(vitals));
        }
      },
    );
  }
}
