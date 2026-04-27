import 'package:e_health/data/response/avatar_response.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/domain/doctor_service.dart';

part 'doctor_service_response.g.dart';

@JsonSerializable()
class DoctorServiceResponse {
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  @JsonKey(name: 'doctor_name')
  final String? doctorName;
  @JsonKey(name: 'doctor_avatar', fromJson: _parseAvatar)
  final List<AvatarResponse>? doctorAvatar;
  @JsonKey(name: 'facility_service_id')
  final String? facilityServiceId;
  @JsonKey(name: 'is_primary')
  final bool? isPrimary;
  @JsonKey(name: 'service_code')
  final String? serviceCode;
  @JsonKey(name: 'service_name')
  final String? serviceName;
  @JsonKey(name: 'service_group')
  final String? serviceGroup;
  @JsonKey(name: 'base_price')
  final String? basePrice;
  @JsonKey(name: 'insurance_price')
  final String? insurancePrice;
  @JsonKey(name: 'vip_price')
  final String? vipPrice;

  DoctorServiceResponse({
    this.doctorId,
    this.doctorName,
    this.doctorAvatar,
    this.facilityServiceId,
    this.isPrimary,
    this.serviceCode,
    this.serviceName,
    this.serviceGroup,
    this.basePrice,
    this.insurancePrice,
    this.vipPrice,
  });

  factory DoctorServiceResponse.fromJson(Map<String, dynamic> json) =>
      _$DoctorServiceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorServiceResponseToJson(this);

  static List<AvatarResponse>? _parseAvatar(dynamic json) {
    if (json == null) return null;
    if (json is List) {
      return json
          .map((e) => AvatarResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (json is Map) {
      return [AvatarResponse.fromJson(json as Map<String, dynamic>)];
    }
    return null;
  }

  DoctorService map() {
    return DoctorService(
      doctorId: doctorId ?? "",
      doctorName: doctorName,
      doctorAvatar: doctorAvatar?.isNotEmpty == true ? doctorAvatar!.first.url : null,
      facilityServiceId: facilityServiceId ?? "",
      isPrimary: isPrimary ?? false,
      serviceCode: serviceCode ?? "",
      serviceName: serviceName ?? "",
      serviceGroup: serviceGroup,
      basePrice: basePrice ?? "0",
      insurancePrice: insurancePrice,
      vipPrice: vipPrice,
    );
  }
}
