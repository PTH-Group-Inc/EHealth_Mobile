// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'link_account_request.g.dart';

@JsonSerializable()
class LinkAccountRequest {
  final String account_id;

  LinkAccountRequest({required this.account_id});

  factory LinkAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$LinkAccountRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LinkAccountRequestToJson(this);
}
