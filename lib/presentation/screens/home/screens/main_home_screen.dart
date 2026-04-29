import 'package:e_health/app/theme/app_color.dart';
import 'package:flutter/services.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:e_health/presentation/screens/auth/cubit/auth_cubit.dart';
import 'package:e_health/presentation/screens/auth/cubit/auth_state.dart';
import 'package:e_health/presentation/screens/home/screens/cubit/navigation_cubit.dart';
import 'package:e_health/presentation/screens/home/screens/home_account_screen.dart';
import 'package:e_health/presentation/screens/home/cubit/home_specialty_cubit.dart';
import 'package:e_health/presentation/screens/home/cubit/notification_cubit.dart';
import 'package:e_health/presentation/screens/home/cubit/home_doctor_cubit.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/presentation/screens/home/screens/home_notification_screen.dart';
import 'package:e_health/presentation/screens/home/screens/home_schedule_screen.dart';
import 'package:e_health/presentation/screens/home/screens/home_screen.dart';
import 'package:e_health/app/helper/dialog_helper.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_cubit.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_state.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_state.dart';
import 'package:e_health/presentation/screens/home/widgets/home_app_bar.dart';
import 'package:e_health/presentation/screens/home/widgets/home_bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return const _MainScreenBody();
  }
}

class _MainScreenBody extends StatefulWidget {
  const _MainScreenBody();

  @override
  State<_MainScreenBody> createState() => _MainScreenBodyState();
}

class _MainScreenBodyState extends State<_MainScreenBody> {
  late PageController _pageController;
  DateTime? _lastPressedAt;
  bool _isFirstCheck = true;
  bool _shouldHandleEmpty = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Fetch data if already logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthCubit>().state.status == AuthStatus.success) {
        _fetchData();
      }
    });
  }

  void _fetchData() {
    context.read<HomeSpecialtyCubit>().loadSpecialties();
    context.read<NotificationCubit>().loadNotifications();
    context.read<HomeDoctorCubit>().loadDoctors();
    context.read<UserProfileCubit>().loadProfile();
    context.read<UserProfileCubit>().updateFcmToken();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Phải có ít nhất 2 màn hình
    final List<Widget> pages = [
      HomeScreen(),
      HomeScheduleScreen(),
      HomeNotificationScreen(),
      HomeAccountScreen(),
    ];

    return MultiBlocListener(
      listeners: [
        BlocListener<NavigationCubit, int>(
          listener: (context, state) {
            _pageController.animateToPage(
              state,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              current.status == AuthStatus.success &&
              previous.status != AuthStatus.success,
          listener: (context, state) {
            _fetchData();
          },
        ),
        BlocListener<UserProfileCubit, UserProfileState>(
          listenWhen: (previous, current) =>
              current is UserProfileLoaded && previous is! UserProfileLoaded,
          listener: (context, state) {
            if (state is UserProfileLoaded && _isFirstCheck) {
              _isFirstCheck = false;
              _shouldHandleEmpty = true;
              context.read<MedicalRecordCubit>().loadMedicalRecord(
                state.profile.id,
              );
            }
          },
        ),
        BlocListener<MedicalRecordCubit, MedicalRecordState>(
          listener: (context, state) {
            if (state is MedicalRecordEmpty && _shouldHandleEmpty) {
              _shouldHandleEmpty = false;
              DialogHelper.showNoMedicalRecordPrompt(
                context: context,
                onCreatePressed: () => context.push('/create-medical-record'),
                onLaterPressed: () {
                  debugPrint("Người dùng chọn để sau");
                },
              );
            }
          },
        ),
      ],
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;

              if (currentIndex != 0) {
                context.read<NavigationCubit>().changeTab(0);
                return;
              }

              final now = DateTime.now();
              if (_lastPressedAt == null ||
                  now.difference(_lastPressedAt!) >
                      const Duration(seconds: 2)) {
                _lastPressedAt = now;
                AppToast.showInfo(context, "Ấn lần nữa để thoát");
                return;
              }

              SystemNavigator.pop();
            },
            child: Scaffold(
              extendBody: true,
              backgroundColor: AppColors.white,
              appBar: const HomeAppBar(),
              body: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: pages,
              ),
              bottomNavigationBar: HomeBottomNav(
                selectedIndex: currentIndex,
                onTabChange: (index) {
                  context.read<NavigationCubit>().changeTab(index);
                },
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () => context.push("/ai"),
                backgroundColor: Colors.white,
                elevation: 4,
                icon: Image.asset(
                  "assets/chatbotai.png",
                  width: 24,
                  height: 24,
                ),
                label: const Text(
                  "AI Chat",
                  style: TextStyle(
                    color: Color(0xFF3c81c6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            ),
          );
        },
      ),
    );
  }
}
