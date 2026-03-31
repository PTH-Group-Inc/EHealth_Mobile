import '../../auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_color.dart';
import '../../../../app/theme/app_shadow.dart';

class HomeAccountScreen extends StatefulWidget {
  const HomeAccountScreen({super.key});

  @override
  State<HomeAccountScreen> createState() => _HomeAccountScreenState();
}

class _HomeAccountScreenState extends State<HomeAccountScreen> {
  Color primaryColor = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // --- SECTION: TÀI KHOẢN ---
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              "Tài khoản",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadow.cardShadow,
            ),
            child: Column(
              children: [
                ListTile(
                  onTap: () => context.push('/medical-record'),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryBorder),
                    ),
                    child: const Icon(
                      Icons.medical_services_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    "Hồ sơ y tế",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const Divider(
                  height: 1,
                  indent: 70,
                  endIndent: 20,
                  color: AppColors.surface,
                ),
                ListTile(
                  onTap: () => context.push('/profile'),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryBorder),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    "Thông tin cá nhân",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const Divider(
                  height: 1,
                  indent: 70,
                  endIndent: 20,
                  color: AppColors.surface,
                ),
                // Item 2
                ListTile(
                  onTap: () => context.push('/change-password'),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    "Đổi mật khẩu",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSlate,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // --- SECTION: TUỲ CHỌN ---
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              "Tuỳ chọn",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadow.cardShadow,
            ),
            child: Column(
              children: [
                ListTile(
                  onTap: () => context.push('/theme-setting'),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryBorder),
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    "Giao diện ứng dụng",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const Divider(
                  height: 1,
                  indent: 70,
                  endIndent: 20,
                  color: AppColors.surface,
                ),
                ListTile(
                  onTap: () => context.push('/language-setting'),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryBorder),
                    ),
                    child: const Icon(
                      Icons.language_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    "Ngôn ngữ",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // --- SECTION: HỖ TRỢ ---
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              "Hỗ trợ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadow.cardShadow,
            ),
            child: Column(
              children: [
                ListTile(
                  onTap: () => context.push('/privacy-policy'),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryBorder),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    "Chính sách bảo mật",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                ListTile(
                  onTap: () async {
                    final bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Đăng xuất"),
                        content: const Text("Bạn có chắc chắn muốn đăng xuất?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Hủy"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Đăng xuất"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      if (context.mounted) {
                        await context.read<AuthCubit>().logout();
                        if (context.mounted) {
                          context.go('/login');
                        }
                      }
                    }
                  },
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryBorder),
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    "Đăng xuất",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 120),
        ],
      ),
    );
  }
}
