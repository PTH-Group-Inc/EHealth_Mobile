import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/app/theme/app_shadow.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/theme/theme_cubit.dart';
import 'package:e_health/app/theme/theme_state.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';

class ThemeSettingScreen extends StatelessWidget {
  const ThemeSettingScreen({super.key});

  void _showToast(BuildContext context, String message) {
    AppToast.showInfo(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final selectedTheme = state.themeMode == AppThemeMode.light
            ? "Cơ bản"
            : "Tối";

        return Scaffold(
          backgroundColor: AppColors.primaryBackground,
          appBar: AppBar(
            title: const Text(
              "Giao diện ứng dụng",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Chế độ hiển thị",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSlate,
                  ),
                ),
                const SizedBox(height: 12),
                RadioGroup<String>(
                  groupValue: selectedTheme,
                  onChanged: (val) {
                    if (val == "Tối") {
                      _showToast(context, "Tính năng đang được xây dựng");
                    } else if (val == "Cơ bản") {
                      context.read<ThemeCubit>().setTheme(AppThemeMode.light);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppShadow.cardShadow,
                    ),
                    child: Column(
                      children: [
                        _buildThemeOption(
                          context,
                          title: "Cơ bản (Sáng)",
                          icon: Icons.light_mode_outlined,
                          value: "Cơ bản",
                          color: AppColors.warning,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            height: 1,
                            color: Colors.grey.withValues(alpha: 0.1),
                          ),
                        ),
                        _buildThemeOption(
                          context,
                          title: "Tối",
                          icon: Icons.dark_mode_outlined,
                          value: "Tối",
                          color: AppColors.info,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        if (value == "Tối") {
          _showToast(context, "Tính năng đang được xây dựng");
        } else {
          context.read<ThemeCubit>().setTheme(AppThemeMode.light);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
            Radio<String>(value: value, activeColor: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
