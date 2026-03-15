import 'package:e_health/features/home/presentation/screens/bloc/navigation_cubit.dart';
import 'package:e_health/features/home/presentation/screens/home_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'home_notification_screen.dart';
import 'home_schedule_screen.dart';
import 'home_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// 1. Đổi tên class này thành MainScreen (Màn hình chính chứa cái khung)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: _MainScreenBody(),
    );
  }
}

// Widget con nằm bên trong BlocProvider
class _MainScreenBody extends StatelessWidget {
  const _MainScreenBody();

  final Color primaryColor = const Color(0xFF3c81c6);

  @override
  Widget build(BuildContext context) {
    // 1. Phải có ít nhất 2 màn hình
    final List<Widget> pages = [
      HomeScreen(),
      HomeScheduleScreen(),
      HomeNotificationScreen(),
      HomeAccountScreen(),
    ];

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            actions: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  context.push('/notifications');
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Xin chào",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "HuyNhatTran",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: GestureDetector(
                  onTap: () {
                    context.push('/search');
                    print("Chuyển sang màn hình tìm kiếm...");
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
          body: IndexedStack(index: currentIndex, children: pages),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(.1),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 8,
                ),
                child: GNav(
                  rippleColor: Colors.grey[300]!,
                  hoverColor: Colors.grey[100]!,
                  gap: 8,
                  activeColor: primaryColor,
                  iconSize: 24,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  duration: const Duration(milliseconds: 400),
                  tabBackgroundColor: primaryColor.withOpacity(0.1),
                  color: Colors.black54,
                  selectedIndex: currentIndex,
                  onTabChange: (index) {
                    context.read<NavigationCubit>().changeTab(index);
                  },
                  tabs: [
                    const GButton(icon: Icons.home_outlined, text: 'Trang chủ'),
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
            icon: Image.asset("assets/chatbotai.png", width: 24, height: 24),
            label: const Text(
              "AI Chat",
              style: TextStyle(
                color: Color(0xFF3c81c6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
