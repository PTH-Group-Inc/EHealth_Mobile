import 'package:e_health/domain/avatar.dart';

class Patient {
  final String id;
  final String patientCode;
  final String? accountId;
  final String fullName;
  final DateTime dateOfBirth;
  final String gender;
  final String phoneNumber;
  final String? email;
  final String? idCardNumber;
  final String? address;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final bool hasInsurance;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? relationship;
  final bool isDefault;
  final List<Avatar> avatarUrl;
  final String? accountEmail;
  final String? accountPhone;

  Patient({
    required this.id,
    required this.patientCode,
    this.accountId,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    this.email,
    this.idCardNumber,
    this.address,
    this.emergencyContactName,
    this.emergencyContactPhone,
    required this.hasInsurance,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.relationship,
    this.isDefault = false,
    this.avatarUrl = const [],
    this.accountEmail,
    this.accountPhone,
  });
}
