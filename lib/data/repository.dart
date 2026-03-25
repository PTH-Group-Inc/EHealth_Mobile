import 'network/dio/failure.dart';

abstract class Repository {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<void> logout();
  Future<bool> hasToken();
  Future<String?> getStoredUserName();
}
