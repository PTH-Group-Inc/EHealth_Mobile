import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/network/auth_interceptor.dart';
import '../../data/network/core_service.dart';
import '../helper/log_helper.dart';

const local = 'local';

@module
abstract class NetworkModule {
  @singleton
  @Environment(local)
  @Named('baseUrl')
  String get baseUrlLocal => dotenv.get('BASE_URL_LOCAL');

  @singleton
  @dev
  @prod
  @Named('baseUrl')
  String get baseUrlDev => dotenv.get('BASE_URL');

  @singleton
  Dio dio(AuthInterceptor authInterceptor, @Named('baseUrl') String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
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
