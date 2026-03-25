import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../request/login_request.dart';
import '../response/login_response.dart';
import '../response/base_response/rest_response.dart';
import 'router.dart';

part 'core_service.g.dart';

@RestApi()
abstract class CoreService {
  factory CoreService(Dio dio, {String baseUrl}) = _CoreService;

  @POST(RouteApi.login)
  Future<RestResponse<LoginResponse>> login(@Body() LoginRequest request);
}
