import 'package:e_health/gemini_services.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isLoading;
  final String? suggestedDepartment;
  final String? suggestedDepartmentId;
  final String? actionType;
  final String? suggestedRoute;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isLoading = false,
    this.suggestedDepartment,
    this.suggestedDepartmentId,
    this.actionType,
    this.suggestedRoute,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  ChatMessage copyWith({
    String? text,
    bool? isUser,
    bool? isLoading,
    String? suggestedDepartment,
    String? suggestedDepartmentId,
    String? actionType,
    String? suggestedRoute,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      isLoading: isLoading ?? this.isLoading,
      suggestedDepartment: suggestedDepartment ?? this.suggestedDepartment,
      suggestedDepartmentId:
          suggestedDepartmentId ?? this.suggestedDepartmentId,
      actionType: actionType ?? this.actionType,
      suggestedRoute: suggestedRoute ?? this.suggestedRoute,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

enum AiAssistantStatus { initial, loading, typing, success, failure }

class AiAssistantState {
  final List<ChatMessage> messages;
  final List<ChatHistory> history;
  final AiAssistantStatus status;
  final String? errorMessage;
  final int? typingMessageIndex;

  AiAssistantState({
    required this.messages,
    required this.history,
    this.status = AiAssistantStatus.initial,
    this.errorMessage,
    this.typingMessageIndex,
  });

  factory AiAssistantState.initial() =>
      AiAssistantState(messages: [], history: []);

  AiAssistantState copyWith({
    List<ChatMessage>? messages,
    List<ChatHistory>? history,
    AiAssistantStatus? status,
    String? errorMessage,
    int? typingMessageIndex,
  }) {
    return AiAssistantState(
      messages: messages ?? this.messages,
      history: history ?? this.history,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      typingMessageIndex: typingMessageIndex ?? this.typingMessageIndex,
    );
  }
}
