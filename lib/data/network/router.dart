class RouteApi {
  static const String apiV1 = "/api";
  static const String login = "$apiV1/auth/login/email";
  static const String logout = "$apiV1/auth/logout";
  static const String getFacilities = "$apiV1/facilities";
  static const String getProfile = "$apiV1/profile/me";
  static const String updateProfile = "$apiV1/profile/me";
  static const String changePassword = "$apiV1/users/{userId}/change-password";
  static const String getSpecialties = "$apiV1/specialties";
}
