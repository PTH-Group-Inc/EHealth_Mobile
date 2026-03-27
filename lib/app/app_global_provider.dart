import 'package:e_health/presentation/screens/auth/cubit/auth_cubit.dart';
import 'package:e_health/presentation/screens/home/screens/cubit/navigation_cubit.dart';
import 'package:e_health/presentation/screens/medical_facility/cubit/all_medical_facility_cubit.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_cubit.dart';
import 'package:e_health/presentation/screens/ai_assistant/cubit/ai_assistant_cubit.dart';
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
        BlocProvider(create: (_) => getIt<AiAssistantCubit>()),
        BlocProvider(create: (_) => getIt<AllMedicalFacilityCubit>()),
      ],
      child: child,
    );
  }
}
