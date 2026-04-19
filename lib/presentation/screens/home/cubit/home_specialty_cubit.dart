import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/presentation/screens/home/cubit/home_specialty_state.dart';

@injectable
class HomeSpecialtyCubit extends Cubit<HomeSpecialtyState> {
  final Repository _repository;

  HomeSpecialtyCubit(this._repository) : super(HomeSpecialtyInitial());

  Future<void> loadSpecialties() async {
    emit(HomeSpecialtyLoading());
    final result = await _repository.getSpecialties();
    result.fold(
      (failure) => emit(HomeSpecialtyError(message: failure.message)),
      (specialties) {
        // Only show 2-3 as requested by user
        final limitedSpecialties = specialties.take(3).toList();
        emit(HomeSpecialtyLoaded(specialties: limitedSpecialties));
      },
    );
  }
}
