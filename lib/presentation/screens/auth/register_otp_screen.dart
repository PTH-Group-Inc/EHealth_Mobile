import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class RegisterOtpScreen extends StatefulWidget {
  const RegisterOtpScreen({super.key});

  @override
  State<RegisterOtpScreen> createState() => _RegisterOtpScreenState();
}

class _RegisterOtpScreenState extends State<RegisterOtpScreen> {
  @override
  Widget build(BuildContext context) {
    // Màu chủ đạo lấy theo hình (xanh dương)
    final Color primaryColor = const Color(0xFF3c81c6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Phần hình ảnh minh họa dưới đáy (Background Layer)
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Opacity(
          //     opacity: 0.8,
          //     child: Image.network(
          //       'https://img.freepik.com/free-vector/hospital-building-concept-illustration_114360-8440.jpg?w=1380&t=st=1709620000~exp=1709620600~hmac=abc',
          //       fit: BoxFit.cover,
          //       height: 200,
          //       // Xử lý khi ảnh lỗi để không bị crash
          //       errorBuilder: (context, error, stackTrace) =>
          //           Container(height: 200, color: Colors.grey[200]),
          //     ),
          //   ),
          // ),

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
                      "Xác thực số điện thoại",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        "Nhập mã xác thực đã được gửi đến số điện thoại 0812495055",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    length: 6,
                    defaultPinTheme: PinTheme(
                      width: 45,
                      height: 45,
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2, color: Colors.grey),
                        ),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2, color: Colors.blue),
                        ),
                      ),
                    ),
                    onCompleted: (pin) {},
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => context.push('/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Xác thực số điện thoại",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: GestureDetector(
                      child: Text(
                        'Gửi lại mã xác thực',
                        style: TextStyle(
                          color: Color(0xFF3c81c6),
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            AppToast.showInfo(context, "Tính năng đang được phát triển");
                          },
                          child: Center(child: Text('Đổi số điện thoại')),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            AppToast.showInfo(context, "Tính năng đang được phát triển");
                          },
                          child: Center(child: Text('Hỗ trợ')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
