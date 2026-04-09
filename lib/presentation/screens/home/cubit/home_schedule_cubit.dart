import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository.dart';
import '../../../../app/dependency_injection/configure_injectable.dart';
import 'home_schedule_state.dart';

@injectable
class HomeScheduleCubit extends Cubit<HomeScheduleState> {
  static final _repository = getIt<Repository>();

  HomeScheduleCubit() : super(const HomeScheduleState());

  Future<void> getMyAppointments() async {
    final hasToken = await _repository.hasToken();
    if (!hasToken) {
      emit(state.copyWith(status: HomeScheduleStatus.initial, appointments: []));
      return;
    }

    emit(state.copyWith(
      status: HomeScheduleStatus.loading,
      page: 1,
      hasReachedMax: false,
      isNotLinked: false,
      clearError: true,
    ));
    final result = await _repository.getMyAppointments(page: 1, limit: 20);

    result.fold(
      (failure) {
        final errorMessage = failure.message.toLowerCase();
        final isNotLinked = errorMessage.contains("liên kết") ||
            errorMessage.contains("patient code") ||
            errorMessage.contains("hồ sơ");
        emit(state.copyWith(
          status: HomeScheduleStatus.failure,
          errorMessage: failure.message,
          isNotLinked: isNotLinked,
        ));
      },
      (appointments) => emit(state.copyWith(
        status: HomeScheduleStatus.success,
        appointments: appointments,
        hasReachedMax: appointments.length < 20,
      )),
    );
  }

  Future<void> loadMoreAppointments() async {
    if (state.isFetchingMore || state.hasReachedMax) return;

    emit(state.copyWith(isFetchingMore: true, clearError: true));
    final nextPage = state.page + 1;
    final result = await _repository.getMyAppointments(page: nextPage, limit: 20);

    result.fold(
      (failure) => emit(state.copyWith(
        isFetchingMore: false,
        errorMessage: failure.message,
      )),
      (newAppointments) {
        if (newAppointments.isEmpty) {
          emit(state.copyWith(
            isFetchingMore: false,
            hasReachedMax: true,
          ));
        } else {
          emit(state.copyWith(
            isFetchingMore: false,
            appointments: [...state.appointments, ...newAppointments],
            page: nextPage,
            hasReachedMax: newAppointments.length < 20,
          ));
        }
      },
    );
  }
}
