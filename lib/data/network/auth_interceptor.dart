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
      // Check if this request has already been retried to avoid infinite loops
      if (err.requestOptions.extra['retried'] == true) {
        return handler.next(err);
      }

      final repository = getIt<Repository>();
      
      // Attempt token refresh
      final result = await repository.refreshToken();
      
      return result.fold(
        (failure) async {
          // If refresh fails, logout and redirect
          await repository.logout();
          appRouter.go('/login');
          return handler.next(err);
        },
        (data) async {
          // If refresh succeeds, retry the original request
          final RequestOptions options = err.requestOptions;
          options.extra['retried'] = true; // Mark as retried
          
          final accessToken = await _storage.read(key: 'accessToken');
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          
          // Re-send the request with the new token
          try {
            final response = await Dio(BaseOptions(
              baseUrl: options.baseUrl,
              connectTimeout: options.connectTimeout,
              receiveTimeout: options.receiveTimeout,
              headers: options.headers,
            )).request(
              options.path,
              data: options.data,
              queryParameters: options.queryParameters,
              options: Options(
                method: options.method,
                headers: options.headers,
                extra: options.extra,
              ),
            );
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
