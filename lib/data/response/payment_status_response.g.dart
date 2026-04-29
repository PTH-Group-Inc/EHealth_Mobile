// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentStatusResponse _$PaymentStatusResponseFromJson(
  Map<String, dynamic> json,
) => PaymentStatusResponse(
  paymentStatus: json['payment_status'] as String?,
  appointmentStatus: json['appointment_status'] as String?,
  invoiceStatus: json['invoice_status'] as String?,
);

Map<String, dynamic> _$PaymentStatusResponseToJson(
  PaymentStatusResponse instance,
) => <String, dynamic>{
  'payment_status': instance.paymentStatus,
  'appointment_status': instance.appointmentStatus,
  'invoice_status': instance.invoiceStatus,
};
