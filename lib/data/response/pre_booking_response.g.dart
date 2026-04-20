// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_booking_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentPreBookResponse _$AppointmentPreBookResponseFromJson(
  Map<String, dynamic> json,
) => AppointmentPreBookResponse(
  appointmentsId: json['appointments_id'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$AppointmentPreBookResponseToJson(
  AppointmentPreBookResponse instance,
) => <String, dynamic>{
  'appointments_id': instance.appointmentsId,
  'status': instance.status,
};

PaymentOrderPreBookResponse _$PaymentOrderPreBookResponseFromJson(
  Map<String, dynamic> json,
) => PaymentOrderPreBookResponse(
  amount: json['amount'] as String,
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

PreBookingResponse _$PreBookingResponseFromJson(Map<String, dynamic> json) =>
    PreBookingResponse(
      appointment: AppointmentPreBookResponse.fromJson(
        json['appointment'] as Map<String, dynamic>,
      ),
      invoiceId: json['invoice_id'] as String,
      paymentOrder: PaymentOrderPreBookResponse.fromJson(
        json['payment_order'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$PreBookingResponseToJson(PreBookingResponse instance) =>
    <String, dynamic>{
      'appointment': instance.appointment,
      'invoice_id': instance.invoiceId,
      'payment_order': instance.paymentOrder,
    };
