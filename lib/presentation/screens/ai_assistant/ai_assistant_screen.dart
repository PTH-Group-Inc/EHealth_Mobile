import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'cubit/ai_assistant_cubit.dart';
import 'cubit/ai_assistant_state.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input.dart';
import 'widgets/suggestion_chip.dart';
import '../../../../app/theme/app_color.dart';
import '../../../../app/theme/app_shadow.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Trợ lý AI Mii Chan",
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
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.textDark,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSlate),
            onPressed: () => context.push('/privacy-policy'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<AiAssistantCubit, AiAssistantState>(
              listener: (context, state) {
                if (state.status == AiAssistantStatus.typing ||
                    state.status == AiAssistantStatus.loading) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state.messages.isEmpty) {
                  return _buildEmptyState(context);
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(message: state.messages[index]);
                  },
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
              boxShadow: AppShadow.cardShadow,
            ),
            child: Image.asset(
              'assets/chatbotai.png',
              height: 120,
              width: 120,
              errorBuilder: (_, _, _) => const Icon(
                Icons.smart_toy,
                size: 100,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Chào bạn, tôi là Mii Chan!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Tôi có thể giúp bạn tìm kiếm bác sĩ, tư vấn sức khỏe hoặc giải đáp thắc mắc về bệnh viện.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textLight,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "Gợi ý cho bạn",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                SuggestionChip(
                  text: "Cách đặt lịch khám",
                  onTap: () => context.read<AiAssistantCubit>().sendMessage(
                    "Cách đặt lịch khám",
                  ),
                ),
                SuggestionChip(
                  text: "Có bao nhiêu khoa?",
                  onTap: () => context.read<AiAssistantCubit>().sendMessage(
                    "Bệnh viện có bao nhiêu khoa?",
                  ),
                ),
                SuggestionChip(
                  text: "Tư vấn sức khỏe",
                  onTap: () => context.read<AiAssistantCubit>().sendMessage(
                    "Tôi cần tư vấn sức khỏe",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return BlocBuilder<AiAssistantCubit, AiAssistantState>(
      builder: (context, state) {
        return ChatInput(
          controller: _controller,
          isLoading:
              state.status == AiAssistantStatus.loading ||
              state.status == AiAssistantStatus.typing,
          onSend: () {
            if (_controller.text.isNotEmpty) {
              context.read<AiAssistantCubit>().sendMessage(_controller.text);
              _controller.clear();
            }
          },
          onStop: () => context.read<AiAssistantCubit>().stopGeneration(),
        );
      },
    );
  }
}
