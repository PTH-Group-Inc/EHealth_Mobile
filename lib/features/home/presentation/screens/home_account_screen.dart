import 'package:flutter/material.dart';

class HomeAccountScreen extends StatefulWidget {
  const HomeAccountScreen({super.key});

  @override
  State<HomeAccountScreen> createState() => _HomeAccountScreenState();
}

class _HomeAccountScreenState extends State<HomeAccountScreen> {
  Color primaryColor = Color(0xFF3c81c6);

  @override
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          // --- SECTION: TÀI KHOẢN ---
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              "Tài khoản",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3B82C4),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Item 1
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F7FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFDCEBFF)),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF3B82C4),
                      size: 22,
                    ),
                  ),
                  title: Text(
                    "Thông tin cá nhân",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF3B82C4),
                    size: 20,
                  ),
                ),
                const Divider(
                  height: 1,
                  indent: 70,
                  endIndent: 20,
                  color: Color(0xFFF1F5F9),
                ),
                // Item 2
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F7FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFDCEBFF)),
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF3B82C4),
                      size: 22,
                    ),
                  ),
                  title: Text(
                    "Đổi mật khẩu",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF3B82C4),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // --- SECTION: TUỲ CHỌN ---
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              "Tuỳ chọn",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3B82C4),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F7FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFDCEBFF)),
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      color: Color(0xFF3B82C4),
                      size: 22,
                    ),
                  ),
                  title: Text(
                    "Giao diện ứng dụng",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF3B82C4),
                    size: 20,
                  ),
                ),
                const Divider(
                  height: 1,
                  indent: 70,
                  endIndent: 20,
                  color: Color(0xFFF1F5F9),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F7FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFDCEBFF)),
                    ),
                    child: const Icon(
                      Icons.language_outlined,
                      color: Color(0xFF3B82C4),
                      size: 22,
                    ),
                  ),
                  title: Text(
                    "Ngôn ngữ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF3B82C4),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // --- SECTION: HỖ TRỢ ---
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              "Hỗ trợ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3B82C4),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F7FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFDCEBFF)),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Color(0xFF3B82C4),
                  size: 22,
                ),
              ),
              title: Text(
                "Chính sách bảo mật",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Color(0xFF3B82C4),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
