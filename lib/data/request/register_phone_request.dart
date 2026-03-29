import 'package:json_annotation/json_annotation.dart';

part 'register_phone_request.g.dart';

@JsonSerializable()
class RegisterPhoneRequest {
  final String phone;
  final String password;
  final String name;

  RegisterPhoneRequest({
    required this.phone,
    required this.password,
    required this.name,
  });

  factory RegisterPhoneRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterPhoneRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterPhoneRequestToJson(this);
}
