import 'package:dartz/dartz.dart';
import 'network/dio/failure.dart';
import '../domain/branch.dart';
import '../domain/user_profile.dart';
import '../domain/specialty.dart';
import '../domain/department.dart';
import '../domain/notification_item.dart';
import '../domain/doctor.dart';
import '../domain/doctor_detail.dart';

abstract class Repository {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> loginPhone(String phone, String password);
  Future<Either<Failure, void>> registerPhone(
      String phone, String password, String name);
  Future<Either<Failure, Map<String, dynamic>>> autoLogin();
  Future<Either<Failure, Map<String, dynamic>>> refreshToken();
  Future<void> logout();
  Future<bool> hasToken();
  Future<String?> getStoredUserName();
  Future<void> updateStoredUserName(String name);
  Future<Either<Failure, List<Branch>>> getBranches();
  Future<Either<Failure, Department>> getDepartmentDetail(String id);

  Future<Either<Failure, UserProfile>> getProfile();
  Future<Either<Failure, UserProfile>> updateProfile(Map<String, dynamic> data);
  Future<Either<Failure, void>> changePassword(
      String oldPassword, String newPassword);
  Future<Either<Failure, List<Specialty>>> getSpecialties();
  Future<Either<Failure, List<Doctor>>> getActiveDoctors();
  Future<Either<Failure, DoctorDetail>> getDoctorDetail(String userId);
  Future<Either<Failure, List<Department>>> getDepartments({
    String? branchId,
    String? search,
    int? page,
    int? limit,
  });

  Future<Either<Failure, List<NotificationItem>>> getNotifications({
    int? page,
    int? limit,
  });
  Future<Either<Failure, void>> readAllNotifications();
  Future<Either<Failure, void>> readNotification(String id);
}
