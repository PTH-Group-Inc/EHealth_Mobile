import 'package:e_health/presentation/screens/auth/login_screen.dart';
import 'package:e_health/presentation/screens/auth/register_otp_screen.dart';
import 'package:e_health/presentation/screens/auth/register_screen.dart';
import 'package:e_health/presentation/screens/home/screens/main_home_screen.dart';
import 'package:e_health/presentation/screens/medical_facility/all_medical_facility_screen.dart';
import 'package:e_health/presentation/screens/change_password/change_password_screen.dart';
import 'package:e_health/presentation/screens/change_password/cubit/change_password_cubit.dart';
import 'package:e_health/presentation/screens/search/search_screen.dart';
import 'package:e_health/presentation/screens/user_profile/user_profile_screen.dart';
import 'package:e_health/presentation/screens/theme_setting/theme_setting_screen.dart';
import 'package:e_health/presentation/screens/language_setting/language_setting_screen.dart';
import 'package:e_health/presentation/screens/privacy_policy/privacy_policy_screen.dart';
import 'package:e_health/presentation/screens/ai_assistant/ai_assistant_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    const storage = FlutterSecureStorage();
    final refreshToken = await storage.read(key: 'refreshToken');
    final isLoggedIn = refreshToken != null;

    final isLoggingIn =
        state.matchedLocation == '/' || state.matchedLocation == '/login';

    if (isLoggedIn && isLoggingIn) {
      return '/home';
    }

    if (!isLoggedIn && state.matchedLocation == '/home') {
      return '/login';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const UserProfileScreen(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => BlocProvider(
        create: (context) => ChangePasswordCubit(),
        child: const ChangePasswordScreen(),
      ),
    ),
    GoRoute(path: '/ai', builder: (context, state) => const AiAssistantScreen()),
    GoRoute(
      path: '/register_otp',
      builder: (context, state) => RegisterOtpScreen(),
    ),
    GoRoute(path: '/search', builder: (context, state) => SearchScreen()),
    GoRoute(
      path: '/all-facility',
      builder: (context, state) => AllMedicalFacilityScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => MainScreen()),
    GoRoute(
      path: '/theme-setting',
      builder: (context, state) => const ThemeSettingScreen(),
    ),
    GoRoute(
      path: '/language-setting',
      builder: (context, state) => const LanguageSettingScreen(),
    ),
    GoRoute(
      path: '/privacy-policy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
  ],
);
