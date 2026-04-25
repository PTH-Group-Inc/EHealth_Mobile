import 'package:e_health/app/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/presentation/screens/ai_assistant/cubit/ai_assistant_cubit.dart';
import 'package:e_health/presentation/screens/ai_assistant/cubit/ai_assistant_state.dart';
import 'package:e_health/presentation/screens/ai_assistant/widgets/chat_bubble.dart';
import 'package:e_health/presentation/screens/ai_assistant/widgets/chat_input.dart';
import 'package:e_health/presentation/screens/ai_assistant/widgets/ai_empty_state.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<AiAssistantCubit>().init();
    
    // Auto scroll to bottom when entering screen if messages exist
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
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
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(child: _buildChatSection()),
          _buildInputSection(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "Trợ lý AI Mii Chan",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline, color: AppColors.white),
          onPressed: () => context.push('/privacy-policy'),
        ),
      ],
    );
  }

  Widget _buildChatSection() {
    return BlocConsumer<AiAssistantCubit, AiAssistantState>(
      listener: (context, state) {
        if (state.status == AiAssistantStatus.typing ||
            state.status == AiAssistantStatus.loading) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        if (state.messages.isEmpty) {
          return const AiEmptyState();
        }
        
        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: state.messages.length,
          itemBuilder: (context, index) {
            final message = state.messages[state.messages.length - 1 - index];
            return ChatBubble(message: message);
          },
        );
      },
    );
  }

  Widget _buildInputSection() {
    return BlocBuilder<AiAssistantCubit, AiAssistantState>(
      builder: (context, state) {
        final isLoading = state.status == AiAssistantStatus.loading ||
                         state.status == AiAssistantStatus.typing;
                         
        return ChatInput(
          controller: _controller,
          isLoading: isLoading,
          onSend: () {
            final text = _controller.text.trim();
            if (text.isNotEmpty) {
              context.read<AiAssistantCubit>().sendMessage(text);
              _controller.clear();
            }
          },
          onStop: () => context.read<AiAssistantCubit>().stopGeneration(),
        );
      },
    );
  }
}
