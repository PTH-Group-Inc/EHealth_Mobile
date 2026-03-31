import 'package:json_annotation/json_annotation.dart';
import '../../domain/facility_service.dart';

part 'facility_service_response.g.dart';

@JsonSerializable()
class FacilityServiceResponse {
  @JsonKey(name: 'facility_services_id')
  final String facilityServicesId;
  
  @JsonKey(name: 'facility_id')
  final String facilityId;
  
  @JsonKey(name: 'service_id')
  final String serviceId;
  
  @JsonKey(name: 'department_id')
  final String departmentId;
  
  @JsonKey(name: 'base_price')
  final String basePrice;
  
  @JsonKey(name: 'insurance_price')
  final String? insurancePrice;
  
  @JsonKey(name: 'vip_price')
  final String? vipPrice;
  
  @JsonKey(name: 'estimated_duration_minutes')
  final int estimatedDurationMinutes;
  
  @JsonKey(name: 'service_code')
  final String serviceCode;
  
  @JsonKey(name: 'service_name')
  final String serviceName;
  
  @JsonKey(name: 'service_group')
  final String? serviceGroup;

  FacilityServiceResponse({
    required this.facilityServicesId,
    required this.facilityId,
    required this.serviceId,
    required this.departmentId,
    required this.basePrice,
    this.insurancePrice,
    this.vipPrice,
    required this.estimatedDurationMinutes,
    required this.serviceCode,
    required this.serviceName,
    this.serviceGroup,
  });

  factory FacilityServiceResponse.fromJson(Map<String, dynamic> json) =>
      _$FacilityServiceResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FacilityServiceResponseToJson(this);

  FacilityService map() {
    return FacilityService(
      id: facilityServicesId,
      facilityId: facilityId,
      serviceId: serviceId,
      departmentId: departmentId,
      basePrice: basePrice,
      insurancePrice: insurancePrice,
      vipPrice: vipPrice,
      estimatedDurationMinutes: estimatedDurationMinutes,
      serviceCode: serviceCode,
      serviceName: serviceName,
      serviceGroup: serviceGroup,
    );
  }
}
