import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:e_health/app/helper/helper_rest_response.dart';
import 'package:e_health/domain/branch.dart';
import 'package:e_health/domain/department.dart';
import 'package:e_health/domain/doctor.dart';
import 'package:e_health/domain/doctor_detail.dart';
import 'package:e_health/domain/notification_item.dart';
import 'package:e_health/domain/specialty.dart';
import 'package:e_health/domain/user_profile.dart';
import 'package:e_health/domain/patient.dart';
import 'package:e_health/domain/medical_history.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'repository.dart';
import 'network/core_service.dart';
import 'request/login_request.dart';
import 'request/login_phone_request.dart';
import 'request/register_phone_request.dart';
import 'request/register_email_request.dart';
import 'request/verify_email_request.dart';
import 'request/edit_profile_request.dart';
import 'request/change_password_request.dart';
import 'request/logout_request.dart';
import 'request/refresh_token_request.dart';
import 'request/update_patient_request.dart';
import 'request/link_account_request.dart';
import 'network/dio/failure.dart';
import 'network/dio/error_handler.dart';
import 'response/doctor_response.dart';
import 'response/doctor_detail_response.dart';

@Singleton(as: Repository)
class RepositoryImplement implements Repository {
  final CoreService _coreService;
  final _storage = const FlutterSecureStorage();

  RepositoryImplement(this._coreService);

