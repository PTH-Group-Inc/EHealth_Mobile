import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/domain/pre_booking.dart';

part 'payment_status_response.g.dart';

@JsonSerializable()
class PaymentStatusResponse {
  @JsonKey(name: 'payment_status')
  final String? paymentStatus;
  @JsonKey(name: 'appointment_status')
  final String? appointmentStatus;
  @JsonKey(name: 'invoice_status')
  final String? invoiceStatus;

  PaymentStatusResponse({
    this.paymentStatus,
    this.appointmentStatus,
    this.invoiceStatus,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentStatusResponseToJson(this);

  PaymentStatusEntity map() {
    return PaymentStatusEntity(
      isPaid: paymentStatus == 'PAID',
      appointmentStatus: appointmentStatus ?? '',
      invoiceStatus: invoiceStatus ?? '',
    );
  }
}
