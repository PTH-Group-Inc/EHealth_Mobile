import 'package:e_health/presentation/screens/auth/login_screen.dart';
import 'package:e_health/presentation/screens/auth/register_otp_screen.dart';
import 'package:e_health/presentation/screens/auth/register_screen.dart';
import 'package:e_health/presentation/screens/home/screens/main_home_screen.dart';
import 'package:e_health/presentation/screens/branch/all_branch_screen.dart';
import 'package:e_health/presentation/screens/speciality/all_speciality_screen.dart';
import 'package:e_health/presentation/screens/change_password/change_password_screen.dart';
import 'package:e_health/presentation/screens/change_password/cubit/change_password_cubit.dart';
import 'package:e_health/presentation/screens/search/search_screen.dart';
import 'package:e_health/presentation/screens/user_profile/user_profile_screen.dart';
import 'package:e_health/presentation/screens/theme_setting/theme_setting_screen.dart';
import 'package:e_health/presentation/screens/language_setting/language_setting_screen.dart';
import 'package:e_health/presentation/screens/privacy_policy/privacy_policy_screen.dart';
import 'package:e_health/presentation/screens/ai_assistant/ai_assistant_screen.dart';
import 'package:e_health/presentation/screens/user_profile/edit_profile_screen.dart';
import 'package:e_health/domain/user_profile.dart';
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
    GoRoute(
      path: '/',
      name: 'root',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const UserProfileScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      name: 'edit-profile',
      builder: (context, state) {
        final profile = state.extra as UserProfile;
        return EditProfileScreen(profile: profile);
      },
    ),
    GoRoute(
      path: '/change-password',
      name: 'change-password',
      builder: (context, state) => BlocProvider(
        create: (context) => ChangePasswordCubit(),
        child: const ChangePasswordScreen(),
      ),
    ),
    GoRoute(
      path: '/ai',
      name: 'ai',
      builder: (context, state) => const AiAssistantScreen(),
    ),
    GoRoute(
      path: '/register_otp',
      name: 'register-otp',
      builder: (context, state) => RegisterOtpScreen(),
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => SearchScreen(),
    ),
    GoRoute(
      path: '/all-branch',
      name: 'all-branch',
      builder: (context, state) => const AllBranchScreen(),
    ),
    GoRoute(
      path: '/all-specialty',
      name: 'all-specialty',
      builder: (context, state) {
        final branchId = state.uri.queryParameters['branchId'];
        return AllSpecialityScreen(branchId: branchId);
      },
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => MainScreen(),
    ),
    GoRoute(
      path: '/theme-setting',
      name: 'theme-setting',
      builder: (context, state) => const ThemeSettingScreen(),
    ),
    GoRoute(
      path: '/language-setting',
      name: 'language-setting',
      builder: (context, state) => const LanguageSettingScreen(),
    ),
    GoRoute(
      path: '/privacy-policy',
      name: 'privacy-policy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
  ],
);
