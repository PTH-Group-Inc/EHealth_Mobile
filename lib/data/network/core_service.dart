import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

// Requests
import 'package:e_health/data/request/login_request.dart';
import 'package:e_health/data/request/login_phone_request.dart';
import 'package:e_health/data/request/register_phone_request.dart';
import 'package:e_health/data/request/register_email_request.dart';
import 'package:e_health/data/request/verify_email_request.dart';
import 'package:e_health/data/request/edit_profile_request.dart';
import 'package:e_health/data/request/change_password_request.dart';
import 'package:e_health/data/request/logout_request.dart';
import 'package:e_health/data/request/refresh_token_request.dart';
import 'package:e_health/data/request/update_patient_request.dart';
import 'package:e_health/data/request/link_account_request.dart';
import 'package:e_health/data/request/book_appointment_request.dart';
import 'package:e_health/data/request/forgot_password_request.dart';
import 'package:e_health/data/request/reset_password_request.dart';

// Responses
import 'package:e_health/data/response/login_response.dart';
import 'package:e_health/data/response/branch_response.dart';
import 'package:e_health/data/response/user_profile_response.dart';
import 'package:e_health/data/response/doctor_response.dart';
import 'package:e_health/data/response/doctor_detail_response.dart';
import 'package:e_health/data/response/department_response.dart';
import 'package:e_health/data/response/base_response/rest_response.dart';
import 'package:e_health/data/response/base_response/page_response.dart';
import 'package:e_health/data/response/department_list_response.dart';
import 'package:e_health/data/response/notification_list_response.dart';
import 'package:e_health/data/response/patient_response.dart';
import 'package:e_health/data/response/medical_history_response.dart';
import 'package:e_health/data/response/facility_service_response.dart';
import 'package:e_health/data/response/shift_response.dart';
import 'package:e_health/data/response/appointment_response.dart';
import 'package:e_health/data/response/appointment_list_response.dart';
import 'package:e_health/data/response/appointment_detail_response.dart';
import 'package:e_health/data/response/staff_list_response.dart';

// Network
import 'package:e_health/data/network/router.dart';

part 'core_service.g.dart';

@RestApi()
abstract class CoreService {
  factory CoreService(Dio dio, {String baseUrl}) = _CoreService;

  // ===========================================================================
  // AUTH
  // ===========================================================================

  @POST(RouteApi.login)
  Future<RestResponse<LoginResponse>> login(@Body() LoginRequest request);

  @POST(RouteApi.loginPhone)
  Future<RestResponse<LoginResponse>> loginPhone(
    @Body() LoginPhoneRequest request,
  );

  @POST(RouteApi.registerPhone)
  Future<RestResponse<void>> registerPhone(
    @Body() RegisterPhoneRequest request,
  );

  @POST(RouteApi.registerEmail)
  Future<RestResponse<void>> registerEmail(
    @Body() RegisterEmailRequest request,
  );

  @POST(RouteApi.verifyEmail)
  Future<RestResponse<void>> verifyEmail(@Body() VerifyEmailRequest request);

  @POST(RouteApi.refreshToken)
  Future<RestResponse<LoginResponse>> refreshToken(
    @Body() RefreshTokenRequest request,
  );

  @POST(RouteApi.logout)
  Future<RestResponse<void>> logout(@Body() LogoutRequest request);

  @POST(RouteApi.forgotPassword)
  Future<RestResponse<void>> forgotPassword(@Body() ForgotPasswordRequest request);

  @POST(RouteApi.resetPassword)
  Future<RestResponse<void>> resetPassword(@Body() ResetPasswordRequest request);

  // ===========================================================================
  // PROFILE
  // ===========================================================================

  @GET(RouteApi.getProfile)
  Future<RestResponse<UserProfileResponse>> getProfile();

  @PUT(RouteApi.updateProfile)
  Future<RestResponse<UserProfileResponse>> updateProfile(
    @Body() EditProfileRequest request,
  );

