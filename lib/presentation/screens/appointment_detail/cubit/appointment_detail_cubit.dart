import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/domain/pre_booking.dart' as e_health_preBooking;
import 'package:e_health/presentation/screens/appointment_detail/cubit/appointment_detail_state.dart';

@injectable
class AppointmentDetailCubit extends Cubit<AppointmentDetailState> {
  final Repository _repository;

  AppointmentDetailCubit(this._repository)
      : super(const AppointmentDetailState());

  Future<void> getAppointmentDetail(String appointmentId) async {
    emit(state.copyWith(status: AppointmentDetailStatus.loading));

    final result = await _repository.getAppointmentDetail(appointmentId);

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: AppointmentDetailStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (data) async {
        // If status is COMPLETED, fetch Encounter and Prescription
        if (data.appointment.status.toUpperCase() == 'COMPLETED') {
          final encounterResult = await _repository.getEncounterByAppointment(
            appointmentId,
          );

          await encounterResult.fold(
            (l) async {
              emit(
                state.copyWith(
                  status: AppointmentDetailStatus.success,
                  appointment: data,
                ),
              );
            },
            (encounter) async {
              final prescriptionResult = await _repository.getPrescription(
                encounter.id,
              );

              prescriptionResult.fold(
                (l) => emit(
                  state.copyWith(
                    status: AppointmentDetailStatus.success,
                    appointment: data,
                    encounter: encounter,
                  ),
                ),
                (prescription) => emit(
                  state.copyWith(
                    status: AppointmentDetailStatus.success,
                    appointment: data,
                    encounter: encounter,
                    prescription: prescription,
                  ),
                ),
              );
            },
          );
        } else {
          emit(
            state.copyWith(
              status: AppointmentDetailStatus.success,
              appointment: data,
            ),
          );
        }
      },
    );
  }

  Future<void> preparePayment(String appointmentId) async {
    emit(state.copyWith(isPreparingPayment: true, navigateToPayment: false));

    // 1. Get Encounter
    final encounterResult = await _repository.getEncounterByAppointment(
      appointmentId,
    );

    await encounterResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            isPreparingPayment: false,
            errorMessage: "Không tìm thấy hồ sơ khám: ${failure.message}",
          ),
        );
      },
      (encounter) async {
        // 2. Get Invoice
        final invoiceResult = await _repository.getInvoiceByEncounter(
          encounter.id,
        );

        invoiceResult.fold(
          (failure) => emit(
            state.copyWith(
              isPreparingPayment: false,
              errorMessage: "Không tìm thấy hóa đơn: ${failure.message}",
            ),
          ),
          (invoice) {
            emit(
              state.copyWith(
                isPreparingPayment: false,
                encounter: encounter,
                invoice: invoice,
                navigateToPayment: invoice.status.toUpperCase() == 'UNPAID',
                errorMessage: invoice.status.toUpperCase() != 'UNPAID'
                    ? "Hóa đơn này đã được thanh toán hoặc không hợp lệ"
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> preparePreBookingPayment(String appointmentId) async {
    emit(state.copyWith(isPreparingPayment: true));

    final result = await _repository.regenerateBookingQr(appointmentId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isPreparingPayment: false,
          errorMessage: "Lỗi tải thông tin thanh toán: ${failure.message}",
        ),
      ),
      (data) {
        // Map RegenerateQrEntity back to PreBookingEntity
        final preBooking = e_health_preBooking.PreBookingEntity(
          appointmentId: data.appointmentId,
          status: 'PENDING_PAYMENT',
          invoiceId: data.invoiceId,
          totalAmount: data.amount,
          qrTemplateData: data.qrTemplateData,
          qrString: '', // fallback or ignore
        );
        emit(
          state.copyWith(
            isPreparingPayment: false,
            preBookingEntity: preBooking,
          ),
        );
      },
    );
  }

  void clearNavigation() {
    emit(state.copyWith(navigateToPayment: false, clearPreBooking: true));
  }

  Future<void> cancelAppointment(String appointmentId, String reason) async {
    emit(state.copyWith(isCancelling: true, cancelSuccess: false));

    final result = await _repository.cancelAppointment(appointmentId, reason);

    result.fold(
      (failure) => emit(
        state.copyWith(isCancelling: false, errorMessage: failure.message),
      ),
      (data) {
        emit(state.copyWith(isCancelling: false, cancelSuccess: true));
        // Refresh detail to show updated status
        getAppointmentDetail(appointmentId);
      },
    );
  }

  void clearCancelState() {
    emit(state.copyWith(cancelSuccess: false));
  }
}
