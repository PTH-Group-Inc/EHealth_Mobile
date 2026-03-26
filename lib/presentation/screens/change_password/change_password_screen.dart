import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_cubit.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_state.dart';
import 'cubit/change_password_cubit.dart';
import 'cubit/change_password_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1E293B), size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state.status == ChangePasswordStatus.success) {
            AppToast.showSuccess(context, "Đổi mật khẩu thành công");
            context.pop();
          } else if (state.status == ChangePasswordStatus.failure) {
            AppToast.showError(context, state.message ?? "Đã xảy ra lỗi");
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildFieldLabel("Mật khẩu hiện tại"),
                _buildPasswordField(
                  controller: _oldPasswordController,
                  hint: "Nhập mật khẩu hiện tại",
                  obscureText: state.obscureOldPassword,
                  onToggle: () => context.read<ChangePasswordCubit>().toggleObscureOld(),
                ),
                const SizedBox(height: 20),
                _buildFieldLabel("Mật khẩu mới"),
                _buildPasswordField(
                  controller: _newPasswordController,
                  hint: "Nhập mật khẩu mới",
                  obscureText: state.obscureNewPassword,
                  onToggle: () => context.read<ChangePasswordCubit>().toggleObscureNew(),
                ),
                const SizedBox(height: 20),
                _buildFieldLabel("Xác nhận mật khẩu mới"),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  hint: "Nhập lại mật khẩu mới",
                  obscureText: state.obscureConfirmPassword,
                  onToggle: () => context.read<ChangePasswordCubit>().toggleObscureConfirm(),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: state.status == ChangePasswordStatus.loading
                        ? null
                        : () => _handleChangePassword(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82C4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: state.status == ChangePasswordStatus.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Cập nhật mật khẩu",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: const Color(0xFF64748B),
              size: 20,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }

  void _handleChangePassword(BuildContext context) {
    // Get userId from UserProfileCubit
    final userProfileState = context.read<UserProfileCubit>().state;
    if (userProfileState is UserProfileLoaded) {
      context.read<ChangePasswordCubit>().changePassword(
            userId: userProfileState.profile.id,
            oldPassword: _oldPasswordController.text,
            newPassword: _newPasswordController.text,
            confirmPassword: _confirmPasswordController.text,
          );
    } else {
      AppToast.showError(context, "Không thể xác định người dùng. Hết phiên đăng nhập?");
    }
  }
}
