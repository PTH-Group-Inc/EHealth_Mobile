// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regenerate_qr_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegenerateQrResponse _$RegenerateQrResponseFromJson(
  Map<String, dynamic> json,
) => RegenerateQrResponse(
  appointmentId: json['appointment_id'] as String,
  invoiceId: json['invoice_id'] as String,
  amount: (json['amount'] as num).toDouble(),
  qrTemplateData: json['qrTemplateData'] as String,
);

Map<String, dynamic> _$RegenerateQrResponseToJson(
  RegenerateQrResponse instance,
) => <String, dynamic>{
  'appointment_id': instance.appointmentId,
  'invoice_id': instance.invoiceId,
  'amount': instance.amount,
  'qrTemplateData': instance.qrTemplateData,
};
