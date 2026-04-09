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

**THÔNG TIN ỨNG DỤNG & QUY TRÌNH ĐẶT LỊCH:**
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

**QUY TẮC GỢI Ý CHUYÊN KHOA ĐỂ ĐẶT LỊCH:**
Khi bạn khuyên người dùng nên đi khám tại một chuyên khoa cụ thể, bạn BẮT BUỘC phải đính kèm ID của chuyên khoa đó ở CUỐI CÙNG của toàn bộ câu trả lời theo đúng định dạng: [ID: {id}]. Hệ thống sẽ tự động hiển thị nút Đặt Lịch cho người dùng.
Ví dụ: "Bạn nên đặt lịch khám sớm với bác sĩ chuyên khoa Tai Mũi Họng để kiểm tra nội sơ. [ID: 15]"

**QUY TẮC GỢI Ý DANH SÁCH BÁC SĨ:**
Khi người dùng hỏi về danh sách bác sĩ, muốn xem tất cả bác sĩ hoặc muốn chọn bác sĩ để đặt lịch, bạn BẮT BUỘC phải đính kèm tag đặc biệt ở CUỐI CÙNG của câu trả lời: [ACTION: ALL_DOCTORS].
Ví dụ: "Bạn có thể xem danh sách toàn bộ bác sĩ giỏi của hệ thống tại đây để dễ dàng lựa chọn nhé. [ACTION: ALL_DOCTORS]"

**QUY TẮC GỢI Ý ĐẶT LỊCH NHANH:**
Khi người dùng nói muốn đặt lịch, muốn hẹn gặp bác sĩ hoặc hỏi cách đăng ký khám, bạn BẮT BUỘC phải đính kèm tag ở CUỐI CÙNG của câu trả lời: [ACTION: BOOKING_FLOW].
Ví dụ: "Tôi sẽ giúp bạn đặt lịch khám ngay. Bạn vui lòng chọn hồ sơ bệnh nhân để tiếp tục nhé. [ACTION: BOOKING_FLOW]"

[User Question]""",
          },
        ],
      };

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
              formattedModelName.contains('thinking')) {
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
