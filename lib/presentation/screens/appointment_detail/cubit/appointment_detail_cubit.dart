import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/dependency_injection/configure_injectable.dart';
import '../../../../data/repository.dart';
import 'appointment_detail_state.dart';

class AppointmentDetailCubit extends Cubit<AppointmentDetailState> {
  final String appointmentId;
  static final _repository = getIt<Repository>();

  AppointmentDetailCubit({required this.appointmentId})
      : super(const AppointmentDetailState());

  Future<void> getAppointmentDetail() async {
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
