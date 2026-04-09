class SpecialtyService {
  final String specialtyId;
  final String facilityServiceId;
  final String serviceCode;
  final String serviceName;
  final String? serviceGroup;
  final String basePrice;
  final String? insurancePrice;
  final String? vipPrice;

  SpecialtyService({
    required this.specialtyId,
    required this.facilityServiceId,
    required this.serviceCode,
    required this.serviceName,
    this.serviceGroup,
    required this.basePrice,
    this.insurancePrice,
    this.vipPrice,
  });
}
