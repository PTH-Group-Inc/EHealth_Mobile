class RouteApi {
  static const String apiV1 = "/api";
  static const String login = "$apiV1/auth/login/email";
  static const String loginPhone = "$apiV1/auth/login/phone";
  static const String registerPhone = "$apiV1/auth/register/phone";
  static const String registerEmail = "$apiV1/auth/register/email";
  static const String verifyEmail = "$apiV1/auth/verify-email";
  static const String refreshToken = "$apiV1/auth/refresh-token";
  static const String logout = "$apiV1/auth/logout";
  static const String forgotPassword = "$apiV1/auth/forgot-password";
  static const String resetPassword = "$apiV1/auth/reset-password";

  // Facilities & Specialties
  static const String getBranches = "$apiV1/branches";
  static const String getBranchDetail = "$apiV1/branches/{id}";
  static const String getDepartments = "$apiV1/departments";
  static const String getSpecialties = "$apiV1/departments";
  static const String getDepartmentDetail = "$apiV1/departments/{id}";
  static const String getDepartmentSpecialties =
      "$apiV1/department-specialties/{id}/specialties";
  static const String getSpecialtyServices =
      "$apiV1/specialty-services/{specialtyId}/services";

  // Profile
  static const String getProfile = "$apiV1/profile/me";
  static const String updateProfile = "$apiV1/profile/me";
  static const String changePassword = "$apiV1/profile/password";
  static const String uploadAvatar = "$apiV1/profile/avatar";
  static const String deleteAvatar = "$apiV1/profile/avatar";
  static const String updateFcmToken = "$apiV1/profile/fcm-token";

  static const String activeDoctors = "$apiV1/doctor-services/active-doctors";
  static const String getDoctorsByFacilityService =
      "$apiV1/doctor-services/by-facility-service/{facilityServiceId}";
  static const String getStaff = "$apiV1/staff";
  static const String getDoctorDetail = "$apiV1/staff/{id}";
  static const String getDoctorAvailability =
      "$apiV1/doctor-availability/{doctorId}";

  // Notifications
  static const String getNotifications = "$apiV1/notifications/inbox";
  static const String readAllNotifications =
      "$apiV1/notifications/inbox/read-all";
  static const String readNotification = "$apiV1/notifications/inbox/{id}/read";

  // Patients
  static const String getPatientRecord = "$apiV1/patients/account/{accountId}";
  static const String createPatient = "$apiV1/patients";
  static String updatePatient(String id) => "$apiV1/patients/$id";
  static String getPatientDetail(String id) => "$apiV1/patients/$id";
  static String linkAccount(String id) => "$apiV1/patients/$id/link-account";
  static const String uploadPatientAvatar = "$apiV1/patient/profiles/{id}/avatar";
  static const String getMedicalHistory = "$apiV1/medical-history";

  // Appointments & Services
  static String getFacilityServices(String id) =>
      "$apiV1/medical-services/facilities/$id/services";
  static const String getShifts = "$apiV1/shifts";
  static const String getSlots = "$apiV1/slots";
  static const String appointments = "$apiV1/appointments";
  static const String getMyAppointments = "$apiV1/appointments/my-appointments";
  static const String getAvailableSlots = "$apiV1/appointments/available-slots";
  static const String getFacilityCalendar = "$apiV1/facility-status/calendar";

  // EHR
  static const String getCurrentMedications =
      "$apiV1/ehr/patients/{patientId}/current-medications";
  static const String getLatestVitals =
      "$apiV1/ehr/patients/{patientId}/latest-vitals";
  static const String getEncounterByAppointment =
      "$apiV1/encounters/by-appointment/{appointmentId}";
  static const String getInvoiceByEncounter =
      "$apiV1/billing/invoices/by-encounter/{encounterId}";
  static const String getPrescription = "$apiV1/prescriptions/{encounterId}";

  // Pre-booking Payment
  static const String preBookAppointment = "$apiV1/appointments/pre-book";
  static const String regenerateBookingQr =
      "$apiV1/appointments/{id}/regenerate-qr";
  static const String checkPaymentStatus =
      "$apiV1/appointments/{id}/payment-status";
}
