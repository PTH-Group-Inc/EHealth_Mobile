// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:e_health/app/dependency_injection/network_module.dart' as _i112;
import 'package:e_health/data/network/auth_interceptor.dart' as _i197;
import 'package:e_health/data/network/core_service.dart' as _i385;
import 'package:e_health/data/repository.dart' as _i219;
import 'package:e_health/data/repository_implement.dart' as _i1056;
import 'package:e_health/gemini_services.dart' as _i414;
import 'package:e_health/presentation/screens/ai_assistant/cubit/ai_assistant_cubit.dart'
    as _i224;
import 'package:e_health/presentation/screens/auth/cubit/auth_cubit.dart'
    as _i506;
import 'package:e_health/presentation/screens/auth/cubit/register_cubit.dart'
    as _i48;
import 'package:e_health/presentation/screens/branch/cubit/all_branch_cubit.dart'
    as _i479;
import 'package:e_health/presentation/screens/change_password/cubit/change_password_cubit.dart'
    as _i205;
import 'package:e_health/presentation/screens/doctor/cubit/doctor_detail_cubit.dart'
    as _i95;
import 'package:e_health/presentation/screens/home/cubit/home_doctor_cubit.dart'
    as _i909;
import 'package:e_health/presentation/screens/home/cubit/home_specialty_cubit.dart'
    as _i798;
import 'package:e_health/presentation/screens/home/cubit/notification_cubit.dart'
    as _i1009;
import 'package:e_health/presentation/screens/home/screens/cubit/navigation_cubit.dart'
    as _i463;
import 'package:e_health/presentation/screens/search/cubit/search_cubit.dart'
    as _i950;
import 'package:e_health/presentation/screens/speciality/cubit/all_speciality_cubit.dart'
    as _i513;
import 'package:e_health/presentation/screens/speciality/cubit/specialty_detail_cubit.dart'
    as _i103;
import 'package:e_health/presentation/screens/user_profile/cubit/edit_profile_cubit.dart'
    as _i377;
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_cubit.dart'
    as _i470;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.factory<_i205.ChangePasswordCubit>(() => _i205.ChangePasswordCubit());
    gh.factory<_i950.SearchCubit>(() => _i950.SearchCubit());
    gh.factory<_i513.AllSpecialityCubit>(() => _i513.AllSpecialityCubit());
    gh.factory<_i103.SpecialtyDetailCubit>(() => _i103.SpecialtyDetailCubit());
    gh.factory<_i377.EditProfileCubit>(() => _i377.EditProfileCubit());
    gh.factory<_i470.UserProfileCubit>(() => _i470.UserProfileCubit());
    gh.singleton<_i197.AuthInterceptor>(() => _i197.AuthInterceptor());
    gh.singleton<_i463.NavigationCubit>(() => _i463.NavigationCubit());
    gh.lazySingleton<_i414.GeminiService>(() => _i414.GeminiService());
    gh.singleton<_i361.Dio>(
      () => networkModule.dio(gh<_i197.AuthInterceptor>()),
    );
    gh.singleton<_i385.CoreService>(
      () => networkModule.getCoreService(gh<_i361.Dio>()),
    );
    gh.singleton<_i219.Repository>(
      () => _i1056.RepositoryImplement(gh<_i385.CoreService>()),
    );
    gh.factory<_i506.AuthCubit>(
      () =>
          _i506.AuthCubit(gh<_i219.Repository>(), gh<_i463.NavigationCubit>()),
    );
    gh.factory<_i48.RegisterCubit>(
      () => _i48.RegisterCubit(gh<_i219.Repository>()),
    );
    gh.factory<_i479.AllBranchCubit>(
      () => _i479.AllBranchCubit(gh<_i219.Repository>()),
    );
    gh.factory<_i95.DoctorDetailCubit>(
      () => _i95.DoctorDetailCubit(gh<_i219.Repository>()),
    );
    gh.factory<_i909.HomeDoctorCubit>(
      () => _i909.HomeDoctorCubit(gh<_i219.Repository>()),
    );
    gh.factory<_i798.HomeSpecialtyCubit>(
      () => _i798.HomeSpecialtyCubit(gh<_i219.Repository>()),
    );
    gh.factory<_i1009.NotificationCubit>(
      () => _i1009.NotificationCubit(gh<_i219.Repository>()),
    );
    gh.lazySingleton<_i224.AiAssistantCubit>(
      () => _i224.AiAssistantCubit(
        gh<_i414.GeminiService>(),
        gh<_i219.Repository>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i112.NetworkModule {}
