import 'package:flutter/material.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:go_router/go_router.dart';

class HomeNewsWidget extends StatefulWidget {
  const HomeNewsWidget({super.key});

  @override
  State<HomeNewsWidget> createState() => _HomeNewsWidgetState();
}

class _HomeNewsWidgetState extends State<HomeNewsWidget> {
  // Dữ liệu giả Tin tức
  final List<Map<String, dynamic>> newsItems = [
    {
      'category': 'DINH DƯỠNG',
      'title': 'Chế độ ăn uống cân bằng giúp tăng cường hệ miễn dịch mùa dịch',
      'time': '15 phút trước',
      'readTime': '5 phút đọc',
      'image': 'assets/chatbotai.png', // Dùng logo AI làm placeholder hoặc icon tin tức
      'color': AppColors.tealDark,
    },
    {
      'category': 'LỐI SỐNG',
      'title': '5 bài tập Yoga đơn giản tại nhà giúp giảm căng thẳng hiệu quả',
      'time': '2 giờ trước',
      'readTime': '4 phút đọc',
      'image': 'assets/chatbotai.png',
      'color': AppColors.blueGrey,
    },
    {
      'category': 'SỨC KHỎE',
      'title': 'Lợi ích của việc kiểm tra sức khỏe định kỳ bạn cần biết',
      'time': '1 ngày trước',
      'readTime': '6 phút đọc',
      'image': 'assets/chatbotai.png',
      'color': AppColors.textDark,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tin tức sức khỏe",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/ai'),
                child: const Text(
                  "Tất cả",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.skyBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Danh sách tin tức theo dạng cột (dọc)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: newsItems.length,
            itemBuilder: (context, index) {
              return _buildNewsItem(newsItems[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(Map<String, dynamic> news) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hình ảnh bên trái
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: news['color'],
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(12),
            child: Stack(
              children: [
                // Giả lập giao diện tờ báo/icon tin tức
                Center(
                  child: Container(
                    width: 60,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Container(height: 10, color: Colors.grey[300]),
                        const SizedBox(height: 4),
                        for (int i = 0; i < 3; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Container(height: 2, color: Colors.grey[200]),
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  left: 5,
                  child: Icon(Icons.person, size: 14, color: Colors.orange[300]),
                )
              ],
            ),
          ),
          const SizedBox(width: 15),
          // Nội dung bên phải
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news['category'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightAqua,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  news['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${news['time']} • ${news['readTime']}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
