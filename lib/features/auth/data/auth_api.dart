import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:e_health/core/network/dio_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthApi {
  final DioClient _dioClient;
  final _storage = const FlutterSecureStorage();

  AuthApi(this._dioClient);

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final String baseUrl = dotenv.get('BASE_URL');
    final String url = '$baseUrl/api/auth/login/email';

    final clientInfo = await _getUserClientInfo();

    try {
      final response = await _dioClient.dio.post(
        url,
        data: {"email": email, "password": password, "clientInfo": clientInfo},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final success = response.data['success'] == true;
        if (!success) return null;

        final data = response.data['data'];
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];
        final user = data['user'];

        if (accessToken != null && refreshToken != null) {
          await _storage.write(key: 'accessToken', value: accessToken);
          await _storage.write(key: 'refreshToken', value: refreshToken);
          if (user != null && user['name'] != null) {
            await _storage.write(key: 'userName', value: user['name']);
          }
        }
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    final String baseUrl = dotenv.get('BASE_URL');
    final String url = '$baseUrl/api/auth/logout';
    try {
      await _dioClient.dio.post(url);
    } catch (e) {
      // Log error or ignore if already logged out on server
    } finally {
      await _storage.delete(key: 'accessToken');
      await _storage.delete(key: 'refreshToken');
      await _storage.delete(key: 'userName');
    }
  }

  Future<bool> hasToken() async {
    final token = await _storage.read(key: 'refreshToken');
    return token != null;
  }

  Future<String?> getStoredUserName() async {
    return await _storage.read(key: 'userName');
  }

  Future<Map<String, String?>> _getUserClientInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    String? deviceId;
    String? deviceName;

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
      deviceName = androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
      deviceName = iosInfo.utsname.machine;
    }

    return {"deviceId": deviceId, "deviceName": deviceName};
  }
}
