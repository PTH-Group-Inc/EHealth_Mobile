class DoctorService {
  final String doctorId;
  final String? doctorName;
  final String? doctorAvatar;
  final String facilityServiceId;
  final bool isPrimary;
  final String serviceCode;
  final String serviceName;
  final String? serviceGroup;
  final String basePrice;
  final String? insurancePrice;
  final String? vipPrice;

  DoctorService({
    required this.doctorId,
    this.doctorName,
    this.doctorAvatar,
    required this.facilityServiceId,
    required this.isPrimary,
    required this.serviceCode,
    required this.serviceName,
    this.serviceGroup,
    required this.basePrice,
    this.insurancePrice,
    this.vipPrice,
  });
}
