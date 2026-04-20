import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/domain/pre_booking.dart';

part 'regenerate_qr_response.g.dart';

@JsonSerializable()
class RegenerateQrResponse {
  @JsonKey(name: 'appointment_id')
  final String appointmentId;
  @JsonKey(name: 'invoice_id')
  final String invoiceId;
  final double amount;
  final String qrTemplateData;

  RegenerateQrResponse({
    required this.appointmentId,
    required this.invoiceId,
    required this.amount,
    required this.qrTemplateData,
  });

  factory RegenerateQrResponse.fromJson(Map<String, dynamic> json) =>
      _$RegenerateQrResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegenerateQrResponseToJson(this);

  RegenerateQrEntity map() {
    return RegenerateQrEntity(
      appointmentId: appointmentId,
      invoiceId: invoiceId,
      amount: amount,
      qrTemplateData: qrTemplateData,
    );
  }
}
