import 'package:dio/dio.dart';
import '../response/department_response.dart';
import 'package:retrofit/retrofit.dart';
import '../request/login_request.dart';
import '../request/login_phone_request.dart';
import '../request/register_phone_request.dart';
import '../request/edit_profile_request.dart';
import '../request/change_password_request.dart';
import '../request/logout_request.dart';
import '../response/login_response.dart';
import '../response/branch_response.dart';
import '../response/user_profile_response.dart';
import '../response/base_response/rest_response.dart';
import '../response/base_response/page_response.dart';
import '../response/department_list_response.dart';
import '../response/notification_list_response.dart';
import 'router.dart';

part 'core_service.g.dart';

@RestApi()
abstract class CoreService {
  factory CoreService(Dio dio, {String baseUrl}) = _CoreService;

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

  @POST(RouteApi.logout)
  Future<RestResponse<void>> logout(@Body() LogoutRequest request);

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

  @GET('/api/departments/{id}')
  Future<RestResponse<DepartmentResponse>> getDepartmentDetail(
    @Path('id') String id,
  );

  @GET(RouteApi.getNotifications)
  Future<NotificationListResponse> getNotifications({
    @Query("page") int? page,
    @Query("limit") int? limit,
  });

  @PUT(RouteApi.readAllNotifications)
  Future<RestResponse<void>> readAllNotifications();

  @PUT('/api/notifications/inbox/{id}/read')
  Future<RestResponse<void>> readNotification(@Path("id") String id);
}
