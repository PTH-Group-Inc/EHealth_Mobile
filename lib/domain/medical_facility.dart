class MedicalFacility {
  final String? id;
  final String? code;
  final String? name;
  final String? taxCode;
  final String? email;
  final String? phone;
  final String? website;
  final String? headquartersAddress;
  final String? logoUrl;
  final String? status;

  MedicalFacility({
    this.id,
    this.code,
    this.name,
    this.taxCode,
    this.email,
    this.phone,
    this.website,
    this.headquartersAddress,
    this.logoUrl,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'facilities_id': id,
      'code': code,
      'name': name,
      'tax_code': taxCode,
      'email': email,
      'phone': phone,
      'website': website,
      'headquarters_address': headquartersAddress,
      'logo_url': logoUrl,
      'status': status,
    };
  }
}
