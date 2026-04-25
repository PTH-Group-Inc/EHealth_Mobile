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

  Patient copyWith({
    String? id,
    String? patientCode,
    String? accountId,
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? phoneNumber,
    String? email,
    String? idCardNumber,
    String? address,
    String? emergencyContactName,
    String? emergencyContactPhone,
    bool? hasInsurance,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? relationship,
    bool? isDefault,
    List<Avatar>? avatarUrl,
    String? accountEmail,
    String? accountPhone,
  }) {
    return Patient(
      id: id ?? this.id,
      patientCode: patientCode ?? this.patientCode,
      accountId: accountId ?? this.accountId,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      idCardNumber: idCardNumber ?? this.idCardNumber,
      address: address ?? this.address,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      hasInsurance: hasInsurance ?? this.hasInsurance,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      relationship: relationship ?? this.relationship,
      isDefault: isDefault ?? this.isDefault,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      accountEmail: accountEmail ?? this.accountEmail,
      accountPhone: accountPhone ?? this.accountPhone,
    );
  }
}
