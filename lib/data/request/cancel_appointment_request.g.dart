// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_appointment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CancelAppointmentRequest _$CancelAppointmentRequestFromJson(
  Map<String, dynamic> json,
) => CancelAppointmentRequest(
  cancellationReason: json['cancellation_reason'] as String,
);

Map<String, dynamic> _$CancelAppointmentRequestToJson(
  CancelAppointmentRequest instance,
) => <String, dynamic>{'cancellation_reason': instance.cancellationReason};
