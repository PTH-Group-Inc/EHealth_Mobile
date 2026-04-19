import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_easyloading_plus/flutter_easyloading_plus.dart';
import 'package:e_health/presentation/screens/auth/cubit/forgot_password_cubit.dart';
import 'package:e_health/presentation/screens/auth/cubit/forgot_password_state.dart';
import '../../../../app/theme/app_color.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.loading) {
          EasyLoading.show(
            status: 'Đang gửi yêu cầu...',
            maskType: EasyLoadingMaskType.black,
          );
        } else {
          EasyLoading.dismiss();
          if (state.isEmailSent) {
            EasyLoading.showSuccess('Mã OTP đã được gửi về email của bạn');
            context.push('/reset-password-otp', extra: state.email);
          } else if (state.status == ForgotPasswordStatus.failure &&
              state.message != null) {
            EasyLoading.showError(state.message!);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textHeader, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    "Quên mật khẩu?",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textHeader,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Nhập email của bạn để nhận mã OTP đặt lại mật khẩu",
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSlate,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Form Container
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
                        _buildLabel("EMAIL"),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: _emailController,
                          hint: "example@health.com",
                          icon: Icons.mail_outline_rounded,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: state.status == ForgotPasswordStatus.loading
                              ? null
                              : () {
                                  if (_emailController.text.isNotEmpty) {
                                    context
                                        .read<ForgotPasswordCubit>()
                                        .sendForgotPasswordEmail(_emailController.text);
                                  } else {
                                    EasyLoading.showError("Vui lòng nhập email");
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
                                "Gửi yêu cầu",
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
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
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
          borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
        ),
      ),
    );
  }
}
