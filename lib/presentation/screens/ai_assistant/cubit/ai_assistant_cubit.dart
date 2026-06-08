import 'dart:async';

import 'package:e_health/data/repository.dart';
import 'package:e_health/gemini_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/presentation/screens/ai_assistant/cubit/ai_assistant_state.dart';

@lazySingleton
class AiAssistantCubit extends Cubit<AiAssistantState> {
  final GeminiService _geminiService;
  final Repository _repository;
  final _typewriterTimer = <Timer?>[null];
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
        final cleanedAnswer = _removeThoughtProcess(answer);
        if (cleanedAnswer.trim().isNotEmpty) {
          _startTypewriterEffect(cleanedAnswer, aiMessageIndex);
        } else {
          _handleError(
            aiMessageIndex,
            "Xin lỗi, tôi không tìm được câu trả lời phù hợp. Bạn có thể mô tả kỹ hơn không?",
          );
        }
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
    _typewriterTimer[0]?.cancel();

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

    _typewriterTimer[0] = Timer.periodic(const Duration(milliseconds: delayMs), (
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
    List<String> foundRoutes = [];
    String cleanText = _removeThoughtProcess(fullText);

    // Tìm tag [ID: {id}]
    final deptRegExp = RegExp(r'\[ID:\s*([^\]]+)\]');
    final deptMatch = deptRegExp.firstMatch(fullText);

    if (deptMatch != null) {
      foundDeptId = deptMatch.group(1)?.trim();
      cleanText = cleanText.replaceAll(deptRegExp, '').trim();

      if (foundDeptId != null) {
        final dept = _geminiService.medicalDepartments
            .where((d) => d.departmentsId?.toLowerCase() == foundDeptId?.toLowerCase())
            .firstOrNull;
        foundDeptName = dept?.name;
      }
    }

    // Tìm tag [ACTION: {type}]
    final actionRegExp = RegExp(r'\[ACTION:\s*([^\]]+)\]');
    final actionMatch = actionRegExp.firstMatch(cleanText);

    if (actionMatch != null) {
      foundActionType = actionMatch.group(1)?.trim();
      cleanText = cleanText.replaceAll(actionRegExp, '').trim();
    }

    // Tìm tag [ROUTE: {path}]
    final routeRegExp = RegExp(r'\[ROUTE:\s*([^\]]+)\]');
    final routeMatches = routeRegExp.allMatches(cleanText);

    for (final match in routeMatches) {
      final route = match.group(1)?.trim();
      if (route != null) {
        foundRoutes.add(route);
      }
    }

    // Clean all route tags from text
    cleanText = cleanText.replaceAll(routeRegExp, '').trim();

    final finalMessages = List<ChatMessage>.from(state.messages);
    finalMessages[messageIndex] = ChatMessage(
      text: cleanText,
      isUser: false,
      isLoading: false,
      suggestedDepartment: foundDeptName,
      suggestedDepartmentId: foundDeptId,
      actionType: foundActionType,
      suggestedRoutes: foundRoutes.isNotEmpty ? foundRoutes : null,
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
    _typewriterTimer[0]?.cancel();
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

  String _removeThoughtProcess(String text) {
    String cleaned = text;

    // 0. Nếu có tag [ANSWER], lấy nội dung sau tag đó (đây là cách chắc chắn nhất)
    if (cleaned.contains('[ANSWER]')) {
      cleaned = cleaned.split('[ANSWER]').last;
    }

    // 1. Xóa nội dung trong thẻ <thought>...</thought> hoặc [THOUGHT]...[/THOUGHT]
    final thoughtTagsRegExp = RegExp(
      r'<(thought|thinking|reasoning)>.*?</\1>|\[THOUGHT\].*?\[/THOUGHT\]',
      dotAll: true,
      caseSensitive: false,
    );
    cleaned = cleaned.replaceAll(thoughtTagsRegExp, '');

    // 2. Xóa mô tả vai trò lặp lại (Mii Chan, Virtual Health Assistant...)
    final roleDescRegExp = RegExp(
      r'Mii Chan, Virtual Health Assistant.*?professional\.',
      dotAll: true,
      caseSensitive: false,
    );
    cleaned = cleaned.replaceAll(roleDescRegExp, '');

    // 3. Xóa các đoạn reasoning kiểu bullet points (Disclaimer:, Tone check:, v.v.)
    final reasoningKeywords = [
      'Disclaimer',
      'Medication',
      'Topic limitation',
      'Formatting',
      'Booking Process',
      'Routing',
      'Introduction',
      'The Process',
      'Tone check',
      'Format check',
      'Reasoning',
      'Step',
      'Greeting',
      'Call to Action',
    ];
    for (final kw in reasoningKeywords) {
      final kwRegExp = RegExp(
        '^\\s*\\*?\\s*\\*?$kw.*?(\\n|\$)',
        multiLine: true,
        caseSensitive: false,
      );
      cleaned = cleaned.replaceAll(kwRegExp, '');
    }

    // 4. Xóa câu hỏi người dùng bị lặp lại ở đầu (thường trong ngoặc kép)
    final repeatQuestionRegExp = RegExp(
      r'^\s*".*?"\s*\(.*?\)\.?\s*',
      dotAll: false,
    );
    cleaned = cleaned.replaceAll(repeatQuestionRegExp, '');

    // 5. Xóa các đoạn bắt đầu bằng "Thinking:" hoặc "Reasoning:" cho đến khi gặp 2 dấu xuống dòng hoặc một câu chào
    final thinkingRegExp = RegExp(
      r'^(Thinking|Reasoning):.*?(?=\n\n|\n\s*Chào bạn|\n\s*Xin chào|$)',
      multiLine: true,
      dotAll: true,
      caseSensitive: false,
    );
    cleaned = cleaned.replaceAll(thinkingRegExp, '');

    return cleaned.trim();
  }

  @override
  Future<void> close() {
    _typewriterTimer[0]?.cancel();
    return super.close();
  }
}
