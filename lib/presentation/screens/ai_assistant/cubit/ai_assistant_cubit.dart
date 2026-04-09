import 'dart:async';

import 'package:e_health/data/repository.dart';
import 'package:e_health/gemini_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'ai_assistant_state.dart';

@lazySingleton
class AiAssistantCubit extends Cubit<AiAssistantState> {
  final GeminiService _geminiService;
  final Repository _repository;
  Timer? _typewriterTimer;

  AiAssistantCubit(this._geminiService, this._repository)
    : super(AiAssistantState.initial());

  Future<void> init() async {
    final hasToken = await _repository.hasToken();
    if (!hasToken) return;

    final result = await _repository.getDepartments();
    result.fold((failure) => null, (departments) {
      _geminiService.medicalDepartments = departments;
    });
  }

  void sendMessage(String text) async {
    if (text.trim().isEmpty || state.status == AiAssistantStatus.loading) {
      return;
    }

    final userMessage = ChatMessage(text: text, isUser: true);
    final updatedMessages = List<ChatMessage>.from(state.messages)
      ..add(userMessage);
    final updatedHistory = List<ChatHistory>.from(state.history)
      ..add(ChatHistory(role: 'user', text: text));

    emit(
      state.copyWith(
        messages: updatedMessages,
        history: updatedHistory,
        status: AiAssistantStatus.loading,
      ),
    );

    // Thêm tin nhắn loading của AI
    final aiLoadingMessage = ChatMessage(
      text: "",
      isUser: false,
      isLoading: true,
    );
    final messagesWithLoading = List<ChatMessage>.from(updatedMessages)
      ..add(aiLoadingMessage);
    final aiMessageIndex = messagesWithLoading.length - 1;

    emit(
      state.copyWith(
        messages: messagesWithLoading,
        typingMessageIndex: aiMessageIndex,
      ),
    );

    try {
      final answer = await _geminiService.sendMessage(
        text,
        history: state.history,
      );

      if (answer != null && answer.trim() != "---") {
        _startTypewriterEffect(answer, aiMessageIndex);
      } else {
        _handleError(
          aiMessageIndex,
          answer == "---"
              ? "Xin lỗi, tôi không tìm được câu trả lời phù hợp. Bạn có thể mô tả kỹ hơn không?"
              : "Có lỗi khi kết nối với hệ thống AI.",
        );
      }
    } catch (e) {
      _handleError(aiMessageIndex, "Đã xảy ra lỗi rỗng hệ thống.");
    }
  }

  void _startTypewriterEffect(String fullText, int messageIndex) {
    _typewriterTimer?.cancel();

    final updatedHistory = List<ChatHistory>.from(state.history)
      ..add(ChatHistory(role: 'model', text: fullText));

    emit(
      state.copyWith(status: AiAssistantStatus.typing, history: updatedHistory),
    );

    int currentLength = 0;
    const int delayMs = 15;
    final int charsPerTick = (fullText.length / (1000 / delayMs)).ceil().clamp(
      1,
      10,
    );

    _typewriterTimer = Timer.periodic(const Duration(milliseconds: delayMs), (
      timer,
    ) {
      if (currentLength < fullText.length) {
        currentLength += charsPerTick;
        if (currentLength > fullText.length) currentLength = fullText.length;

        final typingMessages = List<ChatMessage>.from(state.messages);
        typingMessages[messageIndex] = ChatMessage(
          text: fullText.substring(0, currentLength),
          isUser: false,
          isLoading: false,
        );

        emit(state.copyWith(messages: typingMessages));
      } else {
        timer.cancel();
        _finalizeAiMessage(fullText, messageIndex);
      }
    });
  }

  void _finalizeAiMessage(String fullText, int messageIndex) {
    String? foundDeptId;
    String? foundDeptName;
    String? foundActionType;
    String cleanText = fullText;

    // Tìm tag [ID: {id}] (giữ nguyên logic cũ)
    final deptRegExp = RegExp(r'\[ID:\s*([^\]]+)\]');
    final deptMatch = deptRegExp.firstMatch(fullText);

    if (deptMatch != null) {
      foundDeptId = deptMatch.group(1)?.trim();
      cleanText = cleanText.replaceFirst(deptMatch.group(0)!, '').trim();

      if (foundDeptId != null) {
        final dept = _geminiService.medicalDepartments
            .where((d) => d.departmentsId == foundDeptId)
            .firstOrNull;
        foundDeptName = dept?.name;
      }
    }

    // Tìm tag [ACTION: {type}] mới
    final actionRegExp = RegExp(r'\[ACTION:\s*([^\]]+)\]');
    final actionMatch = actionRegExp.firstMatch(cleanText);

    if (actionMatch != null) {
      foundActionType = actionMatch.group(1)?.trim();
      cleanText = cleanText.replaceFirst(actionMatch.group(0)!, '').trim();
    }

    final finalMessages = List<ChatMessage>.from(state.messages);
    finalMessages[messageIndex] = ChatMessage(
      text: cleanText,
      isUser: false,
      isLoading: false,
      suggestedDepartment: foundDeptName,
      suggestedDepartmentId: foundDeptId,
      actionType: foundActionType,
    );

    emit(
      state.copyWith(
        messages: finalMessages,
        status: AiAssistantStatus.success,
        typingMessageIndex: null,
      ),
    );
  }

  void stopGeneration() {
    _typewriterTimer?.cancel();
    if (state.typingMessageIndex != null) {
      final stoppedMessages = List<ChatMessage>.from(state.messages);
      stoppedMessages[state.typingMessageIndex!] = ChatMessage(
        text: "Bạn đã tạm dừng câu trả lời này",
        isUser: false,
        isLoading: false,
      );
      emit(
        state.copyWith(
          messages: stoppedMessages,
          status: AiAssistantStatus.success,
          typingMessageIndex: null,
        ),
      );
    }
  }

  void _handleError(int messageIndex, String errorMsg) {
    final errorMessages = List<ChatMessage>.from(state.messages);
    errorMessages[messageIndex] = ChatMessage(
      text: errorMsg,
      isUser: false,
      isLoading: false,
    );

    emit(
      state.copyWith(
        messages: errorMessages,
        status: AiAssistantStatus.failure,
        typingMessageIndex: null,
      ),
    );
  }

  @override
  Future<void> close() {
    _typewriterTimer?.cancel();
    return super.close();
  }
}
