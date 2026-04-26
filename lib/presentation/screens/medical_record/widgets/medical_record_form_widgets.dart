import 'package:flutter/material.dart';
import 'package:e_health/app/theme/app_color.dart';

class MedicalRecordSectionTitle extends StatelessWidget {
  final String title;
  const MedicalRecordSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textHeader,
      ),
    );
  }
}

class MedicalRecordInputLabel extends StatelessWidget {
  final String label;
  const MedicalRecordInputLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
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
}

class MedicalRecordTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final int maxLines;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;

  const MedicalRecordTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryBorder.withValues(alpha: 0.5),
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.textSlate,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: InputBorder.none,
          errorStyle: const TextStyle(fontSize: 11),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, size: 20, color: AppColors.textSlate)
              : null,
        ),
      ),
    );
  }
}

class MedicalRecordGenderDropdown extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String?> onChanged;

  const MedicalRecordGenderDropdown({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryBorder.withValues(alpha: 0.5),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedGender,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textSlate,
          ),
          items: const [
            DropdownMenuItem(value: "MALE", child: Text("Nam")),
            DropdownMenuItem(value: "FEMALE", child: Text("Nữ")),
            DropdownMenuItem(value: "OTHER", child: Text("Khác")),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
