class RouteApi {
  static const String apiV1 = "/api";
  static const String login = "$apiV1/auth/login/email";
  static const String loginPhone = "$apiV1/auth/login/phone";
  static const String registerPhone = "$apiV1/auth/register/phone";
  static const String logout = "$apiV1/auth/logout";
  static const String getBranches = "$apiV1/branches";
  static const String getDepartments = "$apiV1/departments";
  static const String getProfile = "$apiV1/profile/me";
  static const String updateProfile = "$apiV1/profile/me";
  static const String changePassword = "$apiV1/profile/password";
  static const String getSpecialties = "$apiV1/departments";
  static String getDepartmentDetail(String id) => "$apiV1/departments/$id";

  // Notifications
  static const String getNotifications = "$apiV1/notifications/inbox";
  static const String readAllNotifications = "$apiV1/notifications/inbox/read-all";
  static String readNotification(String id) => "$apiV1/notifications/inbox/$id/read";
}
