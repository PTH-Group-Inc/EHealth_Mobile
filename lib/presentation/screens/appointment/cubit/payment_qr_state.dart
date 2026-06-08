import 'package:equatable/equatable.dart';

class PaymentQrState extends Equatable {
  final String? appointmentId;
  final bool isChecking;
  final bool isPaid;
  final bool isRegeneratingQr;
  final String? error;
  final String qrTemplateData;
  final String qrString;
  final double totalAmount;

  const PaymentQrState({
    this.appointmentId,
    this.isChecking = false,
    this.isPaid = false,
    this.isRegeneratingQr = false,
    this.error,
    this.qrTemplateData = '',
    this.qrString = '',
    this.totalAmount = 0.0,
  });

  PaymentQrState copyWith({
    String? appointmentId,
    bool? isChecking,
    bool? isPaid,
    bool? isRegeneratingQr,
    String? error,
    String? qrTemplateData,
    String? qrString,
    double? totalAmount,
  }) {
    return PaymentQrState(
      appointmentId: appointmentId ?? this.appointmentId,
      isChecking: isChecking ?? this.isChecking,
      isPaid: isPaid ?? this.isPaid,
      isRegeneratingQr: isRegeneratingQr ?? this.isRegeneratingQr,
      error: error ?? this.error,
      qrTemplateData: qrTemplateData ?? this.qrTemplateData,
      qrString: qrString ?? this.qrString,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  List<Object?> get props => [
        appointmentId,
        isChecking,
        isPaid,
        isRegeneratingQr,
        error,
        qrTemplateData,
        qrString,
        totalAmount,
      ];
}
