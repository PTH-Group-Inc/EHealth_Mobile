import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository.dart';
import '../../../../app/dependency_injection/configure_injectable.dart';
import 'home_schedule_state.dart';

@injectable
class HomeScheduleCubit extends Cubit<HomeScheduleState> {
  static final _repository = getIt<Repository>();

  HomeScheduleCubit() : super(HomeScheduleInitial());

  Future<void> getMyAppointments() async {
    emit(HomeScheduleLoading());
    final result = await _repository.getMyAppointments();

    result.fold(
      (failure) => emit(HomeScheduleError(message: failure.message)),
      (appointments) => emit(HomeScheduleLoaded(appointments: appointments)),
    );
  }
}
