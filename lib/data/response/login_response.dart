import 'package:json_annotation/json_annotation.dart';
import 'user_response.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final UserResponse? user;

  LoginResponse({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
