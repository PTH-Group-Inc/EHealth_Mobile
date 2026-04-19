import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/data/request/update_patient_request.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/create_medical_record_state.dart';

@injectable
class CreateMedicalRecordCubit extends Cubit<CreateMedicalRecordState> {
  final Repository _repository;

  CreateMedicalRecordCubit(this._repository) : super(CreateMedicalRecordInitial());

  Future<void> createMedicalRecord(UpdatePatientRequest request, String accountId) async {
    emit(CreateMedicalRecordLoading());

    // Step 1: Create Patient
    final createResult = await _repository.createPatientRecord(request);

    await createResult.fold(
      (failure) async => emit(CreateMedicalRecordError(message: "Tạo hồ sơ thất bại: ${failure.message}")),
      (patient) async {
        // Step 2: Link Account
        final linkResult = await _repository.linkAccountRecord(patient.id, accountId);

        linkResult.fold(
          (failure) => emit(CreateMedicalRecordError(
            message: "Hồ sơ đã tạo (${patient.patientCode}) nhưng liên kết tài khoản thất bại: ${failure.message}",
          )),
          (_) => emit(CreateMedicalRecordSuccess(patient: patient)),
        );
      },
    );
  }
}
