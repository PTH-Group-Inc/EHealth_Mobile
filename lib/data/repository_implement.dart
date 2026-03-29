import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'repository.dart';
import 'network/core_service.dart';
import 'request/login_request.dart';
import 'request/login_phone_request.dart';
import 'request/register_phone_request.dart';
import 'request/edit_profile_request.dart';
import 'request/change_password_request.dart';
import 'request/logout_request.dart';
import 'network/dio/failure.dart';
import 'network/dio/error_handler.dart';
import '../domain/branch.dart';
import '../domain/user_profile.dart';
import '../domain/specialty.dart';
import '../domain/department.dart';
import '../domain/notification_item.dart';

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
      if (response.success == true) {
        return const Right(null);
      } else {
        return Left(
          Failure(response.message ?? "Đổi mật khẩu thất bại", code: 400),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, Department>> getDepartmentDetail(String id) async {
    try {
      final response = await _coreService.getDepartmentDetail(id);
      if (response.success == true && response.data != null) {
        return Right(response.data!.map());
      } else {
        return Left(
          Failure(response.message ?? "Không thể lấy chi tiết phòng khoa"),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final response = await _coreService.getProfile();
      if (response.success == true && response.data != null) {
        return Right(response.data!.map());
      }
      return Left(
        Failure(response.message ?? "Lấy thông tin thất bại", code: 400),
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
      if (response.success == true && response.data != null) {
        return Right(response.data!.map());
      }
      return Left(
        Failure(response.message ?? "Cập nhật thông tin thất bại", code: 400),
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
      if (response.success == true) {
        return const Right(null);
      } else {
        return Left(Failure(response.message ?? "Đăng ký thất bại", code: 400));
      }
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
      if (response.success == true && response.data != null) {
        final List<Branch> branches = response.data!
            .map((e) => e.map())
            .toList();
        return Right(branches);
      } else {
        return Left(
          Failure(response.message ?? "Không thể lấy danh sách chi nhánh"),
        );
      }
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
  Future<Either<Failure, List<Specialty>>> getSpecialties() async {
    try {
      final response = await _coreService.getSpecialties();
      if (response.success == true && response.data != null) {
        final List<Specialty> specialties = response.data!.items!
            .map((e) => Specialty(
                  id: e.departments_id,
                  code: e.code,
                  name: e.name,
                  description: e.description,
                  logoUrl: e.logo_url,
                ))
            .toList();
        return Right(specialties);
      } else {
        return Left(
          Failure(response.message ?? "Không thể lấy danh sách chuyên khoa"),
        );
      }
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
      if (response.success == true && response.data != null) {
        final List<Department> departments =
            response.data?.items?.map((e) => e.map()).toList() ?? [];
        return Right(departments);
      } else {
        return Left(
          Failure(response.message ?? "Không thể lấy danh sách phòng khoa"),
        );
      }
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
      if (response.success == true && response.data != null) {
        final List<NotificationItem> notifications =
            response.data!.map((e) => e.map()).toList();
        return Right(notifications);
      } else {
        return Left(
          Failure(response.message ?? "Không thể lấy danh sách thông báo"),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> readAllNotifications() async {
    try {
      final response = await _coreService.readAllNotifications();
      if (response.success == true) {
        return const Right(null);
      } else {
        return Left(
          Failure(response.message ?? "Không thể đánh dấu đã đọc tất cả"),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> readNotification(String id) async {
    try {
      final response = await _coreService.readNotification(id);
      if (response.success == true) {
        return const Right(null);
      } else {
        return Left(
          Failure(response.message ?? "Không thể đánh dấu đã đọc thông báo"),
        );
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