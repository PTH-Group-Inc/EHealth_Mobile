import 'package:dartz/dartz.dart';
import 'network/dio/failure.dart';
import '../domain/medical_facility.dart';
import '../domain/user_profile.dart';

abstract class Repository {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<void> logout();
  Future<bool> hasToken();
  Future<String?> getStoredUserName();
  Future<Either<Failure, List<MedicalFacility>>> getFacilities();
  Future<Either<Failure, UserProfile>> getProfile();
}
