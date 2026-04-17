import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/data/repository.dart';
import 'medication_reminder_state.dart';
import '../../../../domain/medication.dart';
import '../../../../domain/patient.dart';

@injectable
class MedicationReminderCubit extends Cubit<MedicationReminderState> {
  final Repository _repository;

  MedicationReminderCubit(this._repository) : super(MedicationReminderInitial());

  Future<void> loadMedications() async {
    emit(MedicationReminderLoading());

    // 1. Get current profile to get account ID
    final profileResult = await _repository.getProfile();
    
    await profileResult.fold(
      (failure) async {
        emit(MedicationReminderError(message: failure.message));
      },
      (profile) async {
        // 2. Get patient records for this account
        final patientsResult = await _repository.getPatientRecord(profile.id);
        
        await patientsResult.fold(
          (failure) async {
            emit(MedicationReminderError(message: failure.message));
          },
          (patients) async {
            if (patients.isEmpty) {
              emit(const MedicationReminderLoaded(patientMedications: {}));
              return;
            }

            final Map<Patient, List<Medication>> patientMedications = {};
            String? errorMessage;

            // 3. Fetch medications for each patient
            final futures = patients.map((patient) async {
              final medsResult = await _repository.getCurrentMedications(patient.id);
              medsResult.fold(
                (failure) {
                  errorMessage = failure.message;
                },
                (meds) {
                  if (meds.isNotEmpty) {
                    patientMedications[patient] = meds;
                  }
                },
              );
            }).toList();

            await Future.wait(futures);

            if (errorMessage != null && patientMedications.isEmpty) {
              emit(MedicationReminderError(message: errorMessage!));
            } else {
              emit(MedicationReminderLoaded(patientMedications: patientMedications));
            }
          },
        );
      },
    );
  }
}
