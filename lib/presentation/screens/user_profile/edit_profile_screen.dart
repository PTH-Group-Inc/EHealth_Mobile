import '../auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/theme/app_color.dart';
import '../../../domain/user_profile.dart';
import '../../widgets/feedback/app_toast.dart';
import 'cubit/edit_profile_cubit.dart';
import 'cubit/edit_profile_state.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _addressController;
  late TextEditingController _idController;
  String _selectedGender = "MALE";

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _dobController = TextEditingController(
      text: widget.profile.birthday != null
          ? DateFormat('yyyy-MM-dd').format(widget.profile.birthday!)
          : "",
    );
    _addressController = TextEditingController(text: widget.profile.address);
    _idController = TextEditingController(text: widget.profile.identityCard);
    _selectedGender = widget.profile.gender ?? "MALE";
    // Reset Cubit state each time we enter this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditProfileCubit>().resetState();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _idController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.profile.birthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state.status == EditProfileStatus.success) {
            AppToast.showSuccess(context, "Cập nhật thông tin thành công");
            if (state.profile != null) {
              context.read<AuthCubit>().updateUserInfo(state.profile!.name);
            }
            context.pop(true);
          } else if (state.status == EditProfileStatus.failure) {
            AppToast.showError(context, state.errorMessage ?? "Có lỗi xảy ra");
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text(
                "Chỉnh sửa thông tin",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textDark,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: AppColors.textDark,
                ),
                onPressed: () => context.pop(),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputLabel("Họ và tên"),
                  _buildTextField(_nameController, "Nhập họ và tên"),
                  const SizedBox(height: 20),

                  _buildInputLabel("Ngày sinh"),
                  InkWell(
                    onTap: _selectDate,
                    child: IgnorePointer(
                      child: _buildTextField(
                        _dobController,
                        "YYYY-MM-DD",
                        suffixIcon: Icons.calendar_today_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildInputLabel("Giới tính"),
                  _buildGenderDropdown(),
                  const SizedBox(height: 20),

                  _buildInputLabel("Địa chỉ"),
                  _buildTextField(
                    _addressController,
                    "Nhập địa chỉ",
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),

                  _buildInputLabel("Số CCCD/CMND"),
                  _buildTextField(_idController, "Nhập số định danh"),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.status == EditProfileStatus.loading
                          ? null
                          : () {
                              context.read<EditProfileCubit>().updateProfile(
                                fullName: _nameController.text,
                                dob: _dobController.text,
                                gender: _selectedGender,
                                address: _addressController.text,
                                identityCard: _idController.text,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: state.status == EditProfileStatus.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Lưu thay đổi",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
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

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    IconData? suffixIcon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: InputBorder.none,
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, size: 20, color: AppColors.textMuted)
              : null,
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textMuted,
          ),
          items: const [
            DropdownMenuItem(value: "MALE", child: Text("Nam")),
            DropdownMenuItem(value: "FEMALE", child: Text("Nữ")),
            DropdownMenuItem(value: "OTHER", child: Text("Khác")),
          ],
          onChanged: (val) {
            if (val != null) setState(() => _selectedGender = val);
          },
        ),
      ),
    );
  }
}
