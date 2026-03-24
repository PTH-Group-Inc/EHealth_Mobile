import 'dart:async';
import 'package:e_health/gemini_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

class HomeAiAssistant extends StatefulWidget {
  const HomeAiAssistant({super.key});

  @override
  State<HomeAiAssistant> createState() => _HomeAiAssistantState();
}

// Model cho tin nhắn
class ChatMessage {
  final String text;
  final bool isUser;
  final bool isLoading;
  final String? suggestedDepartment;
  final DateTime timestamp; // Thêm trường thời gian

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isLoading = false,
    this.suggestedDepartment,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class _HomeAiAssistantState extends State<HomeAiAssistant> {
  final TextEditingController _chatController = TextEditingController();
  static final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  Timer? _typewriterTimer;
  int? _currentAiMessageIndex;

  void _stopGeneration() {
    if (!_isLoading) return;

    setState(() {
      _isLoading = false;
      if (_typewriterTimer != null && _typewriterTimer!.isActive) {
        _typewriterTimer!.cancel();
      }

      if (_currentAiMessageIndex != null &&
          _currentAiMessageIndex! < _messages.length) {
        _messages[_currentAiMessageIndex!] = ChatMessage(
          text: "Bạn đã tạm dừng câu trả lời này",
          isUser: false,
          isLoading: false,
          timestamp: DateTime.now(),
        );
      }
    });
    _scrollToBottom();
  }

  // List để lưu lịch sử chat cho Gemini API
  static final List<ChatHistory> _historyChat = [];

  @override
  void initState() {
    super.initState();
    // Scroll xuống cuối khi quay lại màn hình nếu có tin nhắn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_messages.isNotEmpty && _scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Khởi tạo service
  final geminiService = GeminiService();

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void onSendPressed() async {
    if (_chatController.text.trim().isEmpty || _isLoading) return;

    String question = _chatController.text.trim();

    // Thêm tin nhắn của user
    setState(() {
      _messages.add(ChatMessage(text: question, isUser: true));
      _isLoading = true;
    });
    _chatController.clear();
    _scrollToBottom();

    // Lưu câu hỏi của user vào lịch sử chat
    _historyChat.add(ChatHistory(role: 'user', text: question));

    // Thêm tin nhắn loading của AI
    setState(() {
      _messages.add(ChatMessage(text: "", isUser: false, isLoading: true));
      _currentAiMessageIndex = _messages.length - 1;
    });
    int currentAiMessageIndex = _currentAiMessageIndex!;
    _scrollToBottom();

    // Gọi API với lịch sử chat
    print("Đang gửi: $question");
    print("Lịch sử chat: ${_historyChat.length} tin nhắn");
    String? answer = await geminiService.sendMessage(
      question,
      history: _historyChat,
    );

    // Nếu đã bị stop hoặc loading đã tắt (do user nhấn Stop) thì dừng xử lý tiếp
    if (!_isLoading ||
        (mounted && currentAiMessageIndex != _currentAiMessageIndex))
      return;

    // Cập nhật tin nhắn AI (Sử dụng dữ liệu tĩnh để lưu ngay cả khi thoát màn hình)
    if (answer != null && answer.trim() != "---") {
      _historyChat.add(ChatHistory(role: 'model', text: answer));
      final aiTimestamp = DateTime.now();

      // Kiểm tra chuyên khoa
      String? foundDept;
      for (var dept in geminiService.medicalDepartments) {
        if (answer.contains(dept)) {
          foundDept = dept;
          break;
        }
      }

      // Nếu widget đã bị hủy, cập nhật thẳng vào list static và dừng
      if (!mounted) {
        _messages[currentAiMessageIndex] = ChatMessage(
          text: answer,
          isUser: false,
          isLoading: false,
          suggestedDepartment: foundDept,
          timestamp: aiTimestamp,
        );
        return;
      }

      setState(() {
        _messages[currentAiMessageIndex] = ChatMessage(
          text: "",
          isUser: false,
          isLoading: false,
          timestamp: aiTimestamp,
        );
      });

      // Hiệu ứng Typewriter
      int totalLength = answer.length;
      int delayMs = 15;
      int charsPerTick = (totalLength / (1500 / delayMs)).ceil();
      if (charsPerTick < 1) charsPerTick = 1;

      int currentLength = 0;
      _typewriterTimer = Timer.periodic(Duration(milliseconds: delayMs), (
        timer,
      ) {
        // Nếu thoát màn hình trong lúc đang gõ:
        // 1. Gán kết quả cuối cùng vào list static
        // 2. Tắt timer
        if (!mounted) {
          _messages[currentAiMessageIndex] = ChatMessage(
            text: answer,
            isUser: false,
            isLoading: false,
            suggestedDepartment: foundDept,
            timestamp: aiTimestamp,
          );
          timer.cancel();
          return;
        }

        // Kiểm tra xem đã bị stop chưa
        if (!_isLoading) {
          timer.cancel();
          return;
        }

        if (currentLength < totalLength) {
          currentLength += charsPerTick;
          if (currentLength > totalLength) currentLength = totalLength;

          setState(() {
            _messages[currentAiMessageIndex] = ChatMessage(
              text: answer.substring(0, currentLength),
              isUser: false,
              isLoading: false,
              timestamp: aiTimestamp,
            );
          });
          _scrollToBottom();
        } else {
          timer.cancel();
          // Cập nhật trạng thái cuối cùng kèm chuyên khoa
          setState(() {
            _isLoading = false;
            _messages[currentAiMessageIndex] = ChatMessage(
              text: answer,
              isUser: false,
              isLoading: false,
              suggestedDepartment: foundDept,
              timestamp: aiTimestamp,
            );
          });
          _scrollToBottom();
        }
      });
    } else {
      // Trường hợp lỗi (null hoặc '---')
      final errorMsg = answer == "---"
          ? "Xin lỗi, tôi không tìm được câu trả lời phù hợp cho vấn đề này. Bạn có thể mô tả kỹ hơn không?"
          : "Có lỗi khi kết nối với hệ thống tư vấn AI. Vui lòng thử lại sau.";

      _messages[currentAiMessageIndex] = ChatMessage(
        text: errorMsg,
        isUser: false,
        isLoading: false,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _scrollToBottom();
      }

      if (_historyChat.isNotEmpty && _historyChat.last.role == 'user') {
        _historyChat.removeLast();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildCustomHeader(context),

          // 2. PHẦN GIỮA (Danh sách tin nhắn)
          Expanded(
            child: _messages.isEmpty
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.1),
                        Image.asset(
                          'assets/chatbotai.png',
                          height: 160,
                          width: 160,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.image_not_supported,
                                size: 100,
                                color: Colors.grey,
                              ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Xin chào",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: const Text(
                            "Tôi là trợ lý ảo Mii Chan của bạn.\n Tôi có thể giúp gì được cho bạn?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: const Text(
                            "Gợi ý cho bạn",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildSuggestionChip("Cách đặt lịch khám"),
                              _buildSuggestionChip("Có bao nhiêu khoa?"),
                              _buildSuggestionChip("Cách sử dụng chatbot"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),

          // 3. PHẦN BOTTOM INPUT (Thanh chat)
          _buildBottomInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    bool isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // 1. Header: Avatar + Time (Chỉ cho AI)
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/chatbotai.png',
                    height: 28,
                    width: 28,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.smart_toy,
                      size: 24,
                      color: Color(0xFF3c81c6),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${message.timestamp.toLocal().hour.toString().padLeft(2, '0')}:${message.timestamp.toLocal().minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

          // 2. Chat Bubble
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!isUser && message.isLoading)
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.85,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8FE),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFF90CAF9),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            const Color(0xFF3c81c6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Đang soạn câu trả lời...",
                        style: TextStyle(
                          color: Color(0xFF1976D2),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                )
              else if (!isUser)
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.85,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFF90CAF9),
                            width: 1,
                          ),
                        ),
                        child: MarkdownBody(
                          data: message.text,
                          shrinkWrap: true, // Fix hit test size error
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              height: 1.5,
                              letterSpacing: 0.2,
                            ),
                            listBullet: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            strong: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      if (message.suggestedDepartment != null)
                        _buildSuggestionCard(message.suggestedDepartment!),
                    ],
                  ),
                )
              else
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF64B5F6),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return InkWell(
      onTap: () {
        _chatController.text = text;
        onSendPressed();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF90CAF9), width: 1),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF1976D2),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(String departmentName) {
    return InkWell(
      onTap: () {
        print("Chuyển đến đặt lịch: $departmentName");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Tính năng đặt lịch $departmentName đang được phát triển!",
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF90CAF9), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Xem các cơ sở y tế về ${departmentName.toLowerCase()} →",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120, // Chiều cao header
      padding: const EdgeInsets.only(
        top: 40,
        left: 10,
        right: 10,
      ), // Tránh status bar
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB3E5FC), // Màu xanh nhạt (Light Blue 100)
            Color(0xFF81D4FA), // Màu xanh đậm hơn xíu (Light Blue 200)
          ],
        ),
        image: DecorationImage(
          image: AssetImage(
            "assets/360_F_466415129_mTSxvYJ6ugmN2UBv6ZYsxTYdQGj0p2YM.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          // Nút Back
          IconButton(
            onPressed: () {
              // Nếu dùng go_router thì dùng context.pop(), còn Navigator thì Navigator.pop(context)
              if (context.canPop()) {
                context.pop();
              }
            },
            icon: const Icon(Icons.arrow_back, color: Color(0xFF3c81c6)),
          ),
          // Tiêu đề
          const Expanded(
            child: Text(
              "Trợ lý AI Hỗ trợ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3c81c6), // Màu chữ hơi xám như hình
              ),
            ),
          ),
          // Widget rỗng để cân đối Title vào giữa (chiếm chỗ bằng nút back)
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildBottomInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3), // Đổ bóng nhẹ lên trên
          ),
        ],
      ),
      child: Row(
        children: [
          // Ô nhập liệu
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF3c81c6), width: 1.2),
              ),
              child: TextField(
                controller: _chatController,
                maxLines: 3,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: "Chat hỗ trợ ngay",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Nút Gửi / Dừng
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: _isLoading ? Colors.red.shade400 : const Color(0xFF64B5F6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              onPressed: () {
                if (_isLoading) {
                  _stopGeneration();
                } else {
                  onSendPressed();
                }
              },
              icon: Icon(
                _isLoading ? Icons.stop : Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
