import 'package:flutter/material.dart';

class ThemeSettingScreen extends StatefulWidget {
  const ThemeSettingScreen({super.key});

  @override
  State<ThemeSettingScreen> createState() => _ThemeSettingScreenState();
}

class _ThemeSettingScreenState extends State<ThemeSettingScreen> {
  String _selectedTheme = "Cơ bản";

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Giao diện ứng dụng",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF1E293B)),
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
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
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
                    color: const Color(0xFFF59E0B),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
                  ),
                  _buildThemeOption(
                    title: "Tối",
                    icon: Icons.dark_mode_outlined,
                    value: "Tối",
                    color: const Color(0xFF6366F1),
                  ),
                ],
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
    final bool isSelected = _selectedTheme == value;
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
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedTheme,
              activeColor: const Color(0xFF3B82C4),
              onChanged: (val) {
                if (val == "Tối") {
                  _showToast("Tính năng đang được xây dựng");
                } else if (val != null) {
                  setState(() => _selectedTheme = val);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
