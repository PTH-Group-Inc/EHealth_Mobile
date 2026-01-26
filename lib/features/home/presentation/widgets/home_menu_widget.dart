import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeMenuWidget extends StatelessWidget {
  const HomeMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Màu chủ đạo lấy theo hình (Xanh dương)
    const Color primaryColor = Color(0xFF3c81c6);

    // Data cứng để render (8 món như hình)
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon':
            "assets/calendar-year-month-date-health-schedule-hospital-svgrepo-com.png",
        'label': 'Đặt lịch\nkhám',
        'route': '/all-facility',
      },
      {
        'icon':
            "assets/clipboard-note-paper-document-hospital-result-medical-svgrepo-com.png",
        'label': 'Lịch sử\nkhám bệnh',
        'route': '/ai',
      },
      {
        'icon':
            "assets/file-document-data-health-result-archive-folder-svgrepo-com.png",
        'label': 'Hồ sơ\ncá nhân',
        'route': '/ai',
      },
      {
        'icon':
            "assets/medicine-herbal-natural-medical-drug-leaf-health-svgrepo-com.png",
        'label': 'Nhắc nhở\nthuốc',
        'route': '/ai',
      },
      {
        'icon':
            'assets/medical-health-care-doctor-hospital-medicine-healthcare-svgrepo-com.png',
        'label': 'Gói chăm sóc\ntoàn diện',
        'route': '/ai',
      },
      {
        'icon':
            'assets/clipboard-note-paper-document-hospital-result-medical-svgrepo-com.png',
        'label': 'Kết quả\nkhám',
        'route': '/ai',
      },
      {
        'icon':
            'assets/medicine-drug-health-medical-smartphone-pharmacy-tablet-svgrepo-com.png',
        'label': 'Tra cứu\nkết quả khám',
        'route': '/ai',
      },
      {
        'icon': 'assets/chatbotai.png',
        'label': 'Chatbot\nAI hỗ trợ',
        'route': '/ai',
      },
    ];

    return Container(
      // Padding bên ngoài để tách khỏi mép màn hình (tùy chỉnh)
      margin: const EdgeInsets.all(16.0),

      // YÊU CẦU: Padding của cả background là 10
      padding: const EdgeInsets.all(10.0),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFcce5f9)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            blurRadius: 3,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.24),
            blurRadius: 2,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- HÀNG 1 (4 items đầu) ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < 4; i++)
                _buildMenuItem(context, menuItems[i], primaryColor),
            ],
          ),

          const SizedBox(height: 16), // Khoảng cách giữa 2 hàng
          // --- HÀNG 2 (4 items sau) ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 4; i < 8; i++)
                _buildMenuItem(context, menuItems[i], primaryColor),
            ],
          ),
        ],
      ),
    );
  }

  // Hàm helper nhỏ nằm trong cùng 1 widget để code đỡ rối
  Widget _buildMenuItem(
    BuildContext context,
    Map<String, dynamic> item,
    Color color,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Xử lý click ở đây
          print("Click: ${item['label']} ${item['route']}");
          context.push(item['route']);
        },
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              SizedBox(
                width: 55, // Kích thước nút
                height: 55,
                child: Center(
                  child: Image(
                    image: AssetImage(item['icon'].toString()),
                    width: 45,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Label text bên dưới
              Text(
                item['label'],
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
