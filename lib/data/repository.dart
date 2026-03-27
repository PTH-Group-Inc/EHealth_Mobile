import 'package:dartz/dartz.dart';
import 'network/dio/failure.dart';
import '../domain/medical_facility.dart';
import '../domain/user_profile.dart';
import '../domain/specialty.dart';

abstract class Repository {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Either<Failure, Map<String, dynamic>>> autoLogin();
  Future<void> logout();
  Future<bool> hasToken();
  Future<String?> getStoredUserName();
  Future<void> updateStoredUserName(String name);
  Future<Either<Failure, List<MedicalFacility>>> getFacilities();
  Future<Either<Failure, UserProfile>> getProfile();
  Future<Either<Failure, UserProfile>> updateProfile(Map<String, dynamic> data);
  Future<Either<Failure, void>> changePassword(
      String userId, String oldPassword, String newPassword);
  Future<Either<Failure, List<Specialty>>> getSpecialties();
}
