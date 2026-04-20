// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentStatusResponse _$PaymentStatusResponseFromJson(
  Map<String, dynamic> json,
) => PaymentStatusResponse(
  isPaid: json['isPaid'] as bool,
  appointmentStatus: json['appointment_status'] as String,
  invoiceStatus: json['invoice_status'] as String,
);

Map<String, dynamic> _$PaymentStatusResponseToJson(
  PaymentStatusResponse instance,
) => <String, dynamic>{
  'isPaid': instance.isPaid,
  'appointment_status': instance.appointmentStatus,
  'invoice_status': instance.invoiceStatus,
};
