import 'package:flutter/material.dart';
import 'package:e_health/app/theme/app_color.dart';

class NotesSection extends StatelessWidget {
  final TextEditingController reasonController;
  final TextEditingController notesController;

  const NotesSection({
    super.key,
    required this.reasonController,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Lý do & Ghi chú",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textHeader,
          ),
        ),
        const SizedBox(height: 16),
        _CustomTextField(
          controller: reasonController,
          label: "Lý do đến khám (Tùy chọn)",
          hint: "Vd: Đau đầu, sốt nhẹ...",
        ),
        const SizedBox(height: 16),
        _CustomTextField(
          controller: notesController,
          label: "Ghi chú triệu chứng (Tùy chọn)",
          hint: "Mô tả cụ thể triệu chứng của bạn...",
        ),
      ],
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
