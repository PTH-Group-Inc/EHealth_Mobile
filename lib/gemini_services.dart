import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:e_health/domain/department.dart';
import 'package:e_health/app/route_manager.dart';
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

      debugPrint("--- [AI DEBUG] USER INPUT: $userQuestion ---");

      final deptsContext = medicalDepartments.isEmpty
          ? "Hiện tại không có danh sách chuyên khoa cụ thể."
          : medicalDepartments
                .map(
                  (d) =>
                      "- ${d.name} (ID: ${d.departmentsId}): ${d.description ?? 'Chuyên khoa thuộc hệ thống.'}",
                )
                .join("\n");

      final systemInstructionData = {
        "parts": [
          {
            "text":
                """Role: Trợ lý Sức khỏe Mii Chan ảo trên ứng dụng EHealth. Giọng văn: Điềm tĩnh, thấu hiểu, ân cần và chuyên nghiệp.

**QUY TẮC CỐT LÕI (TUYỆT ĐỐI TUÂN THỦ):**
1. Không phải bác sĩ: Xin lưu ý với người dùng rằng mọi tư vấn chỉ để tham khảo ban đầu.
2. Thuốc: CẤM kê đơn thuốc đặc trị/kháng sinh. Chỉ gợi ý thuốc OTC (không kê đơn) hoặc các biện pháp tự nhiên chăm sóc tại nhà.
3. Giới hạn chủ đề: CHỈ tư vấn y tế, sức khỏe, và hướng dẫn đặt lịch khám bệnh trên ứng dụng EHealth. TỪ CHỐI MỌI yêu cầu ngoài lề một cách lịch sự.
4. Định dạng: Trả lời tự nhiên, xuống dòng hợp lý, có thể dùng bullet point. TUYỆT ĐỐI KHÔNG dùng dấu phân cách "---".

**THÔNG TIN ỨNG DỤNG & QUY TRÌNH ĐẶT LỊCH:** (Chỗ này phải xuống dòng ở từng bước khi trả lời)
Hiện tại, người dùng có thể đặt lịch khám bệnh trực tiếp với bác sĩ trên ứng dụng EHealth thông qua quy trình sau: (Xuống dòng từng cái)
- Bước 1: Tìm kiếm hoặc chọn Bác sĩ theo phân khoa phù hợp.
- Bước 2: Bấm nút "Đặt lịch khám ngay" tại trang thông tin Bác sĩ.
- Bước 3: Chọn hồ sơ bệnh nhân (bắt buộc phải tạo hồ sơ y tế trước nếu chưa có).
- Bước 4: Chọn cơ sở khám (nếu bác sĩ có làm việc tại nhiều cơ sở).
- Bước 5: Chọn ngày khám, ca khám và khung giờ trống cụ thể.
- Bước 6: Chọn dịch vụ y tế.
- Bước 7: Điền lý do khám (bắt buộc) và triệu chứng chi tiết.
- Bước 8: Xác nhận đặt lịch.
Nếu người dùng hỏi về cách đặt lịch, bạn HÃY tóm tắt và hướng dẫn chu đáo theo quy trình trên.

**DANH SÁCH CHUYÊN KHOA HIỆN CÓ:**
$deptsContext

**CẤU TRÚC TƯ VẤN SỨC KHỎE (Tùy theo câu hỏi):**
- Làm rõ: Hỏi thêm về các triệu chứng đi kèm (sốt, đau, thời gian kéo dài) nếu thông tin chưa đủ.
- Phân tích sơ bộ: Nêu 1-2 nguyên nhân phổ biến, giải thích dễ hiểu.
- Lời khuyên: Các biện pháp giảm nhẹ triệu chứng tại nhà an toàn.
- Cờ đỏ: Cảnh báo những dấu hiệu nguy hiểm cần gọi cấp cứu hoặc đi viện ngay lập tức.
- Chỉ định tuyến: Nếu triệu chứng cần được thăm khám chuyên môn, HÃY khuyên người dùng đặt lịch khám với bác sĩ thuộc chuyên khoa phù hợp (từ danh sách trên).

**QUY TẮC ĐIỀU HƯỚNG & ĐẶT LỊCH:**
Khi người dùng hỏi về vị trí của một chức năng, muốn xem danh sách hoặc muốn ĐẶT LỊCH KHÁM, bạn hãy điều hướng họ theo các quy tắc sau:
1. Muốn đặt lịch khám chung hoặc xem danh sách bác sĩ: Điều hướng đến [ROUTE: /all-doctors].
2. Muốn đặt lịch theo chuyên khoa hoặc xem danh sách chuyên khoa: Điều hướng đến [ROUTE: /all-specialty].
3. Các chức năng khác: Sử dụng đúng Path tương ứng trong danh sách dưới đây.

Danh sách Route có sẵn:
${navigableRoutes.map((r) => "- ${r.name}: ${r.description} (Path: ${r.path})").join("\n")}

Ví dụ:
- User: "Tôi muốn đặt lịch khám bác sĩ" -> Trả lời: "Bạn có thể xem danh sách bác sĩ và chọn bác sĩ muốn đặt lịch tại đây nhé. [ROUTE: /all-doctors]"
- User: "Đặt lịch theo chuyên khoa" -> Trả lời: "Mời bạn chọn chuyên khoa phù hợp để tiến hành đặt lịch. [ROUTE: /all-specialty]"
- User: "Xem hồ sơ của tôi" -> Trả lời: "Bạn có thể quản lý hồ sơ tại đây. [ROUTE: /medical-record]"

[User Question]""",
          },
        ],
      };

      debugPrint(
        "--- [AI DEBUG] SYSTEM INSTRUCTION: ${systemInstructionData['parts']?[0]['text'].toString().substring(0, 100)}... ---",
      );
      debugPrint(
        "--- [AI DEBUG] DEPARTMENTS COUNT: ${medicalDepartments.length} ---",
      );
      debugPrint("--- [AI DEBUG] MODELS TO TRY: $geminiModels ---");

      // Duyệt qua lần lượt các model được khai báo từ .env
      for (String modelName in geminiModels) {
        try {
          String formattedModelName = modelName.trim().toLowerCase().replaceAll(
            RegExp(r'\s+'),
            '-',
          );

          final requestData = {
            "contents": contents,
            "systemInstruction": systemInstructionData,
          };

          if (formattedModelName.contains('3.1') ||
              formattedModelName.contains('thinking') ||
              formattedModelName.contains('2.0')) {
            requestData["generationConfig"] = {
              "thinkingConfig": {"thinkingLevel": "MINIMAL"},
            };
            // Thêm công cụ tìm kiếm nếu model hỗ trợ
            requestData["tools"] = [
              {"googleSearch": {}},
            ];
          }

          final response = await _dio.post(
            _getBaseUrl(formattedModelName),
            data: requestData,
            options: Options(
              headers: {'Content-Type': 'application/json'},
              sendTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 30),
            ),
          );

          debugPrint("--- [AI DEBUG] USING MODEL: $formattedModelName ---");

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
                debugPrint("--- [AI DEBUG] RESPONSE SUCCESS: $fullText ---");
                return fullText;
              }
            } else if (response.data is Map) {
              final candidates = response.data['candidates'] as List?;
              if (candidates != null && candidates.isNotEmpty) {
                final parts = candidates[0]['content']['parts'] as List?;
                if (parts != null && parts.isNotEmpty) {
                  final text = parts[0]['text'];
                  debugPrint("--- [AI DEBUG] RESPONSE SUCCESS: $text ---");
                  return text;
                }
              }
            }
          }
        } on DioException catch (e) {
          final isUnavailable =
              e.response?.statusCode == 503 || e.response?.statusCode == 429;

          debugPrint(
            "Lỗi API (Dio) với model $modelName: Code ${e.response?.statusCode} - ${e.response?.data ?? e.message}",
          );

          if (isUnavailable) {
            // Nếu model đang quá tải, ngay lập tức thử model tiếp theo trong danh sách
            continue;
          }
          // Nếu là lỗi khác (ví dụ: API Key sai), có thể dừng lại hoặc báo lỗi cụ thể
          return "Lỗi dịch vụ: ${e.message}";
        } catch (e) {
          debugPrint("Lỗi không xác định với model $modelName: $e");
          continue;
        }
      }

      return "Xin lỗi, hiện tại tất cả các model AI tư vấn đều đang bận hoặc quá tải. Vui lòng thử lại sau!";
    } catch (e) {
      return "Lỗi cấu hình: $e";
    }
  }
}
