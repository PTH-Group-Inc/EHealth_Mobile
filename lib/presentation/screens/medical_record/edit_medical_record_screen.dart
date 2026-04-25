import 'package:e_health/app/helper/validate_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/patient.dart';
import 'package:e_health/data/request/update_patient_request.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/edit_medical_record_cubit.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/edit_medical_record_state.dart';
import 'package:e_health/presentation/screens/medical_record/cubit/medical_record_cubit.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_cubit.dart';
import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_state.dart';

class EditMedicalRecordScreen extends StatefulWidget {
  final Patient patient;
  const EditMedicalRecordScreen({super.key, required this.patient});

  @override
  State<EditMedicalRecordScreen> createState() => _EditMedicalRecordScreenState();
}

class _EditMedicalRecordScreenState extends State<EditMedicalRecordScreen> {
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
    _nameController = TextEditingController(text: widget.patient.fullName);
    _dobController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(widget.patient.dateOfBirth),
    );
    _phoneController = TextEditingController(text: widget.patient.phoneNumber);
    _emailController = TextEditingController(text: widget.patient.email);
    _idCardController = TextEditingController(text: widget.patient.idCardNumber);
    _addressController = TextEditingController(text: widget.patient.address);
    _provinceController = TextEditingController(text: ""); // No ID in domain yet
    _districtController = TextEditingController(text: "");
    _wardController = TextEditingController(text: "");
    _emergencyNameController = TextEditingController(text: widget.patient.emergencyContactName);
    _emergencyPhoneController = TextEditingController(text: widget.patient.emergencyContactPhone);
    _selectedGender = widget.patient.gender;
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
      initialDate: widget.patient.dateOfBirth,
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

  void _onSave() {
    if (_formKey.currentState!.validate()) {
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

      context.read<EditMedicalRecordCubit>().updateMedicalRecord(widget.patient.id, request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditMedicalRecordCubit, EditMedicalRecordState>(
      listener: (context, state) {
        if (state is EditMedicalRecordSuccess) {
          AppToast.showSuccess(context, "Cập nhật hồ sơ thành công");
          
          final profileState = context.read<UserProfileCubit>().state;
          if (profileState is UserProfileLoaded) {
            context.read<MedicalRecordCubit>().loadMedicalRecord(profileState.profile.id);
          }
          
          context.pop(state.patient); 
        } else if (state is EditMedicalRecordError) {
          AppToast.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          title: const Text(
            "Chỉnh sửa hồ sơ",
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Thông tin cá nhân"),
                const SizedBox(height: 16),
                _buildInputLabel("Họ và tên *"),
                _buildTextField(
                  _nameController, 
                  "Nhập họ và tên",
                  validator: (val) => (val == null || val.isEmpty) ? "Vui lòng nhập họ tên" : null,
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel("Ngày sinh *"),
                          InkWell(
                            onTap: _selectDate,
                            child: IgnorePointer(
                              child: _buildTextField(
                                _dobController, 
                                "YYYY-MM-DD",
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
                          _buildInputLabel("Giới tính"),
                          _buildGenderDropdown(),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                _buildInputLabel("Số điện thoại *"),
                _buildTextField(
                  _phoneController, 
                  "Nhập số điện thoại", 
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Vui lòng nhập số điện thoại";
                    if (!ValidateHelper.isValidPhone(val)) return "Số điện thoại không hợp lệ";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                _buildInputLabel("Email"),
                _buildTextField(
                  _emailController, 
                  "Nhập email", 
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val != null && val.isNotEmpty && !ValidateHelper.isValidEmail(val)) {
                      return "Email không hợp lệ";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                _buildInputLabel("CMND/CCCD *"),
                _buildTextField(
                  _idCardController, 
                  "Nhập số định danh",
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Vui lòng nhập CMND/CCCD";
                    if (val.length < 9 || val.length > 12) return "CMND/CCCD phải từ 9-12 số";
                    if (!RegExp(r'^[0-9]+$').hasMatch(val)) return "CMND/CCCD chỉ được chứa số";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                _buildInputLabel("Địa chỉ *"),
                _buildTextField(
                  _addressController, 
                  "Nhập địa chỉ cụ thể", 
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
                          _buildInputLabel("Mã Tỉnh/TP"),
                          _buildTextField(_provinceController, "ID", keyboardType: TextInputType.number),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel("Mã Quận/Huyện"),
                          _buildTextField(_districtController, "ID", keyboardType: TextInputType.number),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel("Mã Phường/Xã"),
                          _buildTextField(_wardController, "ID", keyboardType: TextInputType.number),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                _buildSectionTitle("Thông tin người liên hệ"),
                const SizedBox(height: 16),
                
                _buildInputLabel("Tên người liên hệ *"),
                _buildTextField(
                  _emergencyNameController, 
                  "Nhập tên người liên hệ",
                  validator: (val) => (val == null || val.isEmpty) ? "Nhập tên người liên hệ" : null,
                ),
                const SizedBox(height: 16),
                
                _buildInputLabel("SĐT người liên hệ *"),
                _buildTextField(
                  _emergencyPhoneController, 
                  "Nhập SĐT người liên hệ", 
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Nhập SĐT liên hệ";
                    if (!ValidateHelper.isValidPhone(val)) return "Số điện thoại không hợp lệ";
                    return null;
                  },
                ),
                
                const SizedBox(height: 40),
                
                BlocBuilder<EditMedicalRecordCubit, EditMedicalRecordState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: state is EditMedicalRecordLoading ? null : _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: state is EditMedicalRecordLoading
                            ? const AppLoadingWidget(color: Colors.white, size: 24)
                            : const Text(
                                "Lưu hồ sơ",
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textHeader,
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSlate,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    IconData? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryBorder.withValues(alpha: 0.5)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textSlate, fontSize: 14, fontWeight: FontWeight.normal),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
          errorStyle: const TextStyle(fontSize: 11),
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 20, color: AppColors.textSlate) : null,
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
        border: Border.all(color: AppColors.primaryBorder.withValues(alpha: 0.5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSlate),
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
