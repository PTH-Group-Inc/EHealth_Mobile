import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/app/dependency_injection/configure_injectable.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/domain/pre_booking.dart';
import 'package:e_health/presentation/screens/appointment/cubit/payment_qr_state.dart';

@injectable
class PaymentQrCubit extends Cubit<PaymentQrState> {
  static final _repository = getIt<Repository>();
  Timer? _pollingTimer;
  String? _appointmentId;

  PaymentQrCubit() : super(const PaymentQrState());

  void init(PreBookingEntity preBookingEntity) {
    _appointmentId = preBookingEntity.appointmentId;
    emit(state.copyWith(
      qrTemplateData: preBookingEntity.qrTemplateData,
      qrString: preBookingEntity.qrString,
      totalAmount: preBookingEntity.totalAmount,
    ));
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_appointmentId != null) {
        _checkStatus(_appointmentId!);
      }
    });
  }

  Future<void> _checkStatus(String appointmentId) async {
    if (state.isPaid || state.isChecking) return;

    final result = await _repository.checkPaymentStatus(appointmentId);

    result.fold(
      (failure) {
        // We might not want to emit error every 3 seconds if network drops briefly,
        // so we just log or ignore polling errors silently until it succeeds or user cancels.
      },
      (data) {
        if (data.isPaid) {
          _pollingTimer?.cancel();
          emit(state.copyWith(isPaid: true));
        }
      },
    );
  }

  Future<void> regenerateQr() async {
    if (_appointmentId == null) return;
    
    emit(state.copyWith(isRegeneratingQr: true, error: null));
    
    final result = await _repository.regenerateBookingQr(_appointmentId!);
    
    result.fold(
      (failure) => emit(state.copyWith(
        isRegeneratingQr: false, 
        error: failure.message,
      )),
      (data) => emit(state.copyWith(
        isRegeneratingQr: false,
        qrTemplateData: data.qrTemplateData,
        // Since regenerate api might not return base64 string, keep fallback to templateData network URL.
      )),
    );
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
