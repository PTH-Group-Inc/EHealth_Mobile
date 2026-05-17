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

## 🏁 BẮT ĐẦU VÀ CHẠY DỰ ÁN

### 1. Chuẩn bị môi trường (Prerequisites)
- Yêu cầu cài đặt **Flutter SDK** (Khuyến nghị phiên bản `3.10.7` trở lên phù hợp với cấu hình `sdk: '^3.10.7'` trong `pubspec.yaml`).
- Đảm bảo Flutter đã được cấu hình chính xác bằng cách chạy lệnh:
  ```bash
  flutter doctor
  ```
- Cài đặt IDE hỗ trợ: **Visual Studio Code** (khuyên dùng) hoặc **Android Studio**.

### 2. Hướng dẫn mở dự án (How to Open the Project)
* **Visual Studio Code:**
  1. Mở ứng dụng Visual Studio Code.
  2. Chọn `File` -> `Open Folder...` (hoặc phím tắt `Ctrl + K Ctrl + O` trên Windows).
  3. Duyệt đến thư mục `EHealth_Mobile` và nhấn chọn.
  4. Đề xuất cài đặt các Extensions từ VS Code Marketplace để tối ưu hiệu suất phát triển:
     - **Dart** và **Flutter** (hỗ trợ phân tích cú pháp, chạy và gỡ lỗi).
     - **Bloc** (hỗ trợ làm việc với Cubit/State Management tiện lợi).
     - **Awesome Flutter Snippets** (các mẫu viết code nhanh).

* **Android Studio:**
  1. Mở ứng dụng Android Studio.
  2. Chọn `Open` từ màn hình chào mừng hoặc `File` -> `Open...`.
  3. Chọn thư mục `EHealth_Mobile` và nhấn `OK`.
  4. Đợi IDE thực hiện đồng bộ cấu hình Gradle và Flutter Plugins.

### 3. Cấu hình biến môi trường (Environment Setup)
Tạo tệp tin `.env` tại thư mục gốc của dự án (cùng cấp với tệp `pubspec.yaml`) để định nghĩa các Endpoint API và khóa bảo mật:
```env
Gemini_API_Key=your_gemini_api_key_here
Gemini_Model=gemini-2.5-flash
BASE_URL=http://your-server-ip:3000
BASE_URL_DEV=https://your-dev-server.com
BASE_URL_LOCAL=http://10.0.2.2:3000
```
> [!NOTE]
> Bạn có thể tham khảo tệp tin `.env` thực tế sẵn có trong máy để lấy thông số chính xác cho việc kết nối API.

### 4. Cài đặt các gói phụ thuộc (Dependencies Installation)
Mở Terminal tại thư mục gốc của dự án và tải toàn bộ các gói thư viện cần thiết bằng lệnh:
```bash
flutter pub get
```

### 5. Sinh mã nguồn tự động (Build Runner)
Đây là bước **bắt buộc** và quan trọng mỗi khi cập nhật Model, Request/Response, Cubit hoặc các đăng ký Dependency Injection. Lệnh này sẽ tự động tạo ra các lớp bổ trợ cần thiết:
```bash
dart run build_runner build --delete-conflicting-outputs
```
> [!TIP]
> Sử dụng thêm tham số `--delete-conflicting-outputs` giúp tránh các lỗi xung đột tệp sinh ra từ các phiên chạy trước.

### 6. Chạy dự án (How to Run the App)
Đảm bảo bạn đã khởi chạy một máy ảo (Android Emulator / iOS Simulator) hoặc kết nối thiết bị thật (đã kích hoạt chế độ USB Debugging).

* **Cách 1: Chạy qua dòng lệnh (Terminal):**
  - Kiểm tra danh sách thiết bị đang kết nối:
    ```bash
    flutter devices
    ```
  - Chạy ứng dụng:
    ```bash
    flutter run
    ```
  - Chạy trên một thiết bị cụ thể (nếu kết nối nhiều thiết bị):
    ```bash
    flutter run -d <Device_ID>
    ```

* **Cách 2: Chạy trực tiếp trên Visual Studio Code:**
  1. Mở tệp tin [main.dart](file:///d:/MobileDev/DoAnTotNghiep/EHealth_Mobile/lib/main.dart).
  2. Chọn thiết bị mục tiêu ở góc dưới cùng bên phải thanh trạng thái (Status Bar).
  3. Chọn Run and debug (Ctrl + Shift + D) chọn flavor để chạy dự án.

* **Cách 3: Chạy trực tiếp trên Android Studio:**
  1. Chọn thiết bị đích từ danh sách thiết bị mục tiêu (Target Device selector).
  2. Đảm bảo cấu hình chạy được chọn là `main.dart`.
  3. Nhấp vào nút biểu tượng **Run** (hình tam giác màu xanh) hoặc **Debug** (hình con bọ).

---

> [!IMPORTANT]
> Toàn bộ Icons và Hình ảnh phải được khai báo trong thư mục `assets/` và sử dụng thông qua các hằng số hoặc class tiện ích, không chèn thủ công String path trong code giao diện.