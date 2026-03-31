class FacilityService {
  final String id;
  final String facilityId;
  final String serviceId;
  final String departmentId;
  final String basePrice;
  final String? insurancePrice;
  final String? vipPrice;
  final int estimatedDurationMinutes;
  final String serviceCode;
  final String serviceName;
  final String? serviceGroup;

  FacilityService({
    required this.id,
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
}
