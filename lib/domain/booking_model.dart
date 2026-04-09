class BookingModel {
  final String patientId;
  final String patientName;
  final String? branchId;
  final String? branchName;
  final String? facilityId;
  final String? departmentId;
  final String? departmentName;

  BookingModel({
    required this.patientId,
    required this.patientName,
    this.branchId,
    this.branchName,
    this.facilityId,
    this.departmentId,
    this.departmentName,
  });

  BookingModel copyWith({
    String? patientId,
    String? patientName,
    String? branchId,
    String? branchName,
    String? facilityId,
    String? departmentId,
    String? departmentName,
  }) {
    return BookingModel(
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      facilityId: facilityId ?? this.facilityId,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
    );
  }
}
