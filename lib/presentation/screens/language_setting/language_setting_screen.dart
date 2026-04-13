import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_shadow.dart';
import '../../../../app/theme/app_color.dart';
import '../../widgets/feedback/app_toast.dart';

class LanguageSettingScreen extends StatefulWidget {
  const LanguageSettingScreen({super.key});

  @override
  State<LanguageSettingScreen> createState() => _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends State<LanguageSettingScreen> {
  String _selectedLanguage = "Tiếng Việt";

  void _showToast(String message) {
    AppToast.showInfo(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Ngôn ngữ",
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
              colors: [AppColors.primary, Color(0xFF1E40AF)],
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
              "Chọn ngôn ngữ hiển thị",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSlate,
              ),
            ),
            const SizedBox(height: 12),
            RadioGroup<String>(
              groupValue: _selectedLanguage,
              onChanged: (val) {
                if (val == "Tiếng Anh") {
                  _showToast("Tính năng đang được xây dựng");
                } else if (val != null) {
                  setState(() => _selectedLanguage = val);
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
                    _buildLanguageOption(
                      title: "Tiếng Việt",
                      iconPath: "assets/vietnam_flag.png",
                      icon: Icons.translate,
                      value: "Tiếng Việt",
                      color: Colors.redAccent,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        height: 1,
                        color: Colors.grey.withValues(alpha: 0.1),
                      ),
                    ),
                    _buildLanguageOption(
                      title: "English (Tiếng Anh)",
                      icon: Icons.language,
                      value: "Tiếng Anh",
                      color: Colors.blueAccent,
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

  Widget _buildLanguageOption({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? iconPath,
  }) {
    return InkWell(
      onTap: () {
        if (value == "Tiếng Anh") {
          _showToast("Tính năng đang được xây dựng");
        } else {
          setState(() => _selectedLanguage = value);
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
