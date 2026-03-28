import 'package:dio/dio.dart';
import '../../app/dependency_injection/configure_injectable.dart';
import '../../app/route_manager.dart';
import '../repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
class AuthInterceptor extends Interceptor {
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _storage.read(key: 'accessToken');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final repository = getIt<Repository>();
      
      // Attempt auto login
      final result = await repository.autoLogin();
      
      return result.fold(
        (failure) async {
          // If auto login fails, clear tokens and redirect to login
          await repository.logout();
          appRouter.go('/login');
          return handler.next(err);
        },
        (data) async {
          // If auto login succeeds, retry the original request
          final RequestOptions options = err.requestOptions;
          final accessToken = await _storage.read(key: 'accessToken');
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          
          // Re-send the request
          try {
            final response = await Dio(BaseOptions(
              baseUrl: options.baseUrl,
              connectTimeout: options.connectTimeout,
              receiveTimeout: options.receiveTimeout,
            )).fetch(options);
            return handler.resolve(response);
          } catch (e) {
            return handler.next(err);
          }
        },
      );
    }
    return handler.next(err);
  }
}
