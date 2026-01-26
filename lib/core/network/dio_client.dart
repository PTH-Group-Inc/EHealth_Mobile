import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'].toString(), // Lấy từ .env
        connectTimeout: const Duration(seconds: 10), // Đợi 10s không thấy thì báo lỗi
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Thêm Interceptor để log ra console cho dễ debug (như Postman)
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  // Getter để lấy instance dio ra dùng
  Dio get dio => _dio;
}
