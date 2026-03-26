import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:e_health/data/network/auth_interceptor.dart';
import 'package:e_health/data/network/core_service.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio dio(AuthInterceptor authInterceptor) {
    final dio = Dio(BaseOptions(
      baseUrl: dotenv.get('BASE_URL'),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    
    dio.interceptors.add(authInterceptor);
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    
    return dio;
  }

  @singleton
  CoreService getCoreService(Dio dio) => CoreService(dio);
}
