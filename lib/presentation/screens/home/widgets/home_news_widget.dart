import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/news.dart';

class HomeNewsWidget extends StatefulWidget {
  const HomeNewsWidget({super.key});

  @override
  State<HomeNewsWidget> createState() => _HomeNewsWidgetState();
}

class _HomeNewsWidgetState extends State<HomeNewsWidget> {
  // Mockup data using News domain model
  final List<News> newsItems = [
    News(
      id: '1',
      category: 'DINH DƯỠNG',
      title: 'Chế độ ăn uống cân bằng giúp tăng cường hệ miễn dịch mùa dịch',
      content:
          '''Một chế độ dinh dưỡng hợp lý đầy đủ các nhóm chất là chìa khóa để duy trì một hệ miễn dịch khỏe mạnh. Bạn nên tập trung vào các loại thực phẩm giàu Vitamin C như cam, chanh, bưởi, và các loại rau xanh.

Ngoài ra, việc bổ sung đầy đủ Protein từ thịt, cá, trứng, sữa cũng rất quan trọng vì đây là nguyên liệu xây dựng các tế bào miễn dịch. Đừng quên uống đủ 2 lít nước mỗi ngày và hạn chế các loại thực phẩm chế biến sẵn, nhiều đường.

Các chuyên gia khuyên rằng bạn nên đa dạng hóa thực đơn hằng ngày để đảm bảo cung cấp đủ các vi chất cần thiết như Kẽm, Sắt và Vitamin D.''',
      date: '15 phút trước',
      readTime: '5 phút đọc',
      author: 'BS. Nguyễn Văn An',
      imageUrl: 'assets/chatbotai.png',
      categoryColor: AppColors.tealDark,
    ),
    News(
      id: '2',
      category: 'LỐI SỐNG',
      title: '5 bài tập Yoga đơn giản tại nhà giúp giảm căng thẳng hiệu quả',
      content:
          '''Trong cuộc sống hiện đại đầy áp lực, Yoga là một phương pháp tuyệt vời để tìm lại sự cân bằng. Dưới đây là 5 tư thế đơn giản bạn có thể thực hiện ngay tại nhà:

1. Tư thế em bé (Child's Pose): Giúp thư giãn hoàn toàn hệ thần kinh.
2. Tư thế chó úp mặt (Downward-facing Dog): Tăng cường lưu thông máu lên não.
3. Tư thế ngọn núi (Mountain Pose): Cải thiện tư thế và sự tập trung.
4. Tư thế cây (Tree Pose): Rèn luyện khả năng giữ thăng bằng và tĩnh tâm.
5. Tư thế xác chết (Savasana): Thư giãn sâu sau buổi tập.

Chỉ cần dành ra 15-20 phút mỗi ngày, bạn sẽ thấy tinh thần sảng khoái và giảm bớt các cơn đau mỏi vai gáy do ngồi làm việc quá lâu.''',
      date: '2 giờ trước',
      readTime: '4 phút đọc',
      author: 'HLV. Thanh Mai',
      imageUrl: 'assets/chatbotai.png',
      categoryColor: Color(0xFF607D8B),
    ),
    News(
      id: '3',
      category: 'SỨC KHỎE',
      title: 'Lợi ích của việc kiểm tra sức khỏe định kỳ bạn cần biết',
      content:
          '''Kiểm tra sức khỏe định kỳ không chỉ là việc đi khám khi có bệnh mà là một thói quen văn minh để bảo vệ bản thân. 

Các lợi ích chính bao gồm:
- Phát hiện sớm các mầm mống bệnh lý nguy hiểm như ung thư, tiểu đường, tim mạch.
- Đánh giá tổng quát chức năng các cơ quan trong cơ thể.
- Nhận được lời khuyên điều chỉnh lối sống từ bác sĩ chuyên khoa.
- Tiết kiệm chi phí điều trị lâu dài nhờ can thiệp kịp thời.

Các bác sĩ khuyến nghị mọi người nên đi tầm soát sức khỏe ít nhất 6 tháng hoặc 1 năm một lần tùy theo độ tuổi và tình trạng sức khỏe hiện tại.''',
      date: '1 ngày trước',
      readTime: '6 phút đọc',
      author: 'ThS. BS. Trần Thị Bình',
      imageUrl: 'assets/chatbotai.png',
      categoryColor: AppColors.textDark,
    ),
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
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Tin tức sức khỏe",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {}, // Future: See all news screen
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
          // News list items
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

  Widget _buildNewsItem(News news) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () => context.push('/news/${news.id}', extra: news),
        borderRadius: BorderRadius.circular(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Hero(
              tag: 'news_image_${news.id}',
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: news.categoryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(12),
                child: Center(
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
                            child: Container(
                              height: 2,
                              color: Colors.grey[200],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            // Content section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: news.categoryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    news.title,
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
                    "${news.date} • ${news.readTime}",
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
      ),
    );
  }
}
