import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repository.dart';
import 'all_medical_facility_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class AllMedicalFacilityCubit extends Cubit<AllMedicalFacilityState> {
  final Repository _repository;

  AllMedicalFacilityCubit(this._repository) : super(AllMedicalFacilityInitial());

  Future<void> loadFacilities() async {
    emit(AllMedicalFacilityLoading());
    final result = await _repository.getFacilities();
    result.fold(
      (failure) => emit(AllMedicalFacilityError(message: failure.message)),
      (facilities) => emit(AllMedicalFacilityLoaded(facilities: facilities)),
    );
  }
}
