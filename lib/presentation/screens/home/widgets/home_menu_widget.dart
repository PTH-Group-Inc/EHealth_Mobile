import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeMenuWidget extends StatelessWidget {
  const HomeMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Màu chủ đạo
    const Color primaryColor = Color(0xFF3c81c6);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMenuItem(
                context,
                "assets/calendar-year-month-date-health-schedule-hospital-svgrepo-com.png",
                'Đặt lịch\nkhám',
                '/all-facility',
                primaryColor,
              ),
              _buildMenuItem(
                context,
                "assets/clipboard-note-paper-document-hospital-result-medical-svgrepo-com.png",
                'Lịch sử\nkhám bệnh',
                '/ai',
                primaryColor,
              ),
              _buildMenuItem(
                context,
                "assets/medicine-herbal-natural-medical-drug-leaf-health-svgrepo-com.png",
                'Nhắc nhở\nthuốc',
                '/ai',
                primaryColor,
              ),
              _buildMenuItem(
                context,
                'assets/medical-health-care-doctor-hospital-medicine-healthcare-svgrepo-com.png',
                'Gói chăm sóc\ntoàn diện',
                '/ai',
                primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 25),
          // Banner Tư vấn sức khỏe
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFbdebfb),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tư vấn sức khỏe 24/7",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D3B4C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Kết nối ngay với bác sĩ chuyên khoa",
                      style: TextStyle(fontSize: 13, color: Color(0xFF2C5E71)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.push('/ai');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0D3B4C),
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Kết nối ngay",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // Icon trang trí ở góc phải
                Positioned(
                  right: -10,
                  top: -20,
                  bottom: -20,
                  child: Opacity(
                    opacity: 0.15,
                    child: Icon(
                      Icons.health_and_safety,
                      size: 110,
                      color: const Color(0xFF0D3B4C),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget con cho từng Item (Không dùng Expanded để tránh bị lệch layout)
  Widget _buildMenuItem(
    BuildContext context,
    String iconPath,
    String label,
    String route,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        debugPrint("Click: $label $route");
        context.push(route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 226, 247, 252),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image(image: AssetImage(iconPath), fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black87,
              height: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
