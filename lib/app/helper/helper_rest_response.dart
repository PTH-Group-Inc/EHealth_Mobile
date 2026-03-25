import 'package:dio/dio.dart';
import '../../data/network/dio/failure.dart';

class HelperRestResponse {
  static T? handleRestResponse<T>(Response response, T Function(dynamic) parseData) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data['data'];
      if (data != null) {
        return parseData(data);
      }
    }
    return null;
  }

  static List<T>? handleRestResponseList<T>(Response response, T Function(dynamic) parseData) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data['data'];
      if (data != null && data is List) {
        return data.map((e) => parseData(e)).toList();
      }
    }
    return null;
  }
}
