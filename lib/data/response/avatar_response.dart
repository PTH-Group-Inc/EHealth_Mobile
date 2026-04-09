import 'package:e_health/domain/avatar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'avatar_response.g.dart';

@JsonSerializable()
class AvatarResponse {
  final String? url;
  @JsonKey(name: 'public_id')
  final String? publicId;
  @JsonKey(name: 'uploaded_at')
  final String? uploadedAt;

  AvatarResponse({this.url, this.publicId, this.uploadedAt});

  factory AvatarResponse.fromJson(Map<String, dynamic> json) =>
      _$AvatarResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AvatarResponseToJson(this);

  Avatar map() => Avatar(
        url: url ?? "",
        publicId: publicId ?? "",
        uploadedAt: uploadedAt != null ? DateTime.tryParse(uploadedAt!) : null,
      );
}
