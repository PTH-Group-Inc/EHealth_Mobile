import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../cubit/ai_assistant_state.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAiHeader(),
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUser && message.isLoading)
                _buildLoadingBubble()
              else if (!isUser)
                _buildAiBubble(context)
              else
                _buildUserBubble(context),
            ],
          ),
          if (message.suggestedDepartment != null) _buildSuggestionCard(context),
        ],
      ),
    );
  }

  Widget _buildAiHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_outlined, size: 16, color: Color(0xFF3B82C4)),
          ),
          const SizedBox(width: 8),
          Text(
            "Mii Chan • ${_formatTime(message.timestamp)}",
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Color(0xFF3B82C4))),
          ),
          const SizedBox(width: 8),
          Text(
            "Đang soạn thảo...",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildAiBubble(BuildContext context) {
    return Flexible(
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: MarkdownBody(
          data: message.text,
          styleSheet: MarkdownStyleSheet(
            p: const TextStyle(color: Color(0xFF334155), fontSize: 15, height: 1.5),
            strong: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
        ),
      ),
    );
  }

  Widget _buildUserBubble(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3B82C4), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Text(
        message.text,
        style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
      ),
    );
  }

  Widget _buildSuggestionCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Tính năng xem cơ sở y tế ${message.suggestedDepartment} đang hoàn thiện")),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBAE6FD)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_hospital_outlined, size: 16, color: Color(0xFF0369A1)),
              const SizedBox(width: 8),
              Text(
                "Khám chuyên khoa ${message.suggestedDepartment} →",
                style: const TextStyle(color: Color(0xFF0369A1), fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) => "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
}
