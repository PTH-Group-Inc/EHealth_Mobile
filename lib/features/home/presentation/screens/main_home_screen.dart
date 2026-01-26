import 'package:e_health/features/home/presentation/screens/bloc/navigation_cubit.dart';
import 'package:e_health/features/home/presentation/screens/home_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'home_notification_screen.dart';
import 'home_schedule_screen.dart';
import 'home_screen.dart';

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
      SizedBox(),
      HomeNotificationScreen(),
      HomeAccountScreen(),
    ];

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          // backgroundColor: Color(0xFFF6F6F6),
          backgroundColor: const Color(0xFFF8FAFC),
          // extendBodyBehindAppBar: true, // quan trọng
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
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
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white, // filledColor cũ
                      borderRadius: BorderRadius.circular(10), // borderRadius của border cũ
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
                          color: Colors.grey, // Màu mặc định của icon trong TextField thường là grey
                        ),
                        const SizedBox(width: 12), // Khoảng cách giữa icon và text
                        Expanded(
                          child: Text(
                            'Tìm kiếm bác sĩ, triệu chứng, v.v...',
                            style: TextStyle(
                              color: Colors.grey[600], // Màu text cho giống hintText
                              fontSize: 16, // Cỡ chữ mặc định của TextField
                            ),
                            overflow: TextOverflow.ellipsis, // Cắt bớt nếu text quá dài
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ),
          ),
          body: IndexedStack(index: currentIndex, children: pages),
          bottomNavigationBar: NavigationBar(
            height: 110,
            indicatorColor: const Color(0xFF63acf5),
            selectedIndex: currentIndex,
            onDestinationSelected: (int newIndex) {
              context.read<NavigationCubit>().changeTab(newIndex);
            },

            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Trang chủ',
              ),
              // Mở cái này ra là hết lỗi ngay
              const NavigationDestination(
                icon: Icon(Icons.calendar_today_outlined),
                selectedIcon: Icon(Icons.calendar_month_outlined),
                label: 'Lịch khám',
              ),
              NavigationDestination(
                icon: GestureDetector(
                  onTap: () {
                    context.push("/ai");
                  },
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/chatbotai.png")),
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  // child: const Image(image: AssetImage("assets/chatbotai.png")),
                ),
                label: '',
              ),
              const NavigationDestination(
                icon: Icon(Icons.chat_bubble_outline_outlined),
                selectedIcon: Icon(Icons.chat_bubble_outlined),
                label: 'Thông báo',
              ),
              const NavigationDestination(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Tài khoản',
              ),
            ],
          ),
        );
      },
    );
  }
}
