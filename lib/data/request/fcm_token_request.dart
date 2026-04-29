// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'fcm_token_request.g.dart';

@JsonSerializable()
class FcmTokenRequest {
  final String fcm_token;
  final String? device_name;
  final String? userId;

  FcmTokenRequest({
    required this.fcm_token,
    this.device_name,
    this.userId,
  });

  factory FcmTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$FcmTokenRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FcmTokenRequestToJson(this);
}
