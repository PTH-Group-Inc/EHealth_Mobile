import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/network/auth_interceptor.dart';
import '../../data/network/core_service.dart';
import '../helper/log_helper.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio dio(AuthInterceptor authInterceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: dotenv.get('BASE_URL'),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(authInterceptor);
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: LogHelper.printLongString,
      ),
    );

    return dio;
  }

  @singleton
  CoreService getCoreService(Dio dio) => CoreService(dio);
}
