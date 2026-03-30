import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

// Requests
import 'package:e_health/data/request/login_request.dart';
import 'package:e_health/data/request/login_phone_request.dart';
import 'package:e_health/data/request/register_phone_request.dart';
import 'package:e_health/data/request/edit_profile_request.dart';
import 'package:e_health/data/request/change_password_request.dart';
import 'package:e_health/data/request/logout_request.dart';
import 'package:e_health/data/request/refresh_token_request.dart';

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
  Future<RestResponse<LoginResponse>> loginPhone(@Body() LoginPhoneRequest request);

  @POST(RouteApi.registerPhone)
  Future<RestResponse<void>> registerPhone(@Body() RegisterPhoneRequest request);

  @POST(RouteApi.refreshToken)
  Future<RestResponse<LoginResponse>> refreshToken(@Body() RefreshTokenRequest request);

  @POST(RouteApi.logout)
  Future<RestResponse<void>> logout(@Body() LogoutRequest request);

  // ===========================================================================
  // PROFILE
  // ===========================================================================

  @GET(RouteApi.getProfile)
  Future<RestResponse<UserProfileResponse>> getProfile();

  @PUT(RouteApi.updateProfile)
  Future<RestResponse<UserProfileResponse>> updateProfile(@Body() EditProfileRequest request);

  @PUT(RouteApi.changePassword)
  Future<RestResponse<void>> changePassword(@Body() ChangePasswordRequest request);

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
  Future<RestResponse<DepartmentResponse>> getDepartmentDetail(@Path('id') String id);

  // ===========================================================================
  // DOCTORS
  // ===========================================================================

  @GET(RouteApi.activeDoctors)
  Future<RestResponse<List<DoctorResponse>>> getActiveDoctors();

  @GET(RouteApi.getDoctorDetail)
  Future<RestResponse<DoctorDetailResponse>> getDoctorDetail(@Path("id") String id);

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
}
