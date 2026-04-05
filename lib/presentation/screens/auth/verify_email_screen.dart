import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading_plus/flutter_easyloading_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../app/theme/app_color.dart';
import '../../widgets/feedback/app_toast.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';
import 'cubit/verify_email_cubit.dart';
import 'cubit/verify_email_state.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final String password;

  const VerifyEmailScreen({super.key, required this.email, required this.password});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 55,
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textHeader,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
    );

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
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, authState) {
              if (authState.status == AuthStatus.loading) {
                EasyLoading.show(
                  status: 'Đang đăng nhập...',
                  maskType: EasyLoadingMaskType.black,
                );
              } else if (authState.status == AuthStatus.success) {
                EasyLoading.dismiss();
                EasyLoading.showSuccess('Đăng nhập thành công');
                context.go('/home');
              } else if (authState.status == AuthStatus.failure) {
                EasyLoading.dismiss();
                if (authState.generalError != null) {
                  EasyLoading.showError(authState.generalError!);
                }
              }
            },
          ),
          BlocListener<VerifyEmailCubit, VerifyEmailState>(
            listener: (context, state) {
              if (state.status == VerifyEmailStatus.loading) {
                EasyLoading.show(
                  status: 'Đang xác thực...',
                  maskType: EasyLoadingMaskType.black,
                );
              } else {
                EasyLoading.dismiss();
                if (state.status == VerifyEmailStatus.success) {
                  EasyLoading.showSuccess(state.message ?? "Xác thực email thành công");
                  context.read<AuthCubit>().login(widget.email, widget.password);
                } else if (state.status == VerifyEmailStatus.failure) {
                  AppToast.showError(context, state.message ?? "Mã xác thực không hợp lệ. Vui lòng thử lại.");
                }
              }
            },
          ),
        ],
        child: BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
          builder: (context, state) {
            final focusedTheme = defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration?.copyWith(
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
            );

            final submittedTheme = defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration?.copyWith(
                color: AppColors.grey50,
              ),
            );

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      "Xác thực email",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textHeader,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Nhập mã xác thực đã được gửi đến email của bạn",
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSlate,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.email,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 48),

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
                        children: [
                          Pinput(
                            controller: _pinController,
                            length: 6,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedTheme,
                            submittedPinTheme: submittedTheme,
                            onCompleted: (pin) {
                              context.read<VerifyEmailCubit>().verifyEmail(widget.email, pin);
                            },
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              if (_pinController.text.length == 6) {
                                context.read<VerifyEmailCubit>().verifyEmail(widget.email, _pinController.text);
                              } else {
                                AppToast.showError(context, "Vui lòng nhập đủ mã OTP 6 số");
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
                                  "Xác thực ngay",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.verified_user_rounded, size: 20),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: () {
                              AppToast.showInfo(context, "Tính năng đang được phát triển");
                            },
                            child: Text(
                              'Gửi lại mã xác thực',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildFooterLink("ĐỔI EMAIL", () => context.pop()),
                        _buildFooterDivider(),
                        _buildFooterLink("HỖ TRỢ", () => AppToast.showInfo(context, "Tính năng đang được phát triển")),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textSlate.withValues(alpha: 0.7),
          letterSpacing: 0.5,
        ),
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
