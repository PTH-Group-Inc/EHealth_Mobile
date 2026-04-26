import 'package:equatable/equatable.dart';
 
class PreBookingEntity extends Equatable {
  final String appointmentId;
  final String status;
  final String invoiceId;
  final double totalAmount;
  final String qrTemplateData;
  final String qrString;

  const PreBookingEntity({
    required this.appointmentId,
    required this.status,
    required this.invoiceId,
    required this.totalAmount,
    required this.qrTemplateData,
    required this.qrString,
  });

  @override
  List<Object?> get props => [
    appointmentId,
    status,
    invoiceId,
    totalAmount,
    qrTemplateData,
    qrString,
  ];
}

class RegenerateQrEntity extends Equatable {
  final String appointmentId;
  final String invoiceId;
  final double amount;
  final String qrTemplateData;

  const RegenerateQrEntity({
    required this.appointmentId,
    required this.invoiceId,
    required this.amount,
    required this.qrTemplateData,
  });

  @override
  List<Object?> get props => [appointmentId, invoiceId, amount, qrTemplateData];
}

class PaymentStatusEntity extends Equatable {
  final bool isPaid;
  final String appointmentStatus;
  final String invoiceStatus;

  const PaymentStatusEntity({
    required this.isPaid,
    required this.appointmentStatus,
    required this.invoiceStatus,
  });

  @override
  List<Object?> get props => [isPaid, appointmentStatus, invoiceStatus];
}
