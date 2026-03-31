import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_otp_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/auth/verify_email_screen.dart';
import '../presentation/screens/medical_record/medical_record_screen.dart';
import '../presentation/screens/medical_record/medical_record_detail_screen.dart';
import '../presentation/screens/medical_record/edit_medical_record_screen.dart';
import '../presentation/screens/home/screens/main_home_screen.dart';
import '../domain/patient.dart';
import '../presentation/screens/branch/all_branch_screen.dart';
import '../presentation/screens/speciality/all_speciality_screen.dart';
import '../presentation/screens/change_password/change_password_screen.dart';
import '../presentation/screens/search/search_screen.dart';
import '../presentation/screens/user_profile/user_profile_screen.dart';
import '../presentation/screens/theme_setting/theme_setting_screen.dart';
import '../presentation/screens/language_setting/language_setting_screen.dart';
import '../presentation/screens/privacy_policy/privacy_policy_screen.dart';
import '../presentation/screens/ai_assistant/ai_assistant_screen.dart';
import '../presentation/screens/speciality/specialty_detail_screen.dart';
import '../presentation/screens/user_profile/edit_profile_screen.dart';
import '../presentation/screens/doctor/all_doctor_screen.dart';
import '../presentation/screens/doctor/doctor_detail_screen.dart';
import '../presentation/screens/medical_record/create_medical_record_screen.dart';
import '../domain/user_profile.dart';
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
      builder: (context, state) => const ChangePasswordScreen(),
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
      path: '/medical-record',
      name: 'medical-record',
      builder: (context, state) => const MedicalRecordScreen(),
    ),
    GoRoute(
      path: '/medical-record-detail',
      name: 'medical-record-detail',
      builder: (context, state) {
        final patient = state.extra as Patient;
        return MedicalRecordDetailScreen(patient: patient);
      },
    ),
    GoRoute(
      path: '/edit-medical-record',
      name: 'edit-medical-record',
      builder: (context, state) {
        final patient = state.extra as Patient;
        return EditMedicalRecordScreen(patient: patient);
      },
    ),
    GoRoute(
      path: '/create-medical-record',
      name: 'create-medical-record',
      builder: (context, state) => const CreateMedicalRecordScreen(),
    ),
    GoRoute(
      path: '/verify-email',
      name: 'verify-email',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final email = extra['email'] as String? ?? "";
        final password = extra['password'] as String? ?? "";
        return VerifyEmailScreen(email: email, password: password);
      },
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const SearchScreen(),
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
      path: '/specialty-detail/:id',
      name: 'specialty-detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return SpecialtyDetailScreen(departmentId: id);
      },
    ),
    GoRoute(
      path: '/all-doctors',
      name: 'all-doctors',
      builder: (context, state) => const AllDoctorScreen(),
    ),
    GoRoute(
      path: '/doctor-detail/:id',
      name: 'doctor-detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return DoctorDetailScreen(userId: id);
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
