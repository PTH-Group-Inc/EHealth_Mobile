import 'package:e_health/features/auth/presentation/screens/login_screen.dart';
import 'package:e_health/features/auth/presentation/screens/register_otp_screen.dart';
import 'package:e_health/features/auth/presentation/screens/register_screen.dart';
import 'package:e_health/features/home/presentation/screens/home_ai_assistant.dart';
import 'package:e_health/features/home/presentation/screens/main_home_screen.dart';
import 'package:e_health/features/medical_facility/presentation/screens/all_medical_facility_screen.dart';
import 'package:e_health/features/search/presentation/pages/search_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/', // Mở app lên là vào đây đầu tiên
  routes: [
    // 1. Màn hình Login
    GoRoute(
      path: '/',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/ai',
      builder: (context, state) => HomeAiAssistant(),
    ),
    GoRoute(
      path: '/register_otp',
      builder: (context, state) => RegisterOtpScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => SearchScreen(),
    ),
    GoRoute(
      path: '/all-facility',
      builder: (context, state) => AllMedicalFacilityScreen(),
    ),
    // GoRoute(
    //   path: '/facility/:id',
    //   builder: (context, state) {
    //     final id = state.pathParameters['id']!;
    //     return ProductInfoScreen(productId: id);
    //   },
    // ),
    // 2. Màn hình Home
    GoRoute(
      path: '/home',
      builder: (context, state) => MainScreen(),

      // 3. Màn hình con (Nested Route)
      // Đường dẫn sẽ là: /home/details
      // routes: [
      //   GoRoute(
      //     path: 'details',
      //     builder: (context, state) => DetailsScreen(),
      //   ),
      // ],
    ),
  ],
);