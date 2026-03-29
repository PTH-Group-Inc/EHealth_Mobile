import 'package:json_annotation/json_annotation.dart';
import '../../domain/branch.dart';

part 'branch_response.g.dart';

@JsonSerializable()
class BranchResponse {
  @JsonKey(name: 'branches_id')
  final String? branchesId;
  @JsonKey(name: 'facility_id')
  final String? facilityId;
  final String? code;
  final String? name;
  final String? address;
  final String? phone;
  final String? status;
  @JsonKey(name: 'established_date')
  final String? establishedDate;
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;
  @JsonKey(name: 'facility_name')
  final String? facilityName;
  @JsonKey(name: 'logo_url')
  final String? logoUrl;

  BranchResponse({
    this.branchesId,
    this.facilityId,
    this.code,
    this.name,
    this.address,
    this.phone,
    this.status,
    this.establishedDate,
    this.deletedAt,
    this.facilityName,
    this.logoUrl,
  });

  factory BranchResponse.fromJson(Map<String, dynamic> json) =>
      _$BranchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BranchResponseToJson(this);

  Branch map() {
    return Branch(
      id: branchesId,
      facilityId: facilityId,
      code: code,
      name: name,
      address: address,
      phone: phone,
      status: status,
      establishedDate: establishedDate,
      deletedAt: deletedAt,
      facilityName: facilityName,
      logoUrl: logoUrl,
    );
  }
}
