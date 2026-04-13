import 'package:json_annotation/json_annotation.dart';
import '../../domain/invoice.dart';

part 'invoice_response.g.dart';

@JsonSerializable()
class InvoiceResponse {
  @JsonKey(name: 'invoices_id')
  final String id;
  
  @JsonKey(name: 'invoice_code')
  final String code;
  
  @JsonKey(name: 'patient_id')
  final String patientId;
  
  @JsonKey(name: 'encounter_id')
  final String encounterId;
  
  @JsonKey(name: 'facility_id')
  final String facilityId;
  
  @JsonKey(name: 'total_amount')
  final String totalAmount;
  
  @JsonKey(name: 'discount_amount')
  final String discountAmount;
  
  @JsonKey(name: 'insurance_amount')
  final String insuranceAmount;
  
  @JsonKey(name: 'net_amount')
  final String netAmount;
  
  @JsonKey(name: 'paid_amount')
  final String paidAmount;
  
  @JsonKey(name: 'status')
  final String status;
  
  @JsonKey(name: 'items')
  final List<InvoiceItemResponse>? items;
  
  @JsonKey(name: 'payments')
  final List<PaymentTransactionResponse>? payments;
  
  @JsonKey(name: 'created_at')
  final String? createdAt;

  InvoiceResponse({
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
    this.items,
    this.payments,
    this.createdAt,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) =>
      _$InvoiceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceResponseToJson(this);

  Invoice map() {
    return Invoice(
      id: id,
      code: code,
      patientId: patientId,
      encounterId: encounterId,
      facilityId: facilityId,
      totalAmount: totalAmount,
      discountAmount: discountAmount,
      insuranceAmount: insuranceAmount,
      netAmount: netAmount,
      paidAmount: paidAmount,
      status: status,
      items: items?.map((e) => e.map()).toList() ?? [],
      payments: payments?.map((e) => e.map()).toList() ?? [],
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
    );
  }
}

@JsonSerializable()
class InvoiceItemResponse {
  @JsonKey(name: 'invoice_details_id')
  final String id;
  
  @JsonKey(name: 'item_name')
  final String name;
  
  @JsonKey(name: 'quantity')
  final int quantity;
  
  @JsonKey(name: 'unit_price')
  final String unitPrice;
  
  @JsonKey(name: 'subtotal')
  final String subtotal;
  
  @JsonKey(name: 'insurance_covered')
  final String insuranceCovered;
  
  @JsonKey(name: 'patient_pays')
  final String patientPays;

  InvoiceItemResponse({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.insuranceCovered,
    required this.patientPays,
  });

  factory InvoiceItemResponse.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceItemResponseToJson(this);

  InvoiceItem map() {
    return InvoiceItem(
      id: id,
      name: name,
      quantity: quantity,
      unitPrice: unitPrice,
      subtotal: subtotal,
      insuranceCovered: insuranceCovered,
      patientPays: patientPays,
    );
  }
}

@JsonSerializable()
class PaymentTransactionResponse {
  @JsonKey(name: 'payment_transactions_id')
  final String id;
  
  @JsonKey(name: 'transaction_code')
  final String code;
  
  @JsonKey(name: 'payment_method')
  final String method;
  
  @JsonKey(name: 'amount')
  final String amount;
  
  @JsonKey(name: 'status')
  final String status;
  
  @JsonKey(name: 'paid_at')
  final String? paidAt;

  PaymentTransactionResponse({
    required this.id,
    required this.code,
    required this.method,
    required this.amount,
    required this.status,
    this.paidAt,
  });

  factory PaymentTransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentTransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentTransactionResponseToJson(this);

  PaymentTransaction map() {
    return PaymentTransaction(
      id: id,
      code: code,
      method: method,
      amount: amount,
      status: status,
      paidAt: paidAt != null ? DateTime.tryParse(paidAt!) : null,
    );
  }
}
