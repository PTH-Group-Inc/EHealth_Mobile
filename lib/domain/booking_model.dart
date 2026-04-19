import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel {
  final String patientId;
  final String patientName;
  final String? patientAvatar;
  final String? branchId;
  final String? branchName;
  final String? facilityId;
  final String? departmentId;
  final String? departmentName;

  BookingModel({
    required this.patientId,
    required this.patientName,
    this.patientAvatar,
    this.branchId,
    this.branchName,
    this.facilityId,
    this.departmentId,
    this.departmentName,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  BookingModel copyWith({
    String? patientId,
    String? patientName,
    String? patientAvatar,
    String? branchId,
    String? branchName,
    String? facilityId,
    String? departmentId,
    String? departmentName,
  }) {
    return BookingModel(
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientAvatar: patientAvatar ?? this.patientAvatar,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      facilityId: facilityId ?? this.facilityId,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
    );
  }
}
