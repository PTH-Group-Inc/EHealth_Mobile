import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'domain/department.dart';
import 'package:injectable/injectable.dart';

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

@lazySingleton
class GeminiService {
  final Dio _dio = Dio();

  final String geminiApiKey = dotenv.env['Gemini_API_Key'] ?? '';
  List<String> get geminiModels => (dotenv.env['Gemini_Model'] ?? '')
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  String _getBaseUrl(String modelName) =>
      'https://generativelanguage.googleapis.com/v1beta/models/$modelName:streamGenerateContent?key=$geminiApiKey';

  List<Department> medicalDepartments = [];

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
              {"text": "$userQuestion  "},
            ],
          },
        ];
      }

      final deptsContext = medicalDepartments.isEmpty
          ? "Hiện tại không có danh sách chuyên khoa cụ thể."
          : medicalDepartments
              .map((d) =>
                  "- ${d.name} (ID: ${d.id}): ${d.description ?? 'Chuyên khoa thuộc hệ thống.'}")
              .join("\n");

      final systemInstructionData = {
        "parts": [
          {
            "text": """Role: Trợ lý Sức khỏe Mii Chan ảo. Giọng văn: Điềm tĩnh, thấu hiểu, chuyên nghiệp.

**QUY TẮC CỐT LÕI (TUYỆT ĐỐI TUÂN THỦ):**
1. Không phải bác sĩ: Mọi tư vấn chỉ để tham khảo.
2. Thuốc: CẤM kê đơn thuốc đặc trị/kháng sinh. Chỉ gợi ý thuốc OTC hoặc mẹo tự nhiên.
3. Giới hạn chủ đề: CHỈ tư vấn y tế, sức khỏe, đặt lịch khám. TỪ CHỐI MỌI yêu cầu ngoài lề.
4. Định dạng: Trả lời ngắn gọn, súc tích. TUYỆT ĐỐI KHÔNG dùng dấu phân cách "---".

**DANH SÁCH CHUYÊN KHOA HIỆN CÓ:**
$deptsContext

**CẤU TRÚC TƯ VẤN:**
- Làm rõ: Hỏi nếu cần thêm thông tin triệu chứng.
- Sơ bộ: Nêu 1-2 nguyên nhân phổ biến.
- Lời khuyên: Cách chăm sóc tại nhà.
- Cờ đỏ: Dấu hiệu cần đi viện cấp cứu.
- Chỉ định tuyến: Nếu cần khám chuyên sâu, HÃY khuyên người dùng đến đúng chuyên khoa từ danh sách trên.
**QUY TẮC GỢI Ý CHUYÊN KHOA:**
Khi bạn khuyên người dùng đến một chuyên khoa cụ thể, bạn BẮT BUỘC phải đính kèm ID của chuyên khoa đó ở CUỐI CÙNG của câu trả lời theo định dạng: [ID: {id}]. 
Ví dụ: "Bạn nên đến khám tại Khoa Mắt. [ID: 123]"

[User Question]""",
          },
        ],
      };

      // Duyệt qua lần lượt các model được khai báo từ .env
      for (String modelName in geminiModels) {
        try {
          String formattedModelName = modelName.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '-');
          
          final requestData = {
            "contents": contents,
            "systemInstruction": systemInstructionData,
          };
          
          if (formattedModelName.contains('3.1') || formattedModelName.contains('thinking')) {
            requestData["generationConfig"] = {
              "thinkingConfig": {"thinkingLevel": "MINIMAL"},
            };
          }

          final response = await _dio.post(
            _getBaseUrl(formattedModelName),
            data: requestData,
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
          debugPrint(
            "Lỗi API (Dio) với model $modelName: ${e.response?.data ?? e.message}",
          );
          // Tiếp tục thử model kế tiếp
          continue;
        } catch (e) {
          debugPrint("Lỗi không xác định với model $modelName: $e");
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
