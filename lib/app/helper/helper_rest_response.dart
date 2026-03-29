import 'package:dartz/dartz.dart';
import '../../data/network/dio/failure.dart';
import '../../data/response/base_response/rest_response.dart';

import '../../data/response/base_response/page_response.dart';

import '../../data/response/department_list_response.dart';
import '../../data/response/notification_list_response.dart';

class HelperRestResponse {
  static Either<Failure, T> handleRestResponse<T, R>(
    RestResponse<R> response,
    T Function(R) mapToDomain,
  ) {
    if (response.success == true && response.data != null) {
      try {
        return Right(mapToDomain(response.data as R));
      } catch (e) {
        return Left(Failure("Lỗi xử lý dữ liệu: $e"));
      }
    }
    return Left(Failure(response.message ?? "Đã xảy ra lỗi hệ thống"));
  }

  static Either<Failure, List<T>> handleRestResponseList<T, R>(
    RestResponse<List<R>> response,
    T Function(R) mapToDomain,
  ) {
    if (response.success == true && response.data != null) {
      try {
        final List<T> domainList =
            response.data!.map((e) => mapToDomain(e)).toList();
        return Right(domainList);
      } catch (e) {
        return Left(Failure("Lỗi xử lý dữ liệu danh sách: $e"));
      }
    }
    return Left(Failure(response.message ?? "Đã xảy ra lỗi khi lấy danh sách"));
  }

  static Either<Failure, List<T>> handlePageResponse<T, R>(
    PageResponse<R> response,
    T Function(R) mapToDomain,
  ) {
    if (response.success == true && response.data != null) {
      try {
        final List<T> domainList =
            response.data!.map((e) => mapToDomain(e)).toList();
        return Right(domainList);
      } catch (e) {
        return Left(Failure("Lỗi xử lý dữ liệu phân trang: $e"));
      }
    }
    return Left(Failure(response.message ?? "Đã xảy ra lỗi khi lấy dữ liệu"));
  }

  static Either<Failure, List<T>> handleDepartmentList<T>(
    DepartmentListResponse response,
    T Function(dynamic) mapToDomain,
  ) {
    if (response.success == true && response.data?.items != null) {
      try {
        final List<T> domainList =
            response.data!.items!.map((e) => mapToDomain(e)).toList();
        return Right(domainList);
      } catch (e) {
        return Left(Failure("Lỗi xử lý danh sách phòng khoa: $e"));
      }
    }
    return Left(Failure(response.message ?? "Lỗi lấy danh sách phòng khoa"));
  }

  static Either<Failure, List<T>> handleNotificationList<T>(
    NotificationListResponse response,
    T Function(dynamic) mapToDomain,
  ) {
    if (response.success == true && response.data != null) {
      try {
        final List<T> domainList =
            response.data!.map((e) => mapToDomain(e)).toList();
        return Right(domainList);
      } catch (e) {
        return Left(Failure("Lỗi xử lý danh sách thông báo: $e"));
      }
    }
    return Left(Failure(response.message ?? "Lỗi lấy danh sách thông báo"));
  }

  static Either<Failure, void> handleRestResponseSuccess(
    dynamic response,
  ) {
    if (response.success == true) {
      return const Right(null);
    }
    return Left(Failure(response.message ?? "Thao tác thất bại"));
  }
}


