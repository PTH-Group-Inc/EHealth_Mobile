import 'package:e_health/app/helper/validate_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/data/request/update_patient_request.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_cubit.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_state.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/create_medical_record_cubit.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/create_medical_record_state.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_cubit.dart';
import 'package:e_health/presentation/screens/medical_record/widgets/medical_record_form_widgets.dart';

class CreateMedicalRecordScreen extends StatefulWidget {
  const CreateMedicalRecordScreen({super.key});

  @override
  State<CreateMedicalRecordScreen> createState() => _CreateMedicalRecordScreenState();
}

class _CreateMedicalRecordScreenState extends State<CreateMedicalRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _idCardController;
  late TextEditingController _addressController;
  late TextEditingController _provinceController;
  late TextEditingController _districtController;
  late TextEditingController _wardController;
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;
  String _selectedGender = "MALE";

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dobController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _idCardController = TextEditingController();
    _addressController = TextEditingController();
    _provinceController = TextEditingController();
    _districtController = TextEditingController();
    _wardController = TextEditingController();
    _emergencyNameController = TextEditingController();
    _emergencyPhoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _idCardController.dispose();
    _addressController.dispose();
    _provinceController.dispose();
    _districtController.dispose();
    _wardController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textHeader,
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

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final userState = context.read<UserProfileCubit>().state;
      if (userState is! UserProfileLoaded) {
        AppToast.showError(context, "Không tìm thấy thông tin tài khoản. Vui lòng thử lại.");
        return;
      }

      final request = UpdatePatientRequest(
        full_name: _nameController.text.trim(),
        date_of_birth: _dobController.text,
        gender: _selectedGender,
        phone_number: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        id_card_number: _idCardController.text.trim(),
        address: _addressController.text.trim(),
        province_id: int.tryParse(_provinceController.text),
        district_id: int.tryParse(_districtController.text),
        ward_id: int.tryParse(_wardController.text),
        emergency_contact_name: _emergencyNameController.text.trim(),
        emergency_contact_phone: _emergencyPhoneController.text.trim(),
      );

      context.read<CreateMedicalRecordCubit>().createMedicalRecord(
        request, 
        userState.profile.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateMedicalRecordCubit, CreateMedicalRecordState>(
      listener: (context, state) {
        if (state is CreateMedicalRecordSuccess) {
          AppToast.showSuccess(context, "Thêm hồ sơ y tế thành công");
          
          // Refresh the list
          final userState = context.read<UserProfileCubit>().state;
          if (userState is UserProfileLoaded) {
            context.read<MedicalRecordCubit>().loadMedicalRecord(userState.profile.id);
          }
          
          context.pop();
        } else if (state is CreateMedicalRecordError) {
          AppToast.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          title: const Text(
            "Thêm hồ sơ mới",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: AppColors.textHeader,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MedicalRecordSectionTitle(title: "Thông tin cá nhân"),
                const SizedBox(height: 16),
                
                const MedicalRecordInputLabel(label: "Họ và tên *"),
                MedicalRecordTextField(
                  controller: _nameController, 
                  hint: "Nhập họ và tên",
                  validator: (val) => (val == null || val.isEmpty) ? "Vui lòng nhập họ tên" : null,
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MedicalRecordInputLabel(label: "Ngày sinh *"),
                          InkWell(
                            onTap: _selectDate,
                            child: IgnorePointer(
                              child: MedicalRecordTextField(
                                controller: _dobController, 
                                hint: "YYYY-MM-DD",
                                suffixIcon: Icons.calendar_today_outlined,
                                validator: (val) => (val == null || val.isEmpty) ? "Chọn ngày sinh" : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MedicalRecordInputLabel(label: "Giới tính"),
                          MedicalRecordGenderDropdown(
                            selectedGender: _selectedGender,
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedGender = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                const MedicalRecordInputLabel(label: "Số điện thoại *"),
                MedicalRecordTextField(
                  controller: _phoneController,
                  hint: "Nhập số điện thoại",
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Vui lòng nhập số điện thoại";
                    if (!ValidateHelper.isValidPhone(val)) return "Số điện thoại không hợp lệ";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                const MedicalRecordInputLabel(label: "Email"),
                MedicalRecordTextField(
                  controller: _emailController,
                  hint: "Nhập email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val != null && val.isNotEmpty && !ValidateHelper.isValidEmail(val)) {
                      return "Email không hợp lệ";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                const MedicalRecordInputLabel(label: "CMND/CCCD *"),
                MedicalRecordTextField(
                  controller: _idCardController,
                  hint: "Nhập số định danh",
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Vui lòng nhập CMND/CCCD";
                    if (val.length < 9 || val.length > 12) return "CMND/CCCD phải từ 9-12 số";
                    if (!RegExp(r'^[0-9]+$').hasMatch(val)) return "CMND/CCCD chỉ được chứa số";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                const MedicalRecordInputLabel(label: "Địa chỉ *"),
                MedicalRecordTextField(
                  controller: _addressController, 
                  hint: "Nhập địa chỉ cụ thể", 
                  maxLines: 2,
                  validator: (val) => (val == null || val.isEmpty) ? "Vui lòng nhập địa chỉ" : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MedicalRecordInputLabel(label: "Mã Tỉnh/TP"),
                          MedicalRecordTextField(controller: _provinceController, hint: "ID", keyboardType: TextInputType.number),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MedicalRecordInputLabel(label: "Mã Quận/Huyện"),
                          MedicalRecordTextField(controller: _districtController, hint: "ID", keyboardType: TextInputType.number),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MedicalRecordInputLabel(label: "Mã Phường/Xã"),
                          MedicalRecordTextField(controller: _wardController, hint: "ID", keyboardType: TextInputType.number),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                const MedicalRecordSectionTitle(title: "Thông tin người liên hệ"),
                const SizedBox(height: 16),
                
                const MedicalRecordInputLabel(label: "Tên người liên hệ *"),
                MedicalRecordTextField(
                  controller: _emergencyNameController, 
                  hint: "Nhập tên người liên hệ",
                  validator: (val) => (val == null || val.isEmpty) ? "Nhập tên người liên hệ" : null,
                ),
                const SizedBox(height: 16),
                
                const MedicalRecordInputLabel(label: "SĐT người liên hệ *"),
                MedicalRecordTextField(
                  controller: _emergencyPhoneController,
                  hint: "Nhập SĐT người liên hệ",
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Nhập SĐT liên hệ";
                    if (!ValidateHelper.isValidPhone(val)) return "Số điện thoại không hợp lệ";
                    return null;
                  },
                ),
                
                const SizedBox(height: 40),
                
                BlocBuilder<CreateMedicalRecordCubit, CreateMedicalRecordState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: state is CreateMedicalRecordLoading ? null : _onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: state is CreateMedicalRecordLoading
                            ? const AppLoadingWidget(color: Colors.white, size: 24)
                            : const Text(
                                "Thêm hồ sơ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
