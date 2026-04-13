import 'package:json_annotation/json_annotation.dart';

part 'cancel_appointment_request.g.dart';

@JsonSerializable()
class CancelAppointmentRequest {
  @JsonKey(name: "cancellation_reason")
  final String cancellationReason;

  CancelAppointmentRequest({required this.cancellationReason});

  factory CancelAppointmentRequest.fromJson(Map<String, dynamic> json) =>
      _$CancelAppointmentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CancelAppointmentRequestToJson(this);
}
