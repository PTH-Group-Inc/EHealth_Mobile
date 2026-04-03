import 'package:dartz/dartz.dart';
import 'network/dio/failure.dart';
import 'request/update_patient_request.dart';
import '../domain/branch.dart';
import '../domain/user_profile.dart';
import '../domain/specialty.dart';
import '../domain/department.dart';
import '../domain/notification_item.dart';
import '../domain/doctor.dart';
import '../domain/doctor_detail.dart';
import '../domain/patient.dart';
import '../domain/medical_history.dart';
import '../domain/shift.dart';
import '../domain/slot.dart';
import '../domain/facility_service.dart';
import '../domain/booked_appointment.dart';
import '../domain/appointment_detail.dart';
import 'request/book_appointment_request.dart';

abstract class Repository {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> loginPhone(String phone, String password);
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
  Future<Either<Failure, Department>> getDepartmentDetail(String id);
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
  Future<Either<Failure, List<Patient>>> getPatientRecord(String accountId);
  Future<Either<Failure, Patient>> updatePatientRecord(
    String id,
    UpdatePatientRequest request,
  );

  Future<Either<Failure, Patient>> createPatientRecord(
    UpdatePatientRequest request,
  );

  Future<Either<Failure, void>> linkAccountRecord(String id, String accountId);
  Future<Either<Failure, List<MedicalHistory>>> getMedicalHistory(
    String patientId, {
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, List<Shift>>> getShifts();

  Future<Either<Failure, List<Slot>>> getSlots(String shiftId);

  Future<Either<Failure, List<FacilityService>>> getFacilityServices(String facilityId, {String? search});
  Future<Either<Failure, BookedAppointment>> bookAppointment(BookAppointmentRequest request);
  Future<Either<Failure, List<BookedAppointment>>> getMyAppointments({
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, AppointmentDetail>> getAppointmentDetail(String id);
}
