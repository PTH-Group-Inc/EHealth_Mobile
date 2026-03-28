import '../../widgets/feedback/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Màu chủ đạo lấy theo hình (xanh dương)
    final Color primaryColor = const Color(0xFF3c81c6);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Phần hình ảnh minh họa dưới đáy (Background Layer)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.8,
              child: Image.network(
                'https://img.freepik.com/free-vector/hospital-building-concept-illustration_114360-8440.jpg?w=1380&t=st=1709620000~exp=1709620600~hmac=abc',
                fit: BoxFit.cover,
                height: 200,
                // Xử lý khi ảnh lỗi để không bị crash
                errorBuilder: (context, error, stackTrace) =>
                    Container(height: 200, color: Colors.grey[200]),
              ),
            ),
          ),

          // 2. Phần nội dung chính (Foreground Layer)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  // Logo HT
                  const Center(
                    child: Image(
                      image: AssetImage("assets/icon.png"),
                      width: 80,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tiêu đề Đăng nhập
                  const Center(
                    child: Text(
                      "Đăng ký",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // --- Input Email ---
                  const Text(
                    "Số điện thoại",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: phoneNumber,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      prefixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("+84", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      hintText: "Nhập số điện thoại của bạn",
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black26),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black26),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: primaryColor, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Nút Đăng nhập ---
                  ElevatedButton(
                    onPressed: () {
                      debugPrint(phoneNumber.text);
                      // context.push('/register_otp');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Đăng ký ngay",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // --- Dòng Đăng ký ngay ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Bạn đã có tài khoản? ",
                        style: TextStyle(color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: Text(
                          "Đăng nhập ngay",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // --- Divider "Hoặc đăng nhập bằng" ---
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Colors.black26)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Hoặc đăng nhập bằng",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.black26)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // --- Nút đăng nhập SĐT ---
                  OutlinedButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.black26),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          color: primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Đăng nhập bằng Email",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // --- Nút đăng nhập Google ---
                  OutlinedButton(
                    onPressed: () {
                      AppToast.showInfo(context, "Tính năng đang được phát triển");
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.black26),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(
                            "assets/768px-Google_22G22_logo.svg.png",
                          ),
                          width: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Đăng nhập bằng Google",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Khoảng trống để nội dung không bị dính sát đáy khi cuộn
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