  @PUT(RouteApi.changePassword)
  Future<RestResponse<void>> changePassword(
    @Body() ChangePasswordRequest request,
  );

  // ===========================================================================
  // FACILITIES & DEPARTMENTS
  // ===========================================================================

  @GET(RouteApi.getBranches)
  Future<PageResponse<BranchResponse>> getBranches();

  @GET(RouteApi.getSpecialties)
  Future<DepartmentListResponse> getSpecialties();

  @GET(RouteApi.getDepartments)
  Future<DepartmentListResponse> getDepartments({
    @Query("branch_id") String? branchId,
    @Query("search") String? search,
    @Query("page") int? page,
    @Query("limit") int? limit,
  });

  @GET(RouteApi.getDepartmentDetail)
  Future<RestResponse<DepartmentResponse>> getDepartmentDetail(
    @Path('id') String id,
  );

  // ===========================================================================
  // DOCTORS
  // ===========================================================================

  @GET(RouteApi.activeDoctors)
  Future<RestResponse<List<DoctorResponse>>> getActiveDoctors();

  @GET(RouteApi.getDoctorDetail)
  Future<RestResponse<DoctorDetailResponse>> getDoctorDetail(
    @Path("id") String id,
  );

  @GET(RouteApi.getStaff)
  Future<StaffListResponse> getStaff({
    @Query("status") String? status,
    @Query("roles") String? role,
    @Query("search") String? search,
    @Query("page") int? page,
    @Query("limit") int? limit,
  });

  // ===========================================================================
  // NOTIFICATIONS
  // ===========================================================================

  @GET(RouteApi.getNotifications)
  Future<NotificationListResponse> getNotifications({
    @Query("page") int? page,
    @Query("limit") int? limit,
  });

  @PUT(RouteApi.readAllNotifications)
  Future<RestResponse<void>> readAllNotifications();

  @PUT(RouteApi.readNotification)
  Future<RestResponse<void>> readNotification(@Path("id") String id);

  // ===========================================================================
  // PATIENTS
  // ===========================================================================

  @GET(RouteApi.getPatientRecord)
  Future<RestResponse<List<PatientResponse>>> getPatientRecord(
    @Path("accountId") String accountId,
  );

  @PUT("/api/patients/{id}")
  Future<RestResponse<PatientResponse>> updatePatientRecord(
    @Path("id") String id,
    @Body() UpdatePatientRequest request,
  );

  @POST(RouteApi.createPatient)
  Future<RestResponse<PatientResponse>> createPatientRecord(
    @Body() UpdatePatientRequest request,
  );

  @PATCH("/api/patients/{id}/link-account")
  Future<RestResponse<void>> linkAccountRecord(
    @Path("id") String id,
    @Body() LinkAccountRequest request,
  );

  @GET(RouteApi.getMedicalHistory)
  Future<MedicalHistoryListResponse> getMedicalHistory(
    @Query("patient_id") String patientId, {
    @Query("page") int? page,
    @Query("limit") int? limit,
  });

  @GET(RouteApi.getShifts)
  Future<RestResponse<List<ShiftResponse>>> getShifts();

  @GET("${RouteApi.apiV1}/medical-services/facilities/{facilityId}/services")
  Future<PageResponse<FacilityServiceResponse>> getFacilityServices(
    @Path("facilityId") String facilityId, {
    @Query("search") String? search,
    @Query("page") int? page,
    @Query("limit") int? limit,
  });

  @POST(RouteApi.appointments)
  Future<RestResponse<AppointmentResponse>> bookAppointment(
    @Body() BookAppointmentRequest request,
  );

  @GET(RouteApi.getMyAppointments)
  Future<AppointmentListResponse> getMyAppointments({
    @Query("page") int? page,
    @Query("limit") int? limit,
  });

  @GET("${RouteApi.appointments}/{id}")
  Future<AppointmentDetailResponse> getAppointmentDetail(@Path("id") String id);
}
