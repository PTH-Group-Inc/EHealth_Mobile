class Branch {
  final String? id;
  final String? facilityId;
  final String? code;
  final String? name;
  final String? address;
  final String? phone;
  final String? status;
  final String? establishedDate;
  final String? deletedAt;
  final String? facilityName;

  Branch({
    this.id,
    this.facilityId,
    this.code,
    this.name,
    this.address,
    this.phone,
    this.status,
    this.establishedDate,
    this.deletedAt,
    this.facilityName,
  });

  Map<String, dynamic> toMap() {
    return {
      'branches_id': id,
      'facility_id': facilityId,
      'code': code,
      'name': name,
      'address': address,
      'phone': phone,
      'status': status,
      'established_date': establishedDate,
      'deleted_at': deletedAt,
      'facility_name': facilityName,
    };
  }
}
