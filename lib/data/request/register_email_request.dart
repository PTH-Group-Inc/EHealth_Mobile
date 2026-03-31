import 'package:json_annotation/json_annotation.dart';

part 'register_email_request.g.dart';

@JsonSerializable()
class RegisterEmailRequest {
  final String email;
  final String password;
  final String name;

  RegisterEmailRequest({
    required this.email,
    required this.password,
    required this.name,
  });

  factory RegisterEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterEmailRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterEmailRequestToJson(this);
}
