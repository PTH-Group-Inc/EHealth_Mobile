import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_color.dart';
import '../../widgets/feedback/app_toast.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textDark,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(
            color: AppColors.textDark,
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
                  onToggle: () =>
                      context.read<ChangePasswordCubit>().toggleObscureOld(),
                ),
                const SizedBox(height: 20),
                _buildFieldLabel("Mật khẩu mới"),
                _buildPasswordField(
                  controller: _newPasswordController,
                  hint: "Nhập mật khẩu mới",
                  obscureText: state.obscureNewPassword,
                  onToggle: () =>
                      context.read<ChangePasswordCubit>().toggleObscureNew(),
                ),
                const SizedBox(height: 20),
                _buildFieldLabel("Xác nhận mật khẩu mới"),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  hint: "Nhập lại mật khẩu mới",
                  obscureText: state.obscureConfirmPassword,
                  onToggle: () => context
                      .read<ChangePasswordCubit>()
                      .toggleObscureConfirm(),
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
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: state.status == ChangePasswordStatus.loading
                        ? const CircularProgressIndicator(
                            color: AppColors.white,
                          )
                        : const Text(
                            "Cập nhật mật khẩu",
                            style: TextStyle(
                              color: AppColors.white,
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
          color: AppColors.textSlate,
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textSlate,
              size: 20,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }

  void _handleChangePassword(BuildContext context) {
    context.read<ChangePasswordCubit>().changePassword(
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }
}
