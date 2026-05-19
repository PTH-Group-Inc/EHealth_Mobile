// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_booking_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentOrderPreBookResponse _$PaymentOrderPreBookResponseFromJson(
  Map<String, dynamic> json,
) => PaymentOrderPreBookResponse(
  amount: _amountFromJson(json['amount']),
  qrCodeUrl: json['qr_code_url'] as String?,
  qrString: json['qr_string'] as String?,
);

Map<String, dynamic> _$PaymentOrderPreBookResponseToJson(
  PaymentOrderPreBookResponse instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'qr_code_url': instance.qrCodeUrl,
  'qr_string': instance.qrString,
};

DepositInvoiceResponse _$DepositInvoiceResponseFromJson(
  Map<String, dynamic> json,
) => DepositInvoiceResponse(
  invoiceId: json['invoice_id'] as String,
  depositAmount: _amountFromJson(json['deposit_amount']),
);

Map<String, dynamic> _$DepositInvoiceResponseToJson(
  DepositInvoiceResponse instance,
) => <String, dynamic>{
  'invoice_id': instance.invoiceId,
  'deposit_amount': instance.depositAmount,
};

PreBookingResponse _$PreBookingResponseFromJson(Map<String, dynamic> json) =>
    PreBookingResponse(
      appointmentsId: json['appointments_id'] as String,
      status: json['status'] as String,
      depositInvoice: DepositInvoiceResponse.fromJson(
        json['deposit_invoice'] as Map<String, dynamic>,
      ),
      paymentOrder: PaymentOrderPreBookResponse.fromJson(
        json['payment_order'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$PreBookingResponseToJson(PreBookingResponse instance) =>
    <String, dynamic>{
      'appointments_id': instance.appointmentsId,
      'status': instance.status,
      'deposit_invoice': instance.depositInvoice,
      'payment_order': instance.paymentOrder,
    };
