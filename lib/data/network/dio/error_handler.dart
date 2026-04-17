import 'package:dio/dio.dart';
import 'failure.dart';

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleError(error);
    } else {
      failure = Failure("Đã xảy ra lỗi không xác định");
    }
  }

  Failure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return Failure("Kết nối hết thời gian");
      case DioExceptionType.sendTimeout:
        return Failure("Gửi yêu cầu hết thời gian");
      case DioExceptionType.receiveTimeout:
        return Failure("Nhận phản hồi hết thời gian");
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null && statusCode >= 500) {
          return Failure("Đã có lỗi xảy ra");
        }
        return Failure(
          error.response?.data['message'] ?? "Lỗi phản hồi từ máy chủ",
        );
      case DioExceptionType.cancel:
        return Failure("Yêu cầu đã bị hủy");
      default:
        return Failure("Đã có lỗi xảy ra, vui lòng thử lại sau");
    }
  }
}
