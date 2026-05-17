import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_detail_state.dart';
import 'package:e_health/domain/patient.dart';
import 'package:e_health/domain/avatar.dart';

@injectable
class MedicalRecordDetailCubit extends Cubit<MedicalRecordDetailState> {
  final Repository _repository;

  MedicalRecordDetailCubit(this._repository) : super(MedicalRecordDetailInitial());

  Future<void> loadPatientDetail(String id) async {
    emit(MedicalRecordDetailLoading());

    final result = await _repository.getPatientRecordById(id);

    result.fold(
      (failure) => emit(MedicalRecordDetailError(message: failure.message)),
      (patient) => emit(MedicalRecordDetailLoaded(patient: patient)),
    );
  }

  Future<void> uploadAvatar(String id, String imagePath, Patient currentPatient) async {
    emit(MedicalRecordDetailAvatarUploading(currentPatient: currentPatient));

    final result = await _repository.uploadPatientAvatar(id, imagePath);

    result.fold(
      (failure) => emit(MedicalRecordDetailError(message: failure.message)),
      (avatar) {
        final updatedAvatars = List<Avatar>.from(currentPatient.avatarUrl)..insert(0, avatar);
        final updatedPatient = currentPatient.copyWith(avatarUrl: updatedAvatars);
        emit(MedicalRecordDetailAvatarSuccess(
          updatedPatient: updatedPatient,
          message: "Cập nhật ảnh đại diện thành công",
        ));
      },
    );
  }

  void updatePatientLocally(Patient patient) {
    emit(MedicalRecordDetailLoaded(patient: patient));
  }

  Future<void> deletePatient(String id) async {
    emit(MedicalRecordDetailDeleteLoading());

    final result = await _repository.deletePatientRecord(id);

    result.fold(
      (failure) => emit(MedicalRecordDetailError(message: failure.message)),
      (_) => emit(MedicalRecordDetailDeleteSuccess()),
    );
  }
}
