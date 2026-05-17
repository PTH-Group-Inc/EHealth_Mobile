import 'package:dartz/dartz.dart';
import 'package:e_health/data/network/dio/failure.dart';
import 'package:e_health/data/request/update_patient_request.dart';
import 'package:e_health/domain/branch.dart';
import 'package:e_health/domain/user_profile.dart';
import 'package:e_health/domain/avatar.dart';
import 'package:e_health/domain/specialty.dart';
import 'package:e_health/domain/department.dart';
import 'package:e_health/domain/notification_item.dart';
import 'package:e_health/domain/doctor.dart';
import 'package:e_health/domain/doctor_detail.dart';
import 'package:e_health/domain/patient.dart';
import 'package:e_health/domain/medical_history.dart';
import 'package:e_health/domain/shift.dart';
import 'package:e_health/domain/slot.dart';
import 'package:e_health/domain/encounter.dart';
import 'package:e_health/domain/invoice.dart';
import 'package:e_health/domain/facility_service.dart';
import 'package:e_health/domain/booked_appointment.dart';
import 'package:e_health/domain/appointment_detail.dart';
import 'package:e_health/domain/doctor_availability.dart';
import 'package:e_health/domain/doctor_service.dart';
import 'package:e_health/domain/specialty_service.dart';
import 'package:e_health/domain/prescription.dart';
import 'package:e_health/domain/medication.dart';
import 'package:e_health/domain/patient_vitals.dart';
import 'package:e_health/data/request/book_appointment_request.dart';
import 'package:e_health/data/request/book_patient_appointment_request.dart';
import 'package:e_health/data/response/facility_calendar_day_response.dart';
import 'package:e_health/domain/pre_booking.dart';
import 'package:e_health/data/request/pre_booking_request.dart';

abstract class Repository {
  Future<Either<Failure, UserProfile>> login(String email, String password);
  Future<Either<Failure, UserProfile>> loginPhone(String phone, String password);
  Future<Either<Failure, void>> registerPhone(
    String phone,
    String password,
    String name,
  );
  Future<Either<Failure, void>> registerEmail(
    String email,
    String password,
    String name,
  );
  Future<Either<Failure, void>> verifyEmail(String email, String code);
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> resetPassword(String otp, String newPassword);
  Future<Either<Failure, Map<String, dynamic>>> autoLogin();
  Future<Either<Failure, Map<String, dynamic>>> refreshToken();
  Future<void> logout();
  Future<bool> hasToken();
  Future<String?> getStoredUserName();
  Future<void> updateStoredUserName(String name);
  Future<Either<Failure, List<Branch>>> getBranches();
  Future<Either<Failure, Branch>> getBranchDetail(String id);
  Future<Either<Failure, Department>> getDepartmentDetail(String id);
  Future<Either<Failure, List<Specialty>>> getDepartmentSpecialties(String id);
  Future<Either<Failure, UserProfile>> getProfile();
  Future<Either<Failure, UserProfile>> updateProfile(Map<String, dynamic> data);
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  );
  Future<Either<Failure, List<Specialty>>> getSpecialties();
  Future<Either<Failure, List<Doctor>>> getActiveDoctors({
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, DoctorDetail>> getDoctorDetail(String userId);

  Future<Either<Failure, Map<String, List<DoctorAvailability>>>>
  getDoctorAvailability({
    required String doctorId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<Failure, List<Department>>> getDepartments({
    String? branchId,
    String? search,
    int? page,
    int? limit,
  });
  Future<Either<Failure, List<Doctor>>> searchDoctors({
    String? search,
    int? page,
    int? limit,
  });

  Future<Either<Failure, List<NotificationItem>>> getNotifications({
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, void>> readAllNotifications();
  Future<Either<Failure, void>> readNotification(String id);
  Future<Either<Failure, Patient>> getPatientRecordById(String id);
  Future<Either<Failure, List<Patient>>> getPatientRecord(String accountId);
  Future<Either<Failure, Patient>> updatePatientRecord(
    String id,
    UpdatePatientRequest request,
  );

  Future<Either<Failure, Patient>> createPatientRecord(
    UpdatePatientRequest request,
  );

  Future<Either<Failure, void>> linkAccountRecord(String id, String accountId);
  Future<Either<Failure, void>> deletePatientRecord(String id);
  Future<Either<Failure, List<MedicalHistory>>> getMedicalHistory(
    String patientId, {
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, List<FacilityCalendarDayStatus>>> getFacilityCalendar({
    required String facilityId,
    required int month,
    required int year,
  });

  Future<Either<Failure, List<Shift>>> getShifts();
  Future<Either<Failure, List<Slot>>> getSlots(String shiftId);
  Future<Either<Failure, List<Slot>>> getAvailableSlots({
    required String date,
    String? doctorId,
    required String facilityId,
  });

  Future<Either<Failure, List<FacilityService>>> getFacilityServices(
    String facilityId, {
    String? search,
    String? departmentId,
    bool? isActive,
    int? page,
    int? limit,
  });
  Future<Either<Failure, List<DoctorService>>> getDoctorServices(
    String doctorId,
  );
  Future<Either<Failure, List<DoctorService>>> getDoctorsByFacilityService(
    String facilityServiceId,
  );

  Future<Either<Failure, List<SpecialtyService>>> getSpecialtyServices(
    String specialtyId,
  );
  Future<Either<Failure, BookedAppointment>> bookPatientAppointment(
    String patientId,
    BookPatientAppointmentRequest request,
  );
  Future<Either<Failure, BookedAppointment>> bookAppointment(
    BookAppointmentRequest request,
  );
  Future<Either<Failure, List<BookedAppointment>>> getMyAppointments({
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, AppointmentDetail>> getAppointmentDetail(String id);
  Future<Either<Failure, Avatar>> uploadAvatar(String filePath);
  Future<Either<Failure, Avatar>> uploadPatientAvatar(
    String id,
    String filePath,
  );
  Future<Either<Failure, void>> deleteAvatar(String publicId);
  Future<Either<Failure, Encounter>> getEncounterByAppointment(
    String appointmentId,
  );
  Future<Either<Failure, Invoice>> getInvoiceByEncounter(String encounterId);
  Future<Either<Failure, Prescription>> getPrescription(String encounterId);
  Future<Either<Failure, BookedAppointment>> cancelAppointment(
    String id,
    String reason,
  );
  Future<Either<Failure, List<Medication>>> getCurrentMedications(
    String patientId,
  );
  Future<Either<Failure, PatientVitals?>> getPatientLatestVitals(
    String patientId,
  );

  // Pre-booking payment
  Future<Either<Failure, PreBookingEntity>> preBookAppointment(
    PreBookingRequest request,
  );
  Future<Either<Failure, RegenerateQrEntity>> regenerateBookingQr(
    String appointmentId,
  );
  Future<Either<Failure, PaymentStatusEntity>> checkPaymentStatus(
    String appointmentId,
  );
}
