# EHealth - Mobile Patient App

Ứng dụng Flutter dành cho bệnh nhân trong hệ thống EHealth, tích hợp trợ lý AI Mii Chan, đặt lịch khám theo chuyên khoa và quản lý thông tin sức khỏe cá nhân.

## 🏗 KIẾN TRÚC DỰ ÁN (Clean Architecture)

Dự án được xây dựng dựa trên **Clean Architecture** kết hợp với kiến trúc theo tính năng (**Feature-Based**) và quản lý trạng thái bằng **BLoC/Cubit**.

### Cấu trúc thư mục chi tiết (Project Tree):

```text
EHealth_Mobile/
├── assets/                                     # Tài nguyên tĩnh (Ảnh, Icons, Fonts)
├── lib/
│   ├── app/                                    # Cấu hình cấp ứng dụng
│   │   ├── dependency_injection/               # Thiết lập GetIt & Injectable
│   │   ├── helper/                             # Các tiện ích (Dialog, Format, Validation)
│   │   ├── theme/                              # Quản lý Theme & Màu sắc (AppColors)
│   │   ├── app_global_provider.dart            # Cung cấp Cubit toàn cục
│   │   └── route_manager.dart                  # Cấu hình GoRouter & Navigation
│   ├── constant/                               # Hằng số hệ thống
│   ├── data/                                   # Tầng dữ liệu (Infrastructure)
│   │   ├── network/                            # Network (Retrofit Service, Interceptors, Dio)
│   │   ├── request/                            # Model cho yêu cầu API (toJson)
│   │   ├── response/                           # Model cho phản hồi API (fromJson & .map())
│   │   ├── repository.dart                     # Giao diện Repository
│   │   └── repository_implement.dart           # Triển khai Repository (Singleton)
│   ├── domain/                                 # Tầng nghiệp vụ (Business Entities)
│   │   ├── branch.dart                         # Thực thể Chi nhánh
│   │   ├── department.dart                     # Thực thể Chuyên khoa
│   │   ├── specialty.dart                      # Thực thể Chuyên khoa nổi bật
│   │   └── user_profile.dart                   # Thực thể Người dùng
│   ├── presentation/                           # Tầng giao diện (UI)
│   │   ├── screens/                            # Màn hình theo tính năng
│   │   │   ├── ai_assistant/                   # Trợ lý AI Mii Chan
│   │   │   ├── auth/                           # Đăng nhập (Email/Phone), Đăng ký
│   │   │   ├── branch/                         # Danh sách chi nhánh
│   │   │   ├── home/                           # Màn hình chính & Dashboard
│   │   │   ├── speciality/                     # Danh sách & Chi tiết chuyên khoa
│   │   │   └── user_profile/                   # Quản lý thông tin & Đổi mật khẩu
│   │   └── widgets/                            # Widget dùng chung (Feedback, Form, Display)
│   └── main.dart                               # Entry point
├── .env                                        # Biến môi trường (Base URL, Gemini API Key)
├── Makefile                                    # Lệnh tắt hỗ trợ build
└── pubspec.yaml                                # Quản lý thư viện
```

---

## 🌟 TÍNH NĂNG NỔI BẬT

- **Xác thực đa phương thức**: Hỗ trợ đăng nhập bằng Email hoặc Số điện thoại (Việt Nam).
- **Trợ lý AI Mii Chan**: Tư vấn sức khỏe, tìm kiếm chuyên khoa và hướng dẫn thủ tục qua chat.
- **Quản lý Chuyên khoa**: Xem danh sách chuyên khoa nổi bật, lọc theo chi nhánh và xem thông tin chi tiết.
- **Hệ thống Chi nhánh**: Hiển thị danh sách các cơ sở y tế trong hệ thống.
- **Trang cá nhân**: Cập nhật thông tin, ảnh đại diện và thay đổi mật khẩu.

---

## 🚀 LUỒNG PHÁT TRIỂN (Workflow)

Tuân thủ nghiêm ngặt các quy tắc sau khi phát triển:

1. **Relative Imports**: Luôn sử dụng import tương đối (`../`) thay vì package import (`package:e_health/`).
2. **Data Mapping**: Các class ở `data/response/` PHẢI có hàm `.map()` để trả về thực thể ở `domain/`.
3. **Dependency Injection**: Sử dụng `@injectable` và lấy instance qua `getIt<T>()`. Không khởi tạo thủ công.
4. **State Management**:
   - UI chỉ đăng ký nhận State qua `BlocBuilder` hoặc `BlocListener`.
   - Business Logic và xử lý dữ liệu PHẢI nằm trong Cubit.
   - Không lưu dữ liệu hiển thị trong biến cục bộ của Cubit, mọi thứ phải qua State.

---

## 🛠 CÀI ĐẶT VÀ CHẠY DỰ ÁN

### 1. Chuẩn bị
- Sao chép `.env.example` thành `.env` và điền đầy đủ thông tin.
- `flutter pub get` để cài đặt thư viện.

### 2. Sinh mã tự động
Dự án sử dụng `build_runner` để sinh mã cho Models, API Service và DI:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Chạy ứng dụng
```bash
flutter run
```

---

## 📜 QUY TẮC PHONG CÁCH (Coding Standards)

- **UI Guidelines**: Sử dụng mã màu từ `AppColors`. Không set cứng mã hex trực tiếp trong Widget.
- **Naming**: `snake_case` cho file, `PascalCase` cho class, `camelCase` cho biến/hàm.
- **Clean Code**: Hạn chế comment code dư thừa. Tên biến phải tự giải thích ý nghĩa.
- **Notifications**: Sử dụng `AppToast.showSuccess/Error/Info` để thông báo cho người dùng.
chỉ chứa code giao diện, Business Logic bắt buộc nằm trong Cubit.
- **Dependency Injection**: Tuyệt đối không khởi tạo thủ công các Service/Repository. Luôn sử dụng Injectable.
- **Naming**:
  - Class: `PascalCase`.
  - Biến/Hàm: `camelCase`.
  - File: `snake_case`.
- **No Icons/Emojis**: Không chèn trực tiếp icon hoặc emoji vào mã nguồn (trừ file asset).
- **Errors**: Luôn bọc API call bằng try-catch và trả về `Left(Failure)` để UI thông báo lỗi đồng nhất.
- **Standard Notifications**: Sử dụng `AppToast` cho toàn bộ các thông báo `Success`, `Error`, `Info`.

---

## 📦 THƯ VIỆN CHÍNH
- **State Management**: `flutter_bloc`.
- **Networking**: `dio`, `retrofit`.
- **Navigation**: `go_router`.
- **DI**: `get_it`, `injectable`.
- **Utilities**: `freezed`, `json_serializable`, `dartz`.