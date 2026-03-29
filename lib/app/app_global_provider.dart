import '../presentation/screens/auth/cubit/auth_cubit.dart';
import '../presentation/screens/auth/cubit/register_cubit.dart';
import '../presentation/screens/home/screens/cubit/navigation_cubit.dart';
import '../presentation/screens/branch/cubit/all_branch_cubit.dart';
import '../presentation/screens/user_profile/cubit/user_profile_cubit.dart';
import '../presentation/screens/user_profile/cubit/edit_profile_cubit.dart';
import '../presentation/screens/home/cubit/notification_cubit.dart';
import '../presentation/screens/ai_assistant/cubit/ai_assistant_cubit.dart';
import '../presentation/screens/home/cubit/home_specialty_cubit.dart';
import '../presentation/screens/speciality/cubit/all_speciality_cubit.dart';
import '../presentation/screens/change_password/cubit/change_password_cubit.dart';
import '../presentation/screens/search/cubit/search_cubit.dart';
import '../presentation/screens/speciality/cubit/specialty_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dependency_injection/configure_injectable.dart';

class AppGlobalProvider extends StatelessWidget {
  final Widget child;

  const AppGlobalProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()..checkAuthStatus()),
        BlocProvider(create: (_) => getIt<NavigationCubit>()),
        BlocProvider(create: (_) => getIt<UserProfileCubit>()),
        BlocProvider(create: (_) => getIt<AiAssistantCubit>()..init()),
        BlocProvider(create: (_) => getIt<AllBranchCubit>()),
        BlocProvider(create: (_) => getIt<RegisterCubit>()),
        BlocProvider(create: (_) => getIt<EditProfileCubit>()),
        BlocProvider(create: (_) => getIt<HomeSpecialtyCubit>()..loadSpecialties()),
        BlocProvider(create: (_) => getIt<AllSpecialityCubit>()),
        BlocProvider(create: (_) => getIt<NotificationCubit>()..loadNotifications()),
        BlocProvider(create: (_) => getIt<ChangePasswordCubit>()),
        BlocProvider(create: (_) => getIt<SearchCubit>()),
        BlocProvider(create: (_) => getIt<SpecialtyDetailCubit>()),
      ],
      child: child,
    );
  }
}
