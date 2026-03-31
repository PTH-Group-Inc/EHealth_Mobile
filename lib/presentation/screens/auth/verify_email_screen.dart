import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading_plus/flutter_easyloading_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

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
    final Color primaryColor = const Color(0xFF3c81c6);

    final defaultPinTheme = PinTheme(
      width: 45,
      height: 45,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2, color: Colors.grey),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
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
          // Xanh sáng khi success, đỏ khi failure
          PinTheme focusedTheme = defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration?.copyWith(
              border: Border(
                bottom: BorderSide(width: 2, color: primaryColor),
              ),
            ),
          );

          PinTheme submittedTheme = defaultPinTheme;
          
          if (state.status == VerifyEmailStatus.failure) {
            submittedTheme = defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration?.copyWith(
                border: const Border(
                  bottom: BorderSide(width: 2, color: Colors.red),
                ),
              ),
            );
            focusedTheme = submittedTheme;
          } else if (state.status == VerifyEmailStatus.success) {
             submittedTheme = defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration?.copyWith(
                border: const Border(
                  bottom: BorderSide(width: 2, color: Colors.green),
                ),
              ),
            );
            focusedTheme = submittedTheme;
          }

          return Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      const Center(
                        child: Image(
                          image: AssetImage("assets/icon.png"),
                          width: 80,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          "Xác thực email",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            "Nhập mã xác thực đã được gửi đến email ${widget.email}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (_pinController.text.length == 6) {
                            context.read<VerifyEmailCubit>().verifyEmail(widget.email, _pinController.text);
                          } else {
                            AppToast.showError(context, "Vui lòng nhập đủ mã OTP 6 số");
                          }
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
                          "Xác thực email",
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
                          onTap: () {
                            AppToast.showInfo(context, "Tính năng đang được phát triển");
                          },
                          child: const Text(
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
                                context.pop();
                              },
                              child: const Center(child: Text('Đổi email')),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                AppToast.showInfo(context, "Tính năng đang được phát triển");
                              },
                              child: const Center(child: Text('Hỗ trợ')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      ),
    );
  }
}

