import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/domain/pre_booking.dart';

part 'pre_booking_response.g.dart';

double? _amountFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

@JsonSerializable()
class PaymentOrderPreBookResponse {
  @JsonKey(fromJson: _amountFromJson)
  final double? amount;
  @JsonKey(name: 'qr_code_url')
  final String? qrCodeUrl;
  @JsonKey(name: 'qr_string')
  final String? qrString;

  PaymentOrderPreBookResponse({
    this.amount,
    this.qrCodeUrl,
    this.qrString,
  });

  factory PaymentOrderPreBookResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentOrderPreBookResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentOrderPreBookResponseToJson(this);
}

@JsonSerializable()
class DepositInvoiceResponse {
  @JsonKey(name: 'invoice_id')
  final String invoiceId;
  @JsonKey(name: 'deposit_amount', fromJson: _amountFromJson)
  final double? depositAmount;

  DepositInvoiceResponse({required this.invoiceId, this.depositAmount});

  factory DepositInvoiceResponse.fromJson(Map<String, dynamic> json) =>
      _$DepositInvoiceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DepositInvoiceResponseToJson(this);
}

@JsonSerializable()
class PreBookingResponse {
  @JsonKey(name: 'appointments_id')
  final String appointmentsId;
  final String status;

  @JsonKey(name: 'deposit_invoice')
  final DepositInvoiceResponse depositInvoice;

  @JsonKey(name: 'payment_order')
  final PaymentOrderPreBookResponse paymentOrder;

  PreBookingResponse({
    required this.appointmentsId,
    required this.status,
    required this.depositInvoice,
    required this.paymentOrder,
  });

  factory PreBookingResponse.fromJson(Map<String, dynamic> json) =>
      _$PreBookingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PreBookingResponseToJson(this);

  PreBookingEntity map() {
    return PreBookingEntity(
      appointmentId: appointmentsId,
      status: status,
      invoiceId: depositInvoice.invoiceId,
      totalAmount:
          paymentOrder.amount ?? (depositInvoice.depositAmount ?? 0.0),
      qrTemplateData: paymentOrder.qrCodeUrl ?? '',
      qrString: paymentOrder.qrString ?? '',
    );
  }
}
