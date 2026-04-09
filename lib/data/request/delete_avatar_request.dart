import 'package:json_annotation/json_annotation.dart';

part 'delete_avatar_request.g.dart';

@JsonSerializable()
class DeleteAvatarRequest {
  @JsonKey(name: 'public_id')
  final String publicId;

  DeleteAvatarRequest({required this.publicId});

  factory DeleteAvatarRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteAvatarRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteAvatarRequestToJson(this);
}
