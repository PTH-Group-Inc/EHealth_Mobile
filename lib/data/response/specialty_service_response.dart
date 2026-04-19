import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/domain/specialty_service.dart';

part 'specialty_service_response.g.dart';

@JsonSerializable()
class SpecialtyServiceResponse {
  @JsonKey(name: 'specialty_id')
  final String? specialtyId;
  @JsonKey(name: 'service_id')
  final String? serviceId;
  @JsonKey(name: 'facility_service_id')
  final String? facilityServiceId;
  @JsonKey(name: 'facility_services_id')
  final String? facilityServicesId;
  @JsonKey(name: 'service_code')
  final String? serviceCode;
  @JsonKey(name: 'service_name')
  final String? serviceName;
  @JsonKey(name: 'service_group')
  final String? serviceGroup;
  @JsonKey(name: 'service_type')
  final String? serviceType;
  @JsonKey(name: 'base_price')
  final String? basePrice;
  @JsonKey(name: 'insurance_price')
  final String? insurancePrice;
  @JsonKey(name: 'vip_price')
  final String? vipPrice;

  SpecialtyServiceResponse({
    this.specialtyId,
    this.serviceId,
    this.facilityServiceId,
    this.facilityServicesId,
    this.serviceCode,
    this.serviceName,
    this.serviceGroup,
    this.serviceType,
    this.basePrice,
    this.insurancePrice,
    this.vipPrice,
  });

  factory SpecialtyServiceResponse.fromJson(Map<String, dynamic> json) =>
      _$SpecialtyServiceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialtyServiceResponseToJson(this);

  SpecialtyService map() {
    return SpecialtyService(
      specialtyId: specialtyId ?? "",
      facilityServiceId: facilityServiceId ?? facilityServicesId ?? serviceId ?? "",
      serviceCode: serviceCode ?? "",
      serviceName: serviceName ?? "",
      serviceGroup: serviceGroup,
      basePrice: basePrice ?? "0",
      insurancePrice: insurancePrice,
      vipPrice: vipPrice,
    );
  }
}
