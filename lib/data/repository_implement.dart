import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'repository.dart';
import 'network/core_service.dart';
import 'request/login_request.dart';
import 'network/dio/failure.dart';
import 'package:device_info_plus/device_info_plus.dart';

@Singleton(as: Repository)
class RepositoryImplement implements Repository {
  final CoreService _coreService;
  final _storage = const FlutterSecureStorage();

  RepositoryImplement(this._coreService);

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
      // await _coreService.logout(); 
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
