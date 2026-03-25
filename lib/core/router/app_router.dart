import 'package:e_health/features/auth/presentation/login_screen.dart';
import 'package:e_health/features/auth/presentation/register_otp_screen.dart';
import 'package:e_health/features/auth/presentation/register_screen.dart';
import 'package:e_health/features/home/presentation/screens/home_ai_assistant.dart';
import 'package:e_health/features/home/presentation/screens/main_home_screen.dart';
import 'package:e_health/features/medical_facility/presentation/screens/all_medical_facility_screen.dart';
import 'package:e_health/features/search/presentation/pages/search_screen.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    const storage = FlutterSecureStorage();
    final refreshToken = await storage.read(key: 'refreshToken');
    final isLoggedIn = refreshToken != null;

    final isLoggingIn = state.matchedLocation == '/' || state.matchedLocation == '/login';

    if (isLoggedIn && isLoggingIn) {
      return '/home';
    }

    if (!isLoggedIn && state.matchedLocation == '/home') {
      return '/login';
    }

    return null;
  },
  routes: [
    // 1. Màn hình Login
    GoRoute(path: '/', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
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