  @override
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final request = ChangePasswordRequest(
        old_password: oldPassword,
        new_password: newPassword,
      );
      final response = await _coreService.changePassword(request);
      return HelperRestResponse.handleRestResponseSuccess(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, Department>> getDepartmentDetail(String id) async {
    try {
      final response = await _coreService.getDepartmentDetail(id);
      return HelperRestResponse.handleRestResponse(
        response,
        (data) => data.map(),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final response = await _coreService.getProfile();
      return HelperRestResponse.handleRestResponse(
        response,
        (data) => data.map(),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final request = EditProfileRequest.fromJson(data);
      final response = await _coreService.updateProfile(request);
      return HelperRestResponse.handleRestResponse(
        response,
        (data) => data.map(),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final clientInfo = await _getUserClientInfo();
    final request = LoginRequest(
      email: email,
      password: password,
      clientInfo: clientInfo,
    );

    try {
      final response = await _coreService.login(request);
      if (response.success == true && response.data != null) {
        final data = response.data!;
        await _storage.write(key: 'accessToken', value: data.accessToken);
        await _storage.write(key: 'refreshToken', value: data.refreshToken);
        await _storage.write(key: 'email', value: email);
        await _storage.write(key: 'password', value: password);
        if (data.user?.name != null) {
          await _storage.write(key: 'userName', value: data.user!.name);
        }
        return data.user?.toMap() ?? {};
      } else {
        throw Failure(response.message ?? "Đăng nhập thất bại");
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw ErrorHandler.handle(e).failure;
    }
  }

  @override
  Future<Map<String, dynamic>> loginPhone(String phone, String password) async {
    final clientInfo = await _getUserClientInfo();
    final request = LoginPhoneRequest(
      phone: phone,
      password: password,
      clientInfo: clientInfo,
    );

    try {
      final response = await _coreService.loginPhone(request);
      if (response.success == true && response.data != null) {
        final data = response.data!;
        await _storage.write(key: 'accessToken', value: data.accessToken);
        await _storage.write(key: 'refreshToken', value: data.refreshToken);
        await _storage.write(key: 'phone', value: phone);
        await _storage.write(key: 'password', value: password);
        if (data.user?.name != null) {
          await _storage.write(key: 'userName', value: data.user!.name);
        }
        return data.user?.toMap() ?? {};
      } else {
        throw Failure(response.message ?? "Đăng nhập thất bại");
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw ErrorHandler.handle(e).failure;
    }
  }

  @override
  Future<Either<Failure, void>> registerPhone(
    String phone,
    String password,
    String name,
  ) async {
    try {
      final request = RegisterPhoneRequest(
        phone: phone,
        password: password,
        name: name,
      );
      final response = await _coreService.registerPhone(request);
      return HelperRestResponse.handleRestResponseSuccess(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> registerEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      final request = RegisterEmailRequest(
        email: email,
        password: password,
        name: name,
      );
      final response = await _coreService.registerEmail(request);
      return HelperRestResponse.handleRestResponseSuccess(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String email, String code) async {
    try {
      final request = VerifyEmailRequest(
        email: email,
        code: code,
      );
      final response = await _coreService.verifyEmail(request);
      return HelperRestResponse.handleRestResponseSuccess(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<void> logout() async {
    try {
      final refreshToken = await _storage.read(key: 'refreshToken');
      if (refreshToken != null) {
        await _coreService.logout(LogoutRequest(refreshToken: refreshToken));
      }
    } catch (e) {
      // Logic logout still proceeds even if API fails to ensure local tokens are cleared
    } finally {
      await _storage.delete(key: 'accessToken');
      await _storage.delete(key: 'refreshToken');
      await _storage.delete(key: 'userName');
      await _storage.delete(key: 'email');
      await _storage.delete(key: 'password');
    }
  }

  @override
  Future<bool> hasToken() async {
    final token = await _storage.read(key: 'refreshToken');
    return token != null;
  }

  @override
  Future<String?> getStoredUserName() async {
    return await _storage.read(key: 'userName');
  }

  @override
  Future<void> updateStoredUserName(String name) async {
    await _storage.write(key: 'userName', value: name);
  }

  @override
  Future<Either<Failure, List<Branch>>> getBranches() async {
    try {
      final response = await _coreService.getBranches();
      return HelperRestResponse.handlePageResponse(
        response,
        (data) => data.map(),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> autoLogin() async {
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');

    if (email == null || password == null) {
      return Left(Failure("No saved credentials"));
    }

    try {
      final clientInfo = await _getUserClientInfo();
      final request = LoginRequest(
        email: email,
        password: password,
        clientInfo: clientInfo,
      );
      final response = await _coreService.login(request);

      if (response.success == true && response.data != null) {
        final data = response.data!;
        await _storage.write(key: 'accessToken', value: data.accessToken);
        await _storage.write(key: 'refreshToken', value: data.refreshToken);
        return Right(data.user?.toMap() ?? {});
      } else {
        return Left(Failure(response.message ?? "Auto login failed"));
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> refreshToken() async {
    final refreshToken = await _storage.read(key: 'refreshToken');

    if (refreshToken == null) {
      return Left(Failure("No refresh token stored"));
    }

    try {
      final request = RefreshTokenRequest(refreshToken: refreshToken);
      final response = await _coreService.refreshToken(request);

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        await _storage.write(key: 'accessToken', value: data.accessToken ?? "");
        await _storage.write(
          key: 'refreshToken',
          value: data.refreshToken ?? "",
        );
        return Right(data.user?.toMap() ?? {});
      } else {
        return Left(Failure(response.message ?? "Token refresh failed"));
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<Specialty>>> getSpecialties() async {
    try {
      final response = await _coreService.getSpecialties();
      return HelperRestResponse.handleDepartmentList(
        response,
        (data) => Specialty(
          id: data.departments_id,
          code: data.code,
          name: data.name,
          description: data.description,
          logoUrl: data.logo_url,
        ),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<Doctor>>> getActiveDoctors() async {
    try {
      final response = await _coreService.getActiveDoctors();
      return HelperRestResponse.handleRestResponseList<Doctor, DoctorResponse>(
        response,
        (data) => data.map(),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, DoctorDetail>> getDoctorDetail(String userId) async {
    try {
      final response = await _coreService.getDoctorDetail(userId);
      return HelperRestResponse.handleRestResponse<
        DoctorDetail,
        DoctorDetailResponse
      >(response, (data) => data.map());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<Department>>> getDepartments({
    String? branchId,
    String? search,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await _coreService.getDepartments(
        branchId: branchId,
        search: search,
        page: page,
        limit: limit,
      );
      return HelperRestResponse.handleDepartmentList(
        response,
        (data) => data.map(),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<NotificationItem>>> getNotifications({
    int? page,
    int? limit,
  }) async {
    try {
      final response = await _coreService.getNotifications(
        page: page,
        limit: limit,
      );
      return HelperRestResponse.handleNotificationList(
        response,
        (data) => data.map(),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> readAllNotifications() async {
    try {
      final response = await _coreService.readAllNotifications();
      return HelperRestResponse.handleRestResponseSuccess(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> readNotification(String id) async {
    try {
      final response = await _coreService.readNotification(id);
      return HelperRestResponse.handleRestResponseSuccess(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<Patient>>> getPatientRecord(String accountId) async {
    try {
      final response = await _coreService.getPatientRecord(accountId);
      return HelperRestResponse.handleRestResponseList(
        response,
        (e) => e.map(),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, Patient>> updatePatientRecord(
    String id,
    UpdatePatientRequest request,
  ) async {
    try {
      final response = await _coreService.updatePatientRecord(id, request);
      return HelperRestResponse.handleRestResponse(response, (p) => p.map());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, Patient>> createPatientRecord(
    UpdatePatientRequest request,
  ) async {
    try {
      final response = await _coreService.createPatientRecord(request);
      return HelperRestResponse.handleRestResponse(response, (p) => p.map());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> linkAccountRecord(
    String id,
    String accountId,
  ) async {
    try {
      final request = LinkAccountRequest(account_id: accountId);
      final response = await _coreService.linkAccountRecord(id, request);
      return HelperRestResponse.handleRestResponseSuccess(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<MedicalHistory>>> getMedicalHistory(
    String patientId,
  ) async {
    try {
      final response = await _coreService.getMedicalHistory(patientId);
      if (response.success) {
        return Right(response.data.data.map((e) => e.map()).toList());
      } else {
        return Left(Failure("Không thể lấy lịch sử khám bệnh"));
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  Future<Map<String, dynamic>> _getUserClientInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    String? deviceId;
    String? deviceName;

    try {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
      deviceName = androidInfo.model;
    } catch (e) {
      deviceId = "unknown_device";
      deviceName = "unknown_model";
    }

    return {"deviceId": deviceId, "deviceName": deviceName};
  }
}
// 