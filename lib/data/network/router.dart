class RouteApi {
  static const String apiV1 = "/api";
  static const String login = "$apiV1/auth/login/email";
  static const String loginPhone = "$apiV1/auth/login/phone";
  static const String registerPhone = "$apiV1/auth/register/phone";
  static const String registerEmail = "$apiV1/auth/register/email";
  static const String verifyEmail = "$apiV1/auth/verify-email";
  static const String refreshToken = "$apiV1/auth/refresh-token";
  static const String logout = "$apiV1/auth/logout";

  // Facilities & Specialties
  static const String getBranches = "$apiV1/branches";
  static const String getDepartments = "$apiV1/departments";
  static const String getSpecialties = "$apiV1/departments";
  static const String getDepartmentDetail = "$apiV1/departments/{id}";

  // Profile
  static const String getProfile = "$apiV1/profile/me";
  static const String updateProfile = "$apiV1/profile/me";
  static const String changePassword = "$apiV1/profile/password";

  // Doctors
  static const String activeDoctors = "$apiV1/doctor-services/active-doctors";
  static const String getDoctorDetail = "$apiV1/staff/{id}";

  // Notifications
  static const String getNotifications = "$apiV1/notifications/inbox";
  static const String readAllNotifications = "$apiV1/notifications/inbox/read-all";
  static const String readNotification = "$apiV1/notifications/inbox/{id}/read";

  // Patients
  static const String getPatientRecord = "$apiV1/patients/account/{accountId}";
  static const String createPatient = "$apiV1/patients";
  static String updatePatient(String id) => "$apiV1/patients/$id";
  static String linkAccount(String id) => "$apiV1/patients/$id/link-account";
  static const String getMedicalHistory = "$apiV1/medical-history";
}
