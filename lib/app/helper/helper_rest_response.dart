import 'package:dartz/dartz.dart';
import 'package:e_health/data/network/dio/failure.dart';
import 'package:e_health/data/response/base_response/rest_response.dart';

import 'package:e_health/data/response/base_response/page_response.dart';

import 'package:e_health/data/response/department_list_response.dart';
import 'package:e_health/data/response/notification_list_response.dart';

class HelperRestResponse {
  static Either<Failure, T> handleRestResponse<T, R>(
    RestResponse<R> response,
    T Function(R) mapToDomain,
  ) {
    if (response.isSuccess && response.data != null) {
      try {
        return Right(mapToDomain(response.data as R));
      } catch (e) {
        return Left(Failure("Lỗi xử lý dữ liệu: $e"));
      }
    }
    return Left(Failure(response.message ?? "Đã có lỗi xảy ra"));
  }

  static Either<Failure, List<T>> handleRestResponseList<T, R>(
    RestResponse<List<R>> response,
    T Function(R) mapToDomain,
  ) {
    if (response.isSuccess && response.data != null) {
      try {
        final List<T> domainList =
            response.data!.map((e) => mapToDomain(e)).toList();
        return Right(domainList);
      } catch (e) {
        return Left(Failure("Lỗi xử lý dữ liệu danh sách: $e"));
      }
    }
    return Left(Failure(response.message ?? "Đã có lỗi xảy ra"));
  }

  static Either<Failure, List<T>> handlePageResponse<T, R>(
    PageResponse<R> response,
    T Function(R) mapToDomain,
  ) {
    if (response.isSuccess && response.data != null) {
      try {
        final List<T> domainList =
            response.data!.map((e) => mapToDomain(e)).toList();
        return Right(domainList);
      } catch (e) {
        return Left(Failure("Lỗi xử lý dữ liệu phân trang: $e"));
      }
    }
    return Left(Failure(response.message ?? "Đã có lỗi xảy ra"));
  }

  static Either<Failure, List<T>> handleDepartmentList<T>(
    DepartmentListResponse response,
    T Function(dynamic) mapToDomain,
  ) {
    if (response.isSuccess && response.data?.items != null) {
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
    if (response.isSuccess && response.data != null) {
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

  static Either<Failure, Map<String, List<T>>> handleRestResponseMap<T>(
    RestResponse<dynamic> response,
    T Function(Map<String, dynamic>) mapToDomain,
  ) {
    if (response.isSuccess && response.data != null) {
      try {
        final Map<String, List<T>> result = {};
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        data.forEach((key, value) {
          if (value is List) {
            result[key] =
                value.map((e) => mapToDomain(e as Map<String, dynamic>)).toList();
          }
        });
        return Right(result);
      } catch (e) {
        return Left(Failure("Lỗi xử lý dữ liệu: $e"));
      }
    }
    return Left(Failure(response.message ?? "Thao tác thất bại"));
  }

  static Either<Failure, void> handleRestResponseSuccess(
    dynamic response,
  ) {
    if (response.isSuccess) {
      return const Right(null);
    }
    return Left(Failure(response.message ?? "Thao tác thất bại"));
  }
}


