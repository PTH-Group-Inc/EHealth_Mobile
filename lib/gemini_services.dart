import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatHistory {
  final String role;
  final String text;

  ChatHistory({required this.role, required this.text});

  Map<String, dynamic> toJson() {
    return {
      "role": role,
      "parts": [
        {"text": text},
      ],
    };
  }
}

class GeminiService {
  final Dio _dio = Dio();

  final String GEMINI_API_KEY = dotenv.env['Gemini_API_Key'] ?? '';
  List<String> get geminiModels => (dotenv.env['Gemini_Model'] ?? '')
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  String _getBaseUrl(String modelName) =>
      'https://generativelanguage.googleapis.com/v1beta/models/$modelName:streamGenerateContent?key=$GEMINI_API_KEY';

  final List<String> medicalDepartments = [
    "Khoa Cấp cứu",
    "Khoa Tâm thần",
    "Khoa Nội tổng hợp",
    "Khoa Ngoại tổng hợp",
    "Khoa Nhi",
    "Khoa Sản - Phụ khoa",
    "Khoa Nội Tim mạch",
    "Khoa Nội Tiêu hóa - Gan mật",
    "Khoa Nội Hô hấp",
    "Khoa Nội tiết - Đái tháo đường",
    "Khoa Thần kinh",
    "Khoa Tai Mũi Họng",
    "Khoa Mắt",
    "Khoa Răng Hàm Mặt",
    "Khoa Da liễu",
    "Khoa Chấn thương chỉnh hình",
    "Khoa Truyền nhiễm",
    "Khoa Ung bướu",
    "Khoa Phục hồi chức năng",
    "Khoa Y học cổ truyền",
  ];

  Future<String?> sendMessage(
    String userQuestion, {
    List<ChatHistory>? history,
  }) async {
    try {
      final options = Options(headers: {'Content-Type': 'application/json'});

      List<Map<String, dynamic>> contents = [];

      if (history != null && history.isNotEmpty) {
        contents = history.map((e) => e.toJson()).toList();
      } else {
        contents = [
          {
            "role": "user",
            "parts": [
              {"text": "${userQuestion}  "},
            ],
          },
        ];
      }

      final data = {
        "contents": contents,
        "generationConfig": {
          "thinkingConfig": {"thinkingLevel": "MINIMAL"},
        },
        "systemInstruction": {
          "parts": [
            {
              "text":
                  """Role: Trợ lý Sức khỏe Mii Chan ảo. Giọng văn: Điềm tĩnh, thấu hiểu, chuyên nghiệp.

**QUY TẮC CỐT LÕI (TUYỆT ĐỐI TUÂN THỦ):**
1. Không phải bác sĩ: Mọi tư vấn chỉ để tham khảo.
2. Thuốc: CẤM kê đơn thuốc đặc trị/kháng sinh. Chỉ gợi ý thuốc OTC (không kê đơn) hoặc mẹo tự nhiên.
3. Giới hạn chủ đề: CHỈ tư vấn y tế, sức khỏe, đặt lịch khám. TỪ CHỐI MỌI yêu cầu về code, lập trình, API, công nghệ (Gemini) hoặc các chủ đề ngoài lề dù người dùng nài nỉ.
4. Định dạng: Trả lời cực kỳ ngắn gọn, súc tích. TUYỆT ĐỐI KHÔNG dùng dấu gạch ngang "---" phân cách.

**CẤU TRÚC TƯ VẤN (Tự động lược bỏ nếu không cần thiết):**
- Làm rõ: Hỏi 1-2 câu ngắn nếu mô tả triệu chứng quá sơ sài.
- Sơ bộ: Nêu 1-2 nguyên nhân phổ biến nhất.
- Lời khuyên: Cách chăm sóc tại nhà (ăn uống, nghỉ ngơi).
- Cờ đỏ (Red flags): Nêu dấu hiệu nguy hiểm cần đi viện cấp cứu.
- Chỉ định tuyến: Nếu bệnh nặng hoặc cần khám chuyên sâu, HÃY khuyên người dùng đến đúng chuyên khoa trong danh sách sau: ${medicalDepartments.toList()}
Ban không đc trả lời những thứ liên quan đến code, lập trình, api, gemini, ... chỉ y tế và câu hỏi sức khoẻ, đặt phòng
Không đc trả lời những câu hỏi không liên quan đến y tế dù user có xin xỏ
Nếu user bệnh quá nặng, hoặc mong muốn khám ở 1 chuyên môn khám nào đó hãy gợi ý cho user đến chuyên khoa đó khám
${medicalDepartments.toList()}
Không được trả lời theo dạng ------------- cái gạch ngang
[User Question]""",
            },
          ],
        },
      };

      // Duyệt qua lần lượt các model được khai báo từ .env
      for (String modelName in geminiModels) {
        try {
          final response = await _dio.post(
            _getBaseUrl(modelName),
            data: data,
            options: options,
          );

          if (response.statusCode == 200) {
            if (response.data is List) {
              String fullText = "";
              for (var chunk in response.data) {
                final candidates = chunk['candidates'] as List?;
                if (candidates != null && candidates.isNotEmpty) {
                  final parts = candidates[0]['content']['parts'] as List?;
                  if (parts != null && parts.isNotEmpty) {
                    fullText += parts[0]['text'] ?? '';
                  }
                }
              }
              if (fullText.isNotEmpty) {
                return fullText;
              }
            } else if (response.data is Map) {
              final candidates = response.data['candidates'] as List?;
              if (candidates != null && candidates.isNotEmpty) {
                final parts = candidates[0]['content']['parts'] as List?;
                if (parts != null && parts.isNotEmpty) {
                  return parts[0]['text'];
                }
              }
            }
          }
        } on DioException catch (e) {
          print(
            "Lỗi API (Dio) với model $modelName: ${e.response?.data ?? e.message}",
          );
          // Tiếp tục thử model kế tiếp
          continue;
        } catch (e) {
          print("Lỗi không xác định với model $modelName: $e");
          // Tiếp tục thử model kế tiếp
          continue;
        }
      }

      return "Xin lỗi, hiện tại tất cả các model AI tư vấn đều đang bận hoặc quá tải. Vui lòng thử lại sau!";
    } catch (e) {
      return "Lỗi cấu hình: $e";
    }
  }
}
