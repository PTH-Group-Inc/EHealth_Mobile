class Invoice {
  final String id;
  final String code;
  final String patientId;
  final String encounterId;
  final String facilityId;
  final String totalAmount;
  final String discountAmount;
  final String insuranceAmount;
  final String netAmount;
  final String paidAmount;
  final String status;
  final List<InvoiceItem> items;
  final List<PaymentTransaction> payments;
  final DateTime? createdAt;

  Invoice({
    required this.id,
    required this.code,
    required this.patientId,
    required this.encounterId,
    required this.facilityId,
    required this.totalAmount,
    required this.discountAmount,
    required this.insuranceAmount,
    required this.netAmount,
    required this.paidAmount,
    required this.status,
    required this.items,
    required this.payments,
    this.createdAt,
  });
}

class InvoiceItem {
  final String id;
  final String name;
  final int quantity;
  final String unitPrice;
  final String subtotal;
  final String insuranceCovered;
  final String patientPays;

  InvoiceItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.insuranceCovered,
    required this.patientPays,
  });
}

class PaymentTransaction {
  final String id;
  final String code;
  final String method;
  final String amount;
  final String status;
  final DateTime? paidAt;

  PaymentTransaction({
    required this.id,
    required this.code,
    required this.method,
    required this.amount,
    required this.status,
    this.paidAt,
  });
}
