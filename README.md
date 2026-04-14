# 🏥 EHealth - Hệ sinh thái Chăm sóc Sức khỏe Thông minh

Ứng dụng Flutter dành cho bệnh nhân trong hệ thống EHealth, tích hợp trợ lý AI Mii Chan, quy trình đặt lịch khám đa năng và quản lý hồ sơ bệnh án điện tử tập trung.

---

## 🏗 KIẾN TRÚC DỰ ÁN (Clean Architecture)

Dự án tuân thủ nghiêm ngặt **Clean Architecture** kết hợp với kiến trúc theo tính năng (**Feature-Based**) và quản lý trạng thái bằng **BLoC/Cubit**.

### 📁 Cấu trúc thư mục chi tiết (Project Tree):

```text
EHealth_Mobile/
├── assets/                                     # Tài nguyên tĩnh (Ảnh, Icons, Fonts)
├── lib/
│   ├── app/                                    # Cấu hình cấp ứng dụng (App-level)
│   │   ├── dependency_injection/               # Thiết lập GetIt & Injectable
│   │   ├── theme/                              # Quản lý Theme, Color & Shadow tokens
│   │   ├── helper/                             # Tiện ích (HelperRestResponse, Dialogs, Enums)
│   │   ├── app_global_provider.dart            # Quản lý Cubits tập trung (Global Providers)
│   │   └── route_manager.dart                  # Cấu hình GoRouter & App Navigation
│   ├── constant/                               # Hằng số hệ thống (API Routes, Keys, Secure Keys)
│   ├── data/                                   # Tầng dữ liệu (Infrastructure)
│   │   ├── network/                            # Retrofit Services, Dio Manager, Error Handling
│   │   ├── request/                            # API Request Models (toJson)
│   │   ├── response/                           # API Response Models (fromJson & mapping)
│   │   ├── repository.dart                     # Giao diện Repository (Abstract)
│   │   └── repository_implement.dart           # Triển khai Repository (DI Injectable)
│   ├── domain/                                 # Tầng nghiệp vụ (Business Entities)
│   │   ├── booked_appointment.dart             # Thực thể Lịch hẹn
│   │   ├── encounter.dart                      # Thực thể Hồ sơ khám (Clinical)
│   │   ├── prescription.dart                   # Thực thể Đơn thuốc
│   │   ├── invoice.dart                        # Thực thể Hóa đơn
│   │   └── ... (25+ Domain Entities)           # branch, department, specialty, doctor, etc.
│   ├── presentation/                           # Tầng giao diện (UI)
│   │   ├── screens/                            # Màn hình theo tính năng (Features)
│   │   │   ├── ai_assistant/                   # Trợ lý ảo Mii Chan (Gemini AI)
│   │   │   ├── appointment/                    # Quản lý danh sách lịch hẹn
│   │   │   ├── appointment_detail/             # Chi tiết lịch hẹn, Kết quả & Đơn thuốc
│   │   │   ├── doctor/                         # Thông tin bác sĩ & Đặt khám theo bác sĩ
│   │   │   ├── speciality/                     # Thông tin khoa & Đặt khám theo khoa
│   │   │   ├── medical_record/                 # Quản lý hồ sơ bệnh nhân (Người thân)
│   │   │   ├── medical_history/                # Lịch sử khám bệnh cá nhân
│   │   │   ├── payment/                        # Hóa đơn & Thanh toán QR Code
│   │   │   ├── notification/                   # Hệ thống thông báo đẩy
│   │   │   ├── auth/                           # Xác thực (OTP, Phone, Email, Pasword)
│   │   │   ├── user_profile/                   # Thông tin tài khoản & Cài đặt
│   │   │   └── ... (news, theme_setting, language_setting, etc.)
│   │   └── widgets/                            # Widgets dùng chung toàn app (Reusable)
│   │       ├── data_display/                   # Widgets hiển thị dữ liệu (Cards, Rows)
│   │       └── feedback/                       # Widgets phản hồi (Toasts, Loading, EmptyState)
│   └── main.dart                               # Khởi tạo App & DI Setup
├── .env                                        # Biến môi trường (Base URL, API Key)
└── pubspec.yaml                                # Cấu hình dependencies & assets
```

---

## 🌟 TÍNH NĂNG NỔI BẬT

- **🤖 Trợ lý AI Mii Chan**: Tư vấn sức khỏe và tìm kiếm sơ cấp dựa trên Google Gemini API.
- **📅 Đặt lịch đa luồng**: Quy trình đặt lịch linh hoạt theo Bác sĩ hoặc Chuyên khoa với Shift/Slot thực tế.
- **📋 EHR & EHR Digitalization**: Xem trực tuyến Kết luận bác sĩ, Ghi chú lâm sàng và Đơn thuốc chi tiết.
- **💳 Tài chính Y tế**: Quản lý hóa đơn dịch vụ, lịch sử thanh toán và tích hợp QR Code Payment.
- **👨‍👩‍👧 Quản lý gia đình**: Một tài khoản quản lý nhiều hồ sơ bệnh nhân khác nhau.
- **⚙️ Cá nhân hóa**: Tùy chỉnh ngôn ngữ (Việt/Anh), Dark Mode và tích hợp Lịch hệ thống.

---

## 🚀 QUY TẮC PHÁT TRIỂN & LUỒNG DỮ LIỆU

### 1. Luồng dữ liệu chuẩn (The Golden Flow)
`UI Action → Cubit (Emit State) → Repository (Call Data) → CoreService (API) → Mapper (.map()) → Cubit (Emit Loaded) → UI Update`

### 2. Nguyên tắc "Vàng"
1.  **Strict Clean Architecture**: Tuyệt đối không để code UI chứa logic nghiệp vụ hoặc gọi API trực tiếp.
2.  **Mapping Domain**: Dữ liệu từ API (`Model`) phải được ánh xạ sang `Entity` ở tầng Repository trước khi về Cubit.
3.  **Dependency Injection**: Chỉ sử dụng `getIt` để lấy instance. Không dùng `new` hoặc khởi tạo thủ công các Service/Repo.
4.  **No Local State in Cubit**: Cubit không chứa biến class để lưu data, mọi trạng thái hiển thị phải nằm hoàn toàn trong `State`.
5.  **UI Consistency**: Sử dụng hệ thống `AppColors`, `AppFont` và `AppShadow`. Không hard-code các giá trị style.

---

## 🏁 BẮT ĐẦU

### 1. Cài đặt môi trường
Tạo file `.env` tại thư mục gốc:
```env
BASE_URL=https://your-api-server.com
GEMINI_API_KEY=your_key_here
Gemini_Model=your_model_here
```

### 2. Sinh mã tự động (Build Runner)
Bắt buộc chạy mỗi khi cập nhật Model, Cubit hoặc Dependency:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Chạy dự án
```bash
flutter run
```

---

> [!IMPORTANT]
> Toàn bộ Icons và Hình ảnh phải được khai báo trong thư mục `assets/` và sử dụng thông qua các hằng số hoặc class tiện ích, không chèn thủ công String path trong code giao diện.