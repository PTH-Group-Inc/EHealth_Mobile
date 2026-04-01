import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/theme/app_shadow.dart';

class HomeBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const HomeBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
            tabs: const [
               GButton(
                icon: Icons.home_outlined,
                text: 'Trang chủ',
              ),
               GButton(
                icon: Icons.calendar_today_outlined,
                text: 'Lịch khám',
              ),
               GButton(
                icon: Icons.chat_bubble_outline_outlined,
                text: 'Thông báo',
              ),
               GButton(
                icon: Icons.account_circle_outlined,
                text: 'Tài khoản',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
