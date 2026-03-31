import 'package:flutter/services.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../auth/cubit/auth_state.dart';
import 'cubit/navigation_cubit.dart';
import 'home_account_screen.dart';
import '../cubit/home_specialty_cubit.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/home_doctor_cubit.dart';
import '../../user_profile/cubit/user_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme/app_color.dart';
import '../../../../app/theme/app_shadow.dart';
import 'package:go_router/go_router.dart';
import 'home_notification_screen.dart';
import 'home_schedule_screen.dart';
import 'home_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
              backgroundColor: Colors.white,
              appBar: AppBar(
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {
                      AppToast.showInfo(
                        context,
                        "Tính năng đang được xây dụng",
                      );
                    },
                  ),
                ],
                flexibleSpace: Image(
                  image: AssetImage(
                    "assets/360_F_466415129_mTSxvYJ6ugmN2UBv6ZYsxTYdQGj0p2YM.jpg",
                  ),
                  fit: BoxFit.fitHeight,
                ),
                toolbarHeight: 90,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Image(image: AssetImage('assets/icon.png')),
                ),
                title: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    final name = authState.userName ?? "Người dùng";
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Xin chào",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          name,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: GestureDetector(
                      onTap: () {
                        context.push('/search');
                        debugPrint("Chuyển sang màn hình tìm kiếm...");
                      },
                      child: Container(
                        // Giữ padding dọc giống contentPadding cũ (vertical: 14)
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white, // filledColor cũ
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // borderRadius của border cũ
                          border: Border.all(
                            color: const Color(0xFF3c81c6), // Màu viền cũ
                            width: 2, // Độ dày viền cũ
                          ),
                          // Nếu muốn thêm bóng (elevation) thì dùng boxShadow ở đây
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: Colors
                                  .grey, // Màu mặc định của icon trong TextField thường là grey
                            ),
                            const SizedBox(
                              width: 12,
                            ), // Khoảng cách giữa icon và text
                            Expanded(
                              child: Text(
                                'Tìm kiếm bác sĩ, triệu chứng, v.v...',
                                style: TextStyle(
                                  color: Colors
                                      .grey[600], // Màu text cho giống hintText
                                  fontSize: 16, // Cỡ chữ mặc định của TextField
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // Cắt bớt nếu text quá dài
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              body: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: pages,
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: AppShadow.cardShadow,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 8,
                    ),
                    child: GNav(
                      rippleColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      gap: 8,
                      activeColor: AppColors.primary,
                      iconSize: 24,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      duration: const Duration(milliseconds: 400),
                      tabBackgroundColor: AppColors.primary.withValues(
                        alpha: 0.1,
                      ),
                      color: Colors.black54,
                      selectedIndex: currentIndex,
                      onTabChange: (index) {
                        context.read<NavigationCubit>().changeTab(index);
                      },
                      tabs: [
                        const GButton(
                          icon: Icons.home_outlined,
                          text: 'Trang chủ',
                        ),
                        const GButton(
                          icon: Icons.calendar_today_outlined,
                          text: 'Lịch khám',
                        ),
                        const GButton(
                          icon: Icons.chat_bubble_outline_outlined,
                          text: 'Thông báo',
                        ),
                        const GButton(
                          icon: Icons.account_circle_outlined,
                          text: 'Tài khoản',
                        ),
                      ],
                    ),
                  ),
                ),
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
