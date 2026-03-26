import 'package:flutter/material.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';

class ThemeSettingScreen extends StatefulWidget {
  const ThemeSettingScreen({super.key});

  @override
  State<ThemeSettingScreen> createState() => _ThemeSettingScreenState();
}

class _ThemeSettingScreenState extends State<ThemeSettingScreen> {
  String _selectedTheme = "Cơ bản";

  void _showToast(String message) {
    AppToast.showInfo(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Giao diện ứng dụng",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
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
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSlate,
              ),
            ),
            const SizedBox(height: 12),
            RadioGroup<String>(
              groupValue: _selectedTheme,
              onChanged: (val) {
                if (val == "Tối") {
                  _showToast("Tính năng đang được xây dựng");
                } else if (val != null) {
                  setState(() => _selectedTheme = val);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildThemeOption(
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
  }

  Widget _buildThemeOption({
    required String title,
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        if (value == "Tối") {
          _showToast("Tính năng đang được xây dựng");
        } else {
          setState(() => _selectedTheme = value);
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
            Radio<String>(
              value: value,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
