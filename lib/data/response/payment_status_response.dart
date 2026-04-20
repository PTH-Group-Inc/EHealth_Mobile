import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/domain/pre_booking.dart';

part 'payment_status_response.g.dart';

@JsonSerializable()
class PaymentStatusResponse {
  final bool isPaid;
  @JsonKey(name: 'appointment_status')
  final String appointmentStatus;
  @JsonKey(name: 'invoice_status')
  final String invoiceStatus;

  PaymentStatusResponse({
    required this.isPaid,
    required this.appointmentStatus,
    required this.invoiceStatus,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentStatusResponseToJson(this);

  PaymentStatusEntity map() {
    return PaymentStatusEntity(
      isPaid: isPaid,
      appointmentStatus: appointmentStatus,
      invoiceStatus: invoiceStatus,
    );
  }
}
