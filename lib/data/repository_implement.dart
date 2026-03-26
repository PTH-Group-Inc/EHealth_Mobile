import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/data/network/core_service.dart';
import 'package:e_health/data/request/login_request.dart';
import 'package:e_health/data/request/change_password_request.dart';
import 'package:e_health/data/network/dio/failure.dart';
import 'package:e_health/data/network/dio/error_handler.dart';
import 'package:e_health/domain/medical_facility.dart';
import 'package:e_health/domain/user_profile.dart';
import 'package:device_info_plus/device_info_plus.dart';

@Singleton(as: Repository)
class RepositoryImplement implements Repository {
  final CoreService _coreService;
  final _storage = const FlutterSecureStorage();

  RepositoryImplement(this._coreService);

  @override
  Future<Either<Failure, void>> changePassword(
      String userId, String oldPassword, String newPassword) async {
    try {
      final request = ChangePasswordRequest(
          oldPassword: oldPassword, newPassword: newPassword);
      final response = await _coreService.changePassword(userId, request);
      if (response.success == true) {
        return const Right(null);
      } else {
        return Left(
            Failure(response.message ?? "Đổi mật khẩu thất bại", code: 400));
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
      return Left(Failure(response.message ?? "Lấy thông tin thất bại", code: 400));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final clientInfo = await _getUserClientInfo();
    final request = LoginRequest(email: email, password: password, clientInfo: clientInfo);
    
    try {
      final response = await _coreService.login(request);
      if (response.success == true && response.data != null) {
        final data = response.data!;
        await _storage.write(key: 'accessToken', value: data.accessToken);
        await _storage.write(key: 'refreshToken', value: data.refreshToken);
        if (data.user?.name != null) {
          await _storage.write(key: 'userName', value: data.user!.name);
        }
        return data.user?.toMap() ?? {};
      } else {
        throw Failure(response.message ?? "Đăng nhập thất bại");
      }
    } catch (e) {
      throw Failure("Đã xảy ra lỗi, vui lòng thử lại sau");
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _coreService.logout();
    } catch (e) {
      // Logic logout still proceeds even if API fails to ensure local tokens are cleared
    } finally {
      await _storage.delete(key: 'accessToken');
      await _storage.delete(key: 'refreshToken');
      await _storage.delete(key: 'userName');
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
  Future<Either<Failure, List<MedicalFacility>>> getFacilities() async {
    try {
      final response = await _coreService.getFacilities();
      if (response.success == true && response.data != null) {
        final List<MedicalFacility> facilities = response.data!.items!
            .map((e) => e.map())
            .toList();
        return Right(facilities);
      } else {
        return Left(Failure(response.message ?? "Không thể lấy danh sách cơ sở y tế"));
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

    return {
      "deviceId": deviceId,
      "deviceName": deviceName,
    };
  }
}
