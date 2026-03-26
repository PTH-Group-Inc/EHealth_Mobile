import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../request/login_request.dart';
import '../request/change_password_request.dart';
import '../response/login_response.dart';
import '../response/medical_facility_response.dart';
import '../response/user_profile_response.dart';
import '../response/base_response/rest_response.dart';
import 'router.dart';

part 'core_service.g.dart';

@RestApi()
abstract class CoreService {
  factory CoreService(Dio dio, {String baseUrl}) = _CoreService;

  @POST(RouteApi.login)
  Future<RestResponse<LoginResponse>> login(@Body() LoginRequest request);

  @GET(RouteApi.getFacilities)
  Future<RestResponse<MedicalFacilityListResponse>> getFacilities();

  @POST(RouteApi.logout)
  Future<RestResponse<void>> logout();

  @GET(RouteApi.getProfile)
  Future<RestResponse<UserProfileResponse>> getProfile();

  @POST(RouteApi.changePassword)
  Future<RestResponse<void>> changePassword(
    @Path("userId") String userId,
    @Body() ChangePasswordRequest request,
  );
}
