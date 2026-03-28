import 'package:json_annotation/json_annotation.dart';

part 'login_phone_request.g.dart';

@JsonSerializable()
class LoginPhoneRequest {
  final String phone;
  final String password;
  final Map<String, dynamic> clientInfo;

  LoginPhoneRequest({
    required this.phone,
    required this.password,
    required this.clientInfo,
  });

  factory LoginPhoneRequest.fromJson(Map<String, dynamic> json) => _$LoginPhoneRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginPhoneRequestToJson(this);
}
