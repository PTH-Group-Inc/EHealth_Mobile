import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/theme/app_shadow.dart';
import 'package:e_health/presentation/screens/ai_assistant/cubit/ai_assistant_cubit.dart';
import 'package:e_health/presentation/screens/ai_assistant/widgets/suggestion_chip.dart';

class AiEmptyState extends StatelessWidget {
  const AiEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
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
              color: AppColors.textLight,
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
}
