import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_color.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text(
          "Chính sách bảo mật",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chính sách bảo mật của EHealth",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "Chào mừng bạn đến với EHealth. Chúng tôi cam kết bảo vệ thông tin cá nhân của bạn và sự minh bạch trong việc sử dụng dữ liệu.\n\n"
                "1. Thu thập dữ liệu:\n"
                "Chúng tôi thu thập các thông tin cá nhân như họ tên, số điện thoại, email và hồ sơ bệnh lý khi bạn đăng ký và sử dụng dịch vụ đặt lịch.\n\n"
                "2. Mục đích sử dụng:\n"
                "- Kết nối bạn với các cơ sở y tế nhanh chóng.\n"
                "- Cung cấp tư vấn sức khỏe thông qua trợ lý AI.\n"
                "- Cải thiện trải nghiệm người dùng trên ứng dụng.\n\n"
                "3. Chia sẻ thông tin:\n"
                "Chúng tôi CHỈ chia sẻ dữ liệu của bạn với cơ sở y tế mà bạn đặt lịch khám. Chúng tôi không bán dữ liệu cho bên thứ ba.\n\n"
                "4. Bảo mật dữ liệu:\n"
                "Dữ liệu của bạn được lưu trữ trên máy chủ an toàn và được mã hóa đầu cuối.\n\n"
                "5. Quyền lợi của bạn:\n"
                "Bạn có quyền yêu cầu xem, chỉnh sửa hoặc xóa dữ liệu cá nhân của mình bất cứ lúc nào thông qua phần cài đặt tài khoản.\n\n"
                "Việc bạn tiếp tục sử dụng ứng dụng này đồng nghĩa với việc bạn đồng ý với toàn bộ các điều khoản trong chính sách bảo mật này.",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
