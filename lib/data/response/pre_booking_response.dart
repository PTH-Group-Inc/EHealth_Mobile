import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/domain/pre_booking.dart';

part 'pre_booking_response.g.dart';

@JsonSerializable()
class AppointmentPreBookResponse {
  @JsonKey(name: 'appointments_id')
  final String appointmentsId;
  final String status;

  AppointmentPreBookResponse({
    required this.appointmentsId,
    required this.status,
  });

  factory AppointmentPreBookResponse.fromJson(Map<String, dynamic> json) =>
      _$AppointmentPreBookResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentPreBookResponseToJson(this);
}

@JsonSerializable()
class PaymentOrderPreBookResponse {
  final String amount;
  @JsonKey(name: 'qr_code_url')
  final String? qrCodeUrl;
  
  // Just in case backend decides to send base64 image too later.
  @JsonKey(name: 'qr_string')
  final String? qrString;

  PaymentOrderPreBookResponse({
    required this.amount,
    this.qrCodeUrl,
    this.qrString,
  });

  factory PaymentOrderPreBookResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentOrderPreBookResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentOrderPreBookResponseToJson(this);
}

@JsonSerializable()
class PreBookingResponse {
  final AppointmentPreBookResponse appointment;
  
  @JsonKey(name: 'invoice_id')
  final String invoiceId;
  
  @JsonKey(name: 'payment_order')
  final PaymentOrderPreBookResponse paymentOrder;

  PreBookingResponse({
    required this.appointment,
    required this.invoiceId,
    required this.paymentOrder,
  });

  factory PreBookingResponse.fromJson(Map<String, dynamic> json) =>
      _$PreBookingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PreBookingResponseToJson(this);

  PreBookingEntity map() {
    return PreBookingEntity(
      appointmentId: appointment.appointmentsId,
      status: appointment.status,
      invoiceId: invoiceId,
      totalAmount: double.tryParse(paymentOrder.amount) ?? 0.0,
      qrTemplateData: paymentOrder.qrCodeUrl ?? '',
      qrString: paymentOrder.qrString ?? '',
    );
  }
}
