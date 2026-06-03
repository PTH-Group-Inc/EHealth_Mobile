import 'package:e_health/domain/notification_item.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/data/response/notification_response.dart';
import 'package:e_health/data/response/base_response/pagination_response.dart';

part 'notification_list_response.g.dart';

@JsonSerializable()
class NotificationListResponse {
  final bool? success;
  final String? message;
  final List<NotificationResponse>? data;
  final NotificationMeta? meta;
  final PaginationResponse? pagination;
  final String? status;

  bool get isSuccess => success == true || status == 'success';

  NotificationListResponse({
    this.success,
    this.message,
    this.data,
    this.meta,
    this.pagination,
    this.status,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationListResponseToJson(this);

  NotificationListEntity map() {
    return NotificationListEntity(
      items: data?.map((e) => e.map()).toList() ?? [],
      meta: meta?.map(),
      pagination: pagination?.map(),
    );
  }
}

@JsonSerializable()
class NotificationMeta {
  @JsonKey(name: 'unread_count')
  final int? unreadCount;

  NotificationMeta({this.unreadCount});

  factory NotificationMeta.fromJson(Map<String, dynamic> json) =>
      _$NotificationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationMetaToJson(this);

  NotificationMetaEntity map() {
    return NotificationMetaEntity(unreadCount: unreadCount);
  }
}
