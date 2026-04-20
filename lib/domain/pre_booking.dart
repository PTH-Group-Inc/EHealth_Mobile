class PreBookingEntity {
  final String appointmentId;
  final String status;
  final String invoiceId;
  final double totalAmount;
  final String qrTemplateData;
  final String qrString;

  PreBookingEntity({
    required this.appointmentId,
    required this.status,
    required this.invoiceId,
    required this.totalAmount,
    required this.qrTemplateData,
    required this.qrString,
  });
}

class RegenerateQrEntity {
  final String appointmentId;
  final String invoiceId;
  final double amount;
  final String qrTemplateData;

  RegenerateQrEntity({
    required this.appointmentId,
    required this.invoiceId,
    required this.amount,
    required this.qrTemplateData,
  });
}

class PaymentStatusEntity {
  final bool isPaid;
  final String appointmentStatus;
  final String invoiceStatus;

  PaymentStatusEntity({
    required this.isPaid,
    required this.appointmentStatus,
    required this.invoiceStatus,
  });
}
