import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading_plus/flutter_easyloading_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/app/theme/app_color.dart';
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
        backgroundColor: AppColors.primary,
        body: Column(
          children: [
            // Hero Header
            _buildHeroHeader(context),

            // Form Area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primaryBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Form card
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
                            // Name Input
                            _buildLabel("HỌ VÀ TÊN"),
                            const SizedBox(height: 8),
                            BlocBuilder<RegisterCubit, RegisterState>(
                              buildWhen: (p, c) => p.nameError != c.nameError,
                              builder: (context, state) => _buildTextField(
                                controller: nameController,
                                hint: "Nhập họ và tên đầy đủ",
                                icon: Icons.person_outline_rounded,
                                errorText: state.nameError,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Email/Phone Toggle Section
                            BlocBuilder<RegisterCubit, RegisterState>(
                              buildWhen: (p, c) =>
                                  p.isEmailMode != c.isEmailMode,
                              builder: (context, state) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildLabel(
                                        state.isEmailMode
                                            ? "EMAIL"
                                            : "SỐ ĐIỆN THOẠI",
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<RegisterCubit>()
                                              .toggleRegisterMode(
                                                !state.isEmailMode,
                                              );
                                        },
                                        child: Text(
                                          state.isEmailMode
                                              ? "Dùng số điện thoại"
                                              : "Dùng email",
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  BlocBuilder<RegisterCubit, RegisterState>(
                                    buildWhen: (p, c) =>
                                        p.phoneError != c.phoneError ||
                                        p.emailError != c.emailError ||
                                        p.isEmailMode != c.isEmailMode,
                                    builder: (context, state) =>
                                        _buildTextField(
                                          controller: state.isEmailMode
                                              ? emailController
                                              : phoneNumber,
                                          hint: state.isEmailMode
                                              ? "example@health.com"
                                              : "0912 345 678",
                                          icon: state.isEmailMode
                                              ? Icons.mail_outline_rounded
                                              : Icons.phone_android_rounded,
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
                            const SizedBox(height: 8),
                            BlocBuilder<RegisterCubit, RegisterState>(
                              buildWhen: (p, c) =>
                                  p.passwordError != c.passwordError,
                              builder: (context, state) => _buildTextField(
                                controller: passwordController,
                                hint: "Tối thiểu 8 ký tự",
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
                            const SizedBox(height: 28),

                            // Register Button
                            BlocBuilder<RegisterCubit, RegisterState>(
                              builder: (context, state) => _buildGradientButton(
                                label: "Tạo tài khoản",
                                isLoading:
                                    state.status == RegisterStatus.loading,
                                onPressed: () {
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
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Login redirect
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Đã có tài khoản? ",
                            style: TextStyle(
                              color: AppColors.textSlate,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go('/login'),
                            child: const Text(
                              "Đăng nhập ngay",
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1D6FA4), AppColors.primary, AppColors.skyBlue],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
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
              bottom: 10,
              left: -20,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Back Button + Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const Spacer(),

                  const Text(
                    "Tạo tài khoản",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tham gia để trải nghiệm chăm sóc sức khỏe toàn diện",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
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
        color: AppColors.textSlate.withValues(alpha: 0.7),
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
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
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
