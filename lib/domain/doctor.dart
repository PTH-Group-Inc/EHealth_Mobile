import 'package:e_health/domain/avatar.dart';

class Doctor {
  final String? id; // profileId
  final String? serverId; // doctors_id
  final String? userId;
  final String? title;
  final String? fullName;
  final String? specialtyName;
  final String? specialtyId;
  final List<Avatar> avatarUrl;
  final String? phone;
  final String? consultationFee;
  final String? facilityName;

  const Doctor({
    this.id,
    this.serverId,
    this.userId,
    this.title,
    this.fullName,
    this.specialtyName,
    this.specialtyId,
    this.avatarUrl = const [],
    this.phone,
    this.consultationFee,
    this.facilityName,
  });
}
