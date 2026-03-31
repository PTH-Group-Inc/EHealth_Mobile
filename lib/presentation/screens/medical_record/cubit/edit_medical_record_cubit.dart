import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository.dart';
import '../../../../data/request/update_patient_request.dart';
import 'edit_medical_record_state.dart';

@injectable
class EditMedicalRecordCubit extends Cubit<EditMedicalRecordState> {
  final Repository _repository;

  EditMedicalRecordCubit(this._repository) : super(EditMedicalRecordInitial());

  Future<void> updateMedicalRecord(String id, UpdatePatientRequest request) async {
    emit(EditMedicalRecordLoading());

    final result = await _repository.updatePatientRecord(id, request);

    result.fold(
      (failure) => emit(EditMedicalRecordError(message: failure.message)),
      (patient) => emit(EditMedicalRecordSuccess(patient: patient)),
    );
  }
}
