import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:e_health/app/helper/helper_rest_response.dart';
import 'package:e_health/domain/branch.dart';
import 'package:e_health/domain/department.dart';
import 'package:e_health/domain/doctor.dart';
import 'package:e_health/domain/doctor_detail.dart';
import 'package:e_health/domain/notification_item.dart';
import 'package:e_health/domain/specialty.dart';
import 'package:e_health/domain/avatar.dart';
import 'package:e_health/domain/user_profile.dart';
import 'package:dio/dio.dart';
import 'package:e_health/domain/patient.dart';
import 'package:e_health/domain/medical_history.dart';
import 'package:e_health/domain/shift.dart';
import 'package:e_health/domain/slot.dart';
import 'package:e_health/domain/facility_service.dart';
import 'package:e_health/domain/booked_appointment.dart';
import 'package:e_health/domain/appointment_detail.dart';
import 'package:e_health/domain/doctor_availability.dart';
import 'package:e_health/domain/doctor_service.dart';
import 'package:e_health/data/request/book_patient_appointment_request.dart';
import 'package:e_health/data/request/book_appointment_request.dart';
import 'package:e_health/constant/key_secure_constant.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/data/network/core_service.dart';
import 'package:e_health/data/request/login_request.dart';
import 'package:e_health/data/request/login_phone_request.dart';
import 'package:e_health/data/request/register_phone_request.dart';
import 'package:e_health/data/request/register_email_request.dart';
import 'package:e_health/data/request/verify_email_request.dart';
import 'package:e_health/data/request/edit_profile_request.dart';
import 'package:e_health/data/request/change_password_request.dart';
import 'package:e_health/data/request/logout_request.dart';
import 'package:e_health/data/request/refresh_token_request.dart';
import 'package:e_health/data/request/update_patient_request.dart';
import 'package:e_health/data/request/link_account_request.dart';
import 'package:e_health/data/request/forgot_password_request.dart';
import 'package:e_health/data/request/reset_password_request.dart';
import 'package:e_health/domain/specialty_service.dart';
import 'package:e_health/data/request/delete_avatar_request.dart';
import 'package:e_health/data/network/dio/failure.dart';
import 'package:e_health/data/network/dio/error_handler.dart';
import 'package:e_health/data/response/doctor_detail_response.dart';
import 'package:e_health/data/response/doctor_availability_response.dart';

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
  Future<Either<Failure, List<Specialty>>> getDepartmentSpecialties(
    String id,
  ) async {
    try {
      final response = await _coreService.getDepartmentSpecialties(id);
      return HelperRestResponse.handleRestResponseList(
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
        await _storage.write(
          key: KeySecure.accessToken,
          value: data.accessToken,
        );
        await _storage.write(
          key: KeySecure.refreshToken,
          value: data.refreshToken,
        );
        await _storage.write(key: KeySecure.email, value: email);
        await _storage.write(key: KeySecure.password, value: password);
        if (data.user?.name != null) {
          await _storage.write(key: KeySecure.userName, value: data.user!.name);
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
        await _storage.write(
          key: KeySecure.accessToken,
          value: data.accessToken,
        );
        await _storage.write(
          key: KeySecure.refreshToken,
          value: data.refreshToken,
        );
        await _storage.write(key: KeySecure.phone, value: phone);
        await _storage.write(key: KeySecure.password, value: password);
        if (data.user?.name != null) {
          await _storage.write(key: KeySecure.userName, value: data.user!.name);
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
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      final request = ForgotPasswordRequest(email: email);
      final response = await _coreService.forgotPassword(request);
      return HelperRestResponse.handleRestResponseSuccess(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    String otp,
    String newPassword,
  ) async {
    try {
      final request = ResetPasswordRequest(otp: otp, newPassword: newPassword);
      final response = await _coreService.resetPassword(request);
      return HelperRestResponse.handleRestResponseSuccess(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String email, String code) async {
    try {
      final request = VerifyEmailRequest(email: email, code: code);
      final response = await _coreService.verifyEmail(request);
      return HelperRestResponse.handleRestResponseSuccess(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<void> logout() async {
    try {
      final refreshToken = await _storage.read(key: KeySecure.refreshToken);
      if (refreshToken != null) {
        await _coreService.logout(LogoutRequest(refreshToken: refreshToken));
      }
    } catch (e) {
      // Logic logout still proceeds even if API fails to ensure local tokens are cleared
    } finally {
      await _storage.delete(key: KeySecure.accessToken);
      await _storage.delete(key: KeySecure.refreshToken);
      await _storage.delete(key: KeySecure.userName);
      await _storage.delete(key: KeySecure.email);
      await _storage.delete(key: KeySecure.password);
    }
  }

  @override
  Future<bool> hasToken() async {
    final token = await _storage.read(key: KeySecure.refreshToken);
    return token != null;
  }

  @override
  Future<String?> getStoredUserName() async {
    return await _storage.read(key: KeySecure.userName);
  }

  @override
  Future<void> updateStoredUserName(String name) async {
    await _storage.write(key: KeySecure.userName, value: name);
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
    final email = await _storage.read(key: KeySecure.email);
    final password = await _storage.read(key: KeySecure.password);

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
        await _storage.write(
          key: KeySecure.accessToken,
          value: data.accessToken,
        );
        await _storage.write(
          key: KeySecure.refreshToken,
          value: data.refreshToken,
        );
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
    final refreshToken = await _storage.read(key: KeySecure.refreshToken);

    if (refreshToken == null) {
      return Left(Failure("No refresh token stored"));
    }

    try {
      final request = RefreshTokenRequest(refreshToken: refreshToken);
      final response = await _coreService.refreshToken(request);

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        await _storage.write(
          key: KeySecure.accessToken,
          value: data.accessToken ?? "",
        );
        await _storage.write(
          key: KeySecure.refreshToken,
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
  Future<Either<Failure, List<Doctor>>> getActiveDoctors({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _coreService.getStaff(
        status: "ACTIVE",
        role: "DOCTOR",
        page: page,
        limit: limit,
      );
      if (response.status == 'success' && response.data != null) {
        final doctors =
            response.data!.items?.map((e) => e.map()).toList() ?? [];
        return Right(doctors);
      } else {
        return Left(Failure("Không thể lấy danh sách bác sĩ"));
      }
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
  Future<Either<Failure, Map<String, List<DoctorAvailability>>>>
  getDoctorAvailability({
    required String doctorId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _coreService.getDoctorAvailability(
        doctorId,
        startDate.toIso8601String().split('T')[0],
        endDate.toIso8601String().split('T')[0],
      );
      return HelperRestResponse.handleRestResponseMap<DoctorAvailability>(
        response,
        (e) => DoctorAvailabilityResponse.fromJson(e).map(),
      );
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
  Future<Either<Failure, List<Doctor>>> searchDoctors({
    String? search,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await _coreService.getStaff(
        status: "ACTIVE",
        role: "DOCTOR",
        search: search,
        page: page,
        limit: limit,
      );
      if (response.status == 'success' && response.data != null) {
        final doctors =
            response.data!.items?.map((e) => e.map()).toList() ?? [];
        return Right(doctors);
      } else {
        return Left(Failure("Không thể tìm kiếm bác sĩ"));
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<NotificationItem>>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    final hasTokenLocal = await hasToken();
    if (!hasTokenLocal) {
      return const Right([]);
    }

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
  Future<Either<Failure, List<Patient>>> getPatientRecord(
    String accountId,
  ) async {
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
    String patientId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _coreService.getMedicalHistory(
        patientId,
        page: page,
        limit: limit,
      );
      if (response.success) {
        return Right(response.data.data.map((e) => e.map()).toList());
      } else {
        return Left(Failure("Không thể lấy lịch sử khám bệnh"));
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<Shift>>> getShifts() async {
    try {
      final response = await _coreService.getShifts();
      if (response.isSuccess) {
        return Right(response.data?.map((e) => e.map()).toList() ?? []);
      } else {
        return Left(Failure("Không thể lấy danh sách ca khám"));
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<Slot>>> getSlots(String shiftId) async {
    try {
      final response = await _coreService.getSlots(shiftId: shiftId);
      if (response.isSuccess) {
        return Right(response.data?.map((e) => e.map()).toList() ?? []);
      } else {
        return Left(Failure("Không thể lấy danh sách khung giờ"));
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<FacilityService>>> getFacilityServices(
    String facilityId, {
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _coreService.getFacilityServices(
        facilityId,
        search: search,
        page: page,
        limit: limit,
      );
      return Right(response.data?.map((e) => e.map()).toList() ?? []);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<DoctorService>>> getDoctorServices(
    String doctorId,
  ) async {
    try {
      final response = await _coreService.getDoctorServices(doctorId);
      if (response.success == true) {
        final services = response.data?.map((e) => e.map()).toList() ?? [];
        return Right(services);
      } else {
        return Left(
          Failure(response.message ?? "Lấy danh sách dịch vụ thất bại"),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<SpecialtyService>>> getSpecialtyServices(
    String specialtyId,
  ) async {
    try {
      final response = await _coreService.getSpecialtyServices(specialtyId);
      return HelperRestResponse.handleRestResponseList(
        response,
        (e) => e.map(),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, BookedAppointment>> bookPatientAppointment(
    String patientId,
    BookPatientAppointmentRequest request,
  ) async {
    try {
      final response = await _coreService.bookPatientAppointment(
        patientId,
        request,
      );
      if (response.isSuccess) {
        if (response.data != null) {
          return Right(response.data!.map());
        } else {
          return Left(Failure("Không có dữ liệu phản hồi"));
        }
      } else {
        return Left(Failure(response.message ?? "Lỗi không xác định"));
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, BookedAppointment>> bookAppointment(
    BookAppointmentRequest request,
  ) async {
    try {
      final response = await _coreService.bookAppointment(request);
      if (response.isSuccess) {
        if (response.data != null) {
          return Right(response.data!.map());
        } else {
          return Left(Failure("Không có dữ liệu phản hồi"));
        }
      } else {
        return Left(Failure(response.message ?? "Lỗi không xác định"));
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<BookedAppointment>>> getMyAppointments({
    int page = 1,
    int limit = 20,
  }) async {
    final hasTokenLocal = await hasToken();
    if (!hasTokenLocal) {
      return const Right([]);
    }

    try {
      final response = await _coreService.getMyAppointments(
        page: page,
        limit: limit,
      );
      if (response.success == true) {
        final appointments = response.data?.map((e) => e.map()).toList() ?? [];
        return Right(appointments);
      } else {
        return Left(
          Failure(response.message ?? "Lấy danh sách lịch khám thất bại"),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, AppointmentDetail>> getAppointmentDetail(
    String id,
  ) async {
    try {
      final response = await _coreService.getAppointmentDetail(id);
      if (response.success == true) {
        return Right(response.map());
      } else {
        return Left(
          Failure(response.message ?? "Lấy chi tiết lịch khám thất bại"),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, Avatar>> uploadAvatar(String filePath) async {
    try {
      final file = await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      );
      final response = await _coreService.uploadAvatar(file);
      return HelperRestResponse.handleRestResponse(
        response,
        (data) => data.map(),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteAvatar(String publicId) async {
    try {
      final request = DeleteAvatarRequest(publicId: publicId);
      final response = await _coreService.deleteAvatar(request);
      return HelperRestResponse.handleRestResponseSuccess(response);
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