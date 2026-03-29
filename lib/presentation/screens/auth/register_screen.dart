import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading_plus/flutter_easyloading_plus.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_shadow.dart';
import 'cubit/register_cubit.dart';
import 'cubit/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    phoneNumber.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF3c81c6);

    return BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.status == RegisterStatus.loading) {
            EasyLoading.show(
              status: 'Đang đăng ký...',
              maskType: EasyLoadingMaskType.black,
            );
          } else {
            EasyLoading.dismiss();
            if (state.status == RegisterStatus.success) {
              EasyLoading.showSuccess(state.message ?? "Đăng ký thành công");
              context.go('/login');
            } else if (state.status == RegisterStatus.failure) {
              EasyLoading.showError(state.message ?? "Đăng ký thất bại");
            }
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F7FA), // Light modern background
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 60, bottom: 50),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Image(
                          image: AssetImage("assets/icon.png"),
                          width: 50,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "EHealth",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Tham gia ngay để chăm sóc sức khỏe",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                // Form Card overlaps the header slightly
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppShadow.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(
                            child: Text(
                              "Đăng ký tài khoản",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // --- Input Họ và tên ---
                          const Text(
                            "Họ và tên",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          BlocBuilder<RegisterCubit, RegisterState>(
                            buildWhen: (p, c) => p.nameError != c.nameError,
                            builder: (context, state) {
                              return TextField(
                                controller: nameController,
                                style: const TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF8F9FA),
                                  hintText: "Nhập họ và tên của bạn",
                                  hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
                                  errorText: state.nameError,
                                  prefixIcon: const Icon(Icons.person_outline, color: primaryColor, size: 20),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: primaryColor, width: 0.5),
                                  ),
                                  errorMaxLines: 3,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // --- Input Số điện thoại ---
                          const Text(
                            "Số điện thoại",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          BlocBuilder<RegisterCubit, RegisterState>(
                            buildWhen: (p, c) => p.phoneError != c.phoneError,
                            builder: (context, state) {
                              return TextField(
                                controller: phoneNumber,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF8F9FA),
                                  prefixIcon: const Icon(Icons.phone_android_outlined, color: primaryColor, size: 20),
                                  hintText: "Nhập số điện thoại của bạn",
                                  hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
                                  errorText: state.phoneError,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: primaryColor, width: 0.5),
                                  ),
                                  errorMaxLines: 3,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // --- Input Mật khẩu ---
                          const Text(
                            "Mật khẩu",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          BlocBuilder<RegisterCubit, RegisterState>(
                            buildWhen: (p, c) => p.passwordError != c.passwordError,
                            builder: (context, state) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return TextField(
                                    controller: passwordController,
                                    obscureText: _obscurePassword,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xFFF8F9FA),
                                      prefixIcon: const Icon(Icons.lock_outline, color: primaryColor, size: 20),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                          color: Colors.black54,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                      ),
                                      hintText: "Nhập mật khẩu",
                                      hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
                                      errorText: state.passwordError,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: primaryColor, width: 0.5),
                                      ),
                                      errorMaxLines: 3,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          // --- Nút Đăng ký ---
                          BlocBuilder<RegisterCubit, RegisterState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: state.status == RegisterStatus.loading
                                    ? null
                                    : () {
                                        context.read<RegisterCubit>().register(
                                              phone: phoneNumber.text,
                                              name: nameController.text,
                                              password: passwordController.text,
                                            );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                  shadowColor: primaryColor.withOpacity(0.4),
                                ),
                                child: const Text(
                                  "Đăng ký ngay",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Bạn đã có tài khoản? ",
                                style: TextStyle(color: Colors.black54, fontSize: 13),
                              ),
                              GestureDetector(
                                onTap: () => context.go('/login'),
                                child: const Text(
                                  "Đăng nhập ngay",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Keep some padding at the bottom
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
    );
  }
}
