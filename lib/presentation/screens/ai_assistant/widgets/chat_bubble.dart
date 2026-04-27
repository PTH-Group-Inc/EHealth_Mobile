import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/theme/app_shadow.dart';
import 'package:e_health/presentation/screens/ai_assistant/cubit/ai_assistant_state.dart';
import 'package:e_health/app/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAiHeader(),
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!isUser && message.isLoading)
                _buildLoadingBubble()
              else if (!isUser)
                _buildAiBubble(context)
              else
                _buildUserBubble(context),
            ],
          ),
          if (message.suggestedDepartment != null)
            _buildSuggestionCard(context),
          if (message.actionType == 'ALL_DOCTORS')
            _buildAllDoctorsAction(context),
          if (message.actionType == 'BOOKING_FLOW')
            _buildBookingFlowAction(context),
          if (message.suggestedRoutes != null && message.suggestedRoutes!.isNotEmpty)
            ...message.suggestedRoutes!.map((route) => _buildRouteAction(context, route)),
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
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "Mii Chan • ${_formatTime(message.timestamp)}",
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
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
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppLoadingWidget(
            size: 12,
            strokeWidth: 2,
          ),
          const SizedBox(width: 8),
          Text(
            "Đang soạn thảo...",
            style: TextStyle(
              color: AppColors.grey500,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiBubble(BuildContext context) {
    return Flexible(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadow.inputShadow,
        ),
        child: MarkdownBody(
          data: message.text,
          styleSheet: MarkdownStyleSheet(
            p: const TextStyle(
              color: AppColors.textDark,
              fontSize: 15,
              height: 1.5,
            ),
            strong: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserBubble(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Color(0xFF2563EB)],
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
          if (message.suggestedDepartmentId != null) {
            context.push('/specialty-detail/${message.suggestedDepartmentId}');
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.skyLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.skyBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_hospital_outlined,
                size: 16,
                color: AppColors.skyDark,
              ),
              const SizedBox(width: 8),
              Text(
                "Khám chuyên khoa ${message.suggestedDepartment} →",
                style: const TextStyle(
                  color: AppColors.skyDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllDoctorsAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: InkWell(
        onTap: () => context.push('/all-doctors'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.roseLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.roseBorder),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_outline_rounded,
                size: 16,
                color: AppColors.roseDark,
              ),
              SizedBox(width: 8),
              Text(
                "Xem danh sách bác sĩ →",
                style: TextStyle(
                  color: AppColors.roseDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingFlowAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: InkWell(
        onTap: () => context.push('/patient-select?mode=appointment'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.emeraldLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.emeraldBorder),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 16,
                color: AppColors.emeraldDark,
              ),
              SizedBox(width: 8),
              Text(
                "Đăng ký đặt lịch khám ngay →",
                style: TextStyle(
                  color: AppColors.emeraldDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteAction(BuildContext context, String route) {
    // Find the route info to get the name
    final routeInfo = navigableRoutes.where((r) => r.path == route).firstOrNull;
    final displayName = routeInfo?.name ?? "Mở màn hình";

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: InkWell(
        onTap: () => context.push(route),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.navigation_outlined,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                "Đi đến $displayName →",
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) =>
      "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
}
