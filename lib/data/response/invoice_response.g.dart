// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceResponse _$InvoiceResponseFromJson(Map<String, dynamic> json) =>
    InvoiceResponse(
      id: json['invoices_id'] as String,
      code: json['invoice_code'] as String,
      patientId: json['patient_id'] as String,
      encounterId: json['encounter_id'] as String,
      facilityId: json['facility_id'] as String,
      totalAmount: json['total_amount'] as String,
      discountAmount: json['discount_amount'] as String,
      insuranceAmount: json['insurance_amount'] as String,
      netAmount: json['net_amount'] as String,
      paidAmount: json['paid_amount'] as String,
      status: json['status'] as String,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => InvoiceItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      payments: (json['payments'] as List<dynamic>?)
          ?.map(
            (e) =>
                PaymentTransactionResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$InvoiceResponseToJson(InvoiceResponse instance) =>
    <String, dynamic>{
      'invoices_id': instance.id,
      'invoice_code': instance.code,
      'patient_id': instance.patientId,
      'encounter_id': instance.encounterId,
      'facility_id': instance.facilityId,
      'total_amount': instance.totalAmount,
      'discount_amount': instance.discountAmount,
      'insurance_amount': instance.insuranceAmount,
      'net_amount': instance.netAmount,
      'paid_amount': instance.paidAmount,
      'status': instance.status,
      'items': instance.items,
      'payments': instance.payments,
      'created_at': instance.createdAt,
    };

InvoiceItemResponse _$InvoiceItemResponseFromJson(Map<String, dynamic> json) =>
    InvoiceItemResponse(
      id: json['invoice_details_id'] as String,
      name: json['item_name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: json['unit_price'] as String,
      subtotal: json['subtotal'] as String,
      insuranceCovered: json['insurance_covered'] as String,
      patientPays: json['patient_pays'] as String,
    );

Map<String, dynamic> _$InvoiceItemResponseToJson(
  InvoiceItemResponse instance,
) => <String, dynamic>{
  'invoice_details_id': instance.id,
  'item_name': instance.name,
  'quantity': instance.quantity,
  'unit_price': instance.unitPrice,
  'subtotal': instance.subtotal,
  'insurance_covered': instance.insuranceCovered,
  'patient_pays': instance.patientPays,
};

PaymentTransactionResponse _$PaymentTransactionResponseFromJson(
  Map<String, dynamic> json,
) => PaymentTransactionResponse(
  id: json['payment_transactions_id'] as String,
  code: json['transaction_code'] as String,
  method: json['payment_method'] as String,
  amount: json['amount'] as String,
  status: json['status'] as String,
  paidAt: json['paid_at'] as String?,
);

Map<String, dynamic> _$PaymentTransactionResponseToJson(
  PaymentTransactionResponse instance,
) => <String, dynamic>{
  'payment_transactions_id': instance.id,
  'transaction_code': instance.code,
  'payment_method': instance.method,
  'amount': instance.amount,
  'status': instance.status,
  'paid_at': instance.paidAt,
};
