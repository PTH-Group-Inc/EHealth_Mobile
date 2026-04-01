import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/presentation/screens/appointment_detail/cubit/appointment_detail_state.dart';

@injectable
class AppointmentDetailCubit extends Cubit<AppointmentDetailState> {
  final Repository _repository;

  AppointmentDetailCubit(this._repository)
      : super(const AppointmentDetailState());

  Future<void> getAppointmentDetail(String appointmentId) async {
    emit(state.copyWith(status: AppointmentDetailStatus.loading));

    final result = await _repository.getAppointmentDetail(appointmentId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AppointmentDetailStatus.failure,
        errorMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        status: AppointmentDetailStatus.success,
        appointment: data,
      )),
    );
  }
}
