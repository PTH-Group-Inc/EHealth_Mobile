import 'package:e_health/presentation/screens/auth/login_screen.dart';
import 'package:e_health/presentation/screens/auth/register_otp_screen.dart';
import 'package:e_health/presentation/screens/auth/register_screen.dart';
import 'package:e_health/presentation/screens/home/screens/home_ai_assistant.dart';
import 'package:e_health/presentation/screens/home/screens/main_home_screen.dart';
import 'package:e_health/presentation/screens/medical_facility/all_medical_facility_screen.dart';
import 'package:e_health/presentation/screens/search/search_screen.dart';
import 'package:e_health/presentation/screens/user_profile/user_profile_screen.dart';
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
    GoRoute(path: '/profile', builder: (context, state) => const UserProfileScreen()),
    GoRoute(path: '/ai', builder: (context, state) => HomeAiAssistant()),
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
  ],
);
