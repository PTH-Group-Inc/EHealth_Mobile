import 'dart:async';
import 'package:e_health/constant/key_secure_constant.dart';
import 'package:dio/dio.dart';

import '../../app/dependency_injection/configure_injectable.dart';
import '../../app/route_manager.dart';
import '../repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'router.dart';

@singleton
class AuthInterceptor extends Interceptor {
  final _storage = const FlutterSecureStorage();
  Completer<void>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip adding Authorization header for auth-related endpoints
    final authPaths = [
      RouteApi.login,
      RouteApi.loginPhone,
      RouteApi.refreshToken,
      RouteApi.registerPhone,
    ];

    if (authPaths.any((path) => options.path.contains(path))) {
      return handler.next(options);
    }

    final accessToken = await _storage.read(key: KeySecure.accessToken);
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
      // Avoid recursive loops for refresh token and logout endpoints
      final skipRetryPaths = [
        RouteApi.refreshToken,
        RouteApi.logout,
      ];
      if (skipRetryPaths.any((path) => err.requestOptions.path.contains(path))) {
        return handler.next(err);
      }

      // Check if this request has already been retried to avoid infinite loops
      if (err.requestOptions.extra['retried'] == true) {
        return handler.next(err);
      }

      // 1. Synchronized token refresh
      if (_refreshCompleter != null) {
        await _refreshCompleter!.future;
        return _retry(err, handler);
      }

      _refreshCompleter = Completer<void>();
      final repository = getIt<Repository>();
      final refreshResult = await repository.refreshToken();

      return refreshResult.fold(
        (failure) async {
          // 2. If refresh fails, attempt auto-login with saved credentials
          final autoLoginResult = await repository.autoLogin();

          return autoLoginResult.fold(
            (autoLoginFailure) async {
              _refreshCompleter?.complete();
              _refreshCompleter = null;
              // 3. If both fail, logout and redirect to login screen
              await repository.logout();
              appRouter.go('/login');
              return handler.next(err);
            },
            (data) async {
              _refreshCompleter?.complete();
              _refreshCompleter = null;
              // Auto-login success, retry the original request
              return _retry(err, handler);
            },
          );
        },
        (data) async {
          _refreshCompleter?.complete();
          _refreshCompleter = null;
          // Token refresh success, retry the original request
          return _retry(err, handler);
        },
      );
    }
    return handler.next(err);
  }

  Future<void> _retry(DioException err, ErrorInterceptorHandler handler) async {
    final RequestOptions options = err.requestOptions;
    options.extra['retried'] = true; // Mark as retried

    final accessToken = await _storage.read(key: KeySecure.accessToken);
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    try {
      final dio = Dio(BaseOptions(
        baseUrl: options.baseUrl,
        connectTimeout: options.connectTimeout,
        receiveTimeout: options.receiveTimeout,
        headers: options.headers,
      ));

      final response = await dio.request(
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
  }
}
