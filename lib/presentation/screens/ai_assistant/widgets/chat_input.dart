import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;
  final VoidCallback onStop;

  const ChatInput({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSend,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TextField(
                  controller: controller,
                  maxLines: 4,
                  minLines: 1,
                  decoration: const InputDecoration(
                    hintText: "Nhập câu hỏi của bạn...",
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: isLoading ? Colors.red.shade400 : const Color(0xFF3B82C4),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isLoading ? Colors.red.shade400 : const Color(0xFF3B82C4)).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: isLoading ? onStop : onSend,
        icon: Icon(
          isLoading ? Icons.stop_rounded : Icons.send_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
