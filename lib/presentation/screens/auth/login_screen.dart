import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_easyloading_plus/flutter_easyloading_plus.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/screens/auth/cubit/auth_cubit.dart';
import 'package:e_health/presentation/screens/auth/cubit/auth_state.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController(
    text: "admin@ehealth.vn",
  );
  final TextEditingController _passwordController = TextEditingController(
    text: "Admin@123",
  );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.loading) {
          EasyLoading.show(
            status: 'Đang đăng nhập...',
            maskType: EasyLoadingMaskType.black,
          );
        } else {
          EasyLoading.dismiss();
          if (state.status == AuthStatus.success) {
            AppToast.showSuccess(context, 'Đăng nhập thành công');
            context.go('/home');
          } else if (state.status == AuthStatus.failure &&
              state.generalError != null) {
            AppToast.showError(context, state.generalError!);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.skyBlue,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              // Hero Header
              _buildHeroHeader(context),

              // Form Area
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Form Card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.06),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Email input
                              _buildLabel("EMAIL HOẶC SỐ ĐIỆN THOẠI"),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _emailController,
                                hint: "example@health.com",
                                icon: Icons.account_circle_outlined,
                                errorText: state.emailError,
                              ),
                              const SizedBox(height: 20),

                              // Password label + forgot
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildLabel("MẬT KHẨU"),
                                  GestureDetector(
                                    onTap: () =>
                                        context.push('/forgot-password'),
                                    child: const Text(
                                      "Quên mật khẩu?",
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _passwordController,
                                hint: "••••••••",
                                icon: Icons.lock_outline_rounded,
                                isPassword: true,
                                obscureText: state.obscurePassword,
                                errorText: state.passwordError,
                                onToggleVisibility: () {
                                  context
                                      .read<AuthCubit>()
                                      .toggleObscurePassword();
                                },
                              ),
                              const SizedBox(height: 28),

                              // Login Button
                              _buildGradientButton(
                                label: "Đăng nhập",
                                isLoading: state.status == AuthStatus.loading,
                                onPressed: () {
                                  context.read<AuthCubit>().login(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Register Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Bạn chưa có tài khoản? ",
                              style: TextStyle(
                                color: AppColors.textSlate,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go('/register'),
                              child: const Text(
                                "Đăng ký ngay",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFooterLink("Bảo mật"),
                            _buildFooterDivider(),
                            _buildFooterLink("Điều khoản"),
                            _buildFooterDivider(),
                            _buildFooterLink("Hỗ trợ"),
                          ],
                        ),
                        // Add bottom padding to allow scrolling above keyboard
                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDarkBlue, AppColors.primary, AppColors.skyBlue],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(
              28,
              MediaQuery.of(context).padding.top + 20,
              28,
              24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Chào mừng trở lại",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Đặt lịch khám dễ dàng, chăm sóc sức khỏe toàn diện",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSlate.withValues(alpha: 0.7),
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    String? errorText,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword && obscureText,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textHeader,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.primaryBackground,
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.textLight.withValues(alpha: 0.8),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
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
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        errorText: errorText,
      ),
    );
  }

  Widget _buildGradientButton({
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.skyBlue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSlate.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildFooterDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 12,
      width: 1,
      color: AppColors.textLight.withValues(alpha: 0.3),
    );
  }
}
