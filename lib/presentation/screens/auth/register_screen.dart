import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading_plus/flutter_easyloading_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_color.dart';
import 'cubit/register_cubit.dart';
import 'cubit/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    phoneNumber.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            if (state.isEmailMode) {
              context.push(
                '/verify-email',
                extra: {
                  'email': emailController.text,
                  'password': passwordController.text,
                },
              );
            } else {
              context.go('/login');
            }
          } else if (state.status == RegisterStatus.failure) {
            EasyLoading.showError(state.message ?? "Đăng ký thất bại");
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                // Title Section
                Text(
                  "Tạo tài khoản mới",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textHeader,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Tham gia để trải nghiệm chăm sóc sức khỏe tốt nhất",
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSlate,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // Form Section
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Name Input
                      _buildLabel("HỌ VÀ TÊN"),
                      const SizedBox(height: 10),
                      BlocBuilder<RegisterCubit, RegisterState>(
                        buildWhen: (p, c) => p.nameError != c.nameError,
                        builder: (context, state) => _buildTextField(
                          controller: nameController,
                          hint: "Nhập họ và tên",
                          icon: Icons.person_outline,
                          errorText: state.nameError,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email/Phone Toggle Section
                      BlocBuilder<RegisterCubit, RegisterState>(
                        buildWhen: (p, c) => p.isEmailMode != c.isEmailMode,
                        builder: (context, state) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(
                              state.isEmailMode ? "EMAIL" : "SỐ ĐIỆN THOẠI",
                            ),
                            const SizedBox(height: 10),
                            BlocBuilder<RegisterCubit, RegisterState>(
                              buildWhen: (p, c) =>
                                  p.phoneError != c.phoneError ||
                                  p.emailError != c.emailError ||
                                  p.isEmailMode != c.isEmailMode,
                              builder: (context, state) => _buildTextField(
                                controller: state.isEmailMode
                                    ? emailController
                                    : phoneNumber,
                                hint: state.isEmailMode
                                    ? "example@health.com"
                                    : "Nhập số điện thoại",
                                icon: state.isEmailMode
                                    ? Icons.mail_outline
                                    : Icons.phone_android_outlined,
                                keyboardType: state.isEmailMode
                                    ? TextInputType.emailAddress
                                    : TextInputType.phone,
                                errorText: state.isEmailMode
                                    ? state.emailError
                                    : state.phoneError,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password Input
                      _buildLabel("MẬT KHẨU"),
                      const SizedBox(height: 10),
                      BlocBuilder<RegisterCubit, RegisterState>(
                        buildWhen: (p, c) => p.passwordError != c.passwordError,
                        builder: (context, state) => _buildTextField(
                          controller: passwordController,
                          hint: "••••••••",
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                          obscureText: _obscurePassword,
                          errorText: state.passwordError,
                          onToggleVisibility: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Register Button
                      BlocBuilder<RegisterCubit, RegisterState>(
                        builder: (context, state) => ElevatedButton(
                          onPressed: state.status == RegisterStatus.loading
                              ? null
                              : () {
                                  if (state.isEmailMode) {
                                    context.read<RegisterCubit>().registerEmail(
                                      email: emailController.text,
                                      name: nameController.text,
                                      password: passwordController.text,
                                    );
                                  } else {
                                    context.read<RegisterCubit>().register(
                                      phone: phoneNumber.text,
                                      name: nameController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Đăng ký ngay",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Toggle Register Mode Link
                      BlocBuilder<RegisterCubit, RegisterState>(
                        buildWhen: (p, c) => p.isEmailMode != c.isEmailMode,
                        builder: (context, state) => Center(
                          child: GestureDetector(
                            onTap: () {
                              context.read<RegisterCubit>().toggleRegisterMode(
                                !state.isEmailMode,
                              );
                            },
                            child: Text(
                              state.isEmailMode
                                  ? "Sử dụng số điện thoại"
                                  : "Sử dụng email cá nhân",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Bạn đã có tài khoản? ",
                            style: TextStyle(
                              color: AppColors.textSlate,
                              fontSize: 13,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go('/login'),
                            child: Text(
                              "Đăng nhập ngay",
                              style: TextStyle(
                                color: AppColors.primary,
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
                const SizedBox(height: 40),

                // External Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFooterLink("BẢO MẬT"),
                    _buildFooterDivider(),
                    _buildFooterLink("ĐIỀU KHOẢN"),
                    _buildFooterDivider(),
                    _buildFooterLink("HỖ TRỢ"),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSlate.withValues(alpha: 0.8),
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword && obscureText,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.grey100,
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.textLight.withValues(alpha: 0.7),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: AppColors.textSlate, size: 22),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textLight,
                  size: 20,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        errorText: errorText,
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSlate.withValues(alpha: 0.7),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildFooterDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 12,
      width: 1,
      color: AppColors.textLight.withValues(alpha: 0.3),
    );
  }
}
