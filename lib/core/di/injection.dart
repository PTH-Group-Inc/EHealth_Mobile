import 'package:get_it/get_it.dart';
import '../../core/network/dio_client.dart';
import '../../features/auth/data/auth_api.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Network
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // API
  getIt.registerLazySingleton<AuthApi>(() => AuthApi(getIt<DioClient>()));

  // Cubit
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthApi>()));
}
