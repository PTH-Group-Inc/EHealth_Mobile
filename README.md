# EHealth - Mobile Patient App

Ứng dụng Flutter dành cho bệnh nhân trong hệ thống EHealth, tích hợp trợ lý AI Mii Chan, tìm kiếm chuyên khoa, đặt lịch khám và quản lý thông tin sức khỏe cá nhân.

## 🏗 KIẾN TRÚC DỰ ÁN (Clean Architecture)

Dự án được xây dựng dựa trên **Clean Architecture** kết hợp với kiến trúc theo tính năng (**Feature-Based**) và quản lý trạng thái bằng **BLoC/Cubit**.

### Cấu trúc thư mục chi tiết (Project Tree):

```text
EHealth_Mobile/
├── assets/                                     # Tài nguyên tĩnh (Ảnh, Icons, Fonts)
├── lib/
│   ├── app/                                    # Cấu hình cấp ứng dụng
│   │   ├── dependency_injection/               # Thiết lập GetIt & Injectable
│   │   ├── helper/                             # Các tiện ích (HelperRestResponse, Dialog, Format)
│   │   ├── theme/                              # Quản lý Theme & Màu sắc (AppColors, AppShadow)
│   │   ├── app_global_provider.dart            # Cung cấp Cubit toàn cục (Centralized Cubits)
│   │   └── route_manager.dart                  # Cấu hình GoRouter & Navigation
│   ├── constant/                               # Hằng số hệ thống (API Routes, Keys)
│   ├── data/                                   # Tầng dữ liệu (Infrastructure)
│   │   ├── network/                            # Network (Retrofit Service, Interceptors, Dio)
│   │   ├── request/                            # Model cho yêu cầu API (toJson)
│   │   ├── response/                           # Model cho phản hồi API (fromJson & .map())
│   │   ├── repository.dart                     # Giao diện Repository
│   │   └── repository_implement.dart           # Triển khai Repository (Sử dụng HelperRestResponse)
│   ├── domain/                                 # Tầng nghiệp vụ (Business Entities)
│   │   ├── branch.dart                         # Thực thể Chi nhánh
│   │   ├── department.dart                     # Thực thể Phòng khoa
│   │   ├── specialty.dart                      # Thực thể Chuyên khoa
│   │   └── user_profile.dart                   # Thực thể Người dùng
│   ├── presentation/                           # Tầng giao diện (UI)
│   │   ├── screens/                            # Màn hình theo tính năng
│   │   │   ├── ai_assistant/                   # Trợ lý AI Mii Chan (Gemini API)
│   │   │   ├── auth/                           # Đăng nhập, Đăng ký
│   │   │   ├── branch/                         # Danh sách chi nhánh/cơ sở
│   │   │   ├── home/                           # Dashboard & Notifications
│   │   │   ├── search/                         # Tìm kiếm chuyên khoa thông minh
│   │   │   ├── speciality/                     # Danh sách & Chi tiết chuyên khoa
│   │   │   └── user_profile/                   # Quản lý thông tin & Đổi mật khẩu
│   │   └── widgets/                            # Widget dùng chung
│   │       ├── feedback/                       # AppToast, EmptyStateWidget, AppRefresh
│   │       └── ...                             # Các widget thành phần khác
│   └── main.dart                               # Entry point
├── .env                                        # Biến môi trường (Base URL, Gemini API Key)
├── Makefile                                    # Lệnh tắt hỗ trợ build
└── pubspec.yaml                                # Quản lý thư viện
```

---

## 🌟 TÍNH NĂNG NỔI BẬT

- **Xác thực đa phương thức**: Đăng nhập bằng Email/Số điện thoại, đăng ký tài khoản mới.
- **Trợ lý AI Mii Chan**: Sử dụng Google Gemini API để tư vấn sức khỏe và tìm kiếm thông tin chuyên khoa.
- **Tìm kiếm thông minh**: Tìm kiếm chuyên khoa nhanh chóng theo tên hoặc triệu chứng.
- **Quản lý Chuyên khoa & Chi nhánh**: Xem danh sách cơ sở y tế và các chuyên khoa đang hoạt động.
- **Hệ thống Thông báo**: Nhận thông báo về lịch hẹn và tin tức y tế mới nhất.
- **Trang cá nhân**: Quản lý hồ sơ, đổi ảnh đại diện và thay đổi mật khẩu an toàn.

---

## 🚀 QUY TẮC PHÁT TRIỂN (Standards)

Dự án tuân thủ nghiêm ngặt các tiêu chuẩn sau để đảm bảo chất lượng code:

1.  **Imports**: Chỉ sử dụng Import tương đối (`../../`) để tránh lỗi phụ thuộc chéo.
2.  **Mapping**: Dữ liệu từ API (`Data layer`) phải được chuyển đổi sang `Domain layer` thông qua hàm `.map()`.
3.  **Dependency Injection**: Tuyệt đối không khởi tạo thủ công các class. Sử dụng `@injectable` và lấy instance qua `getIt`.
4.  **State Management**:
    - Sử dụng `Cubit` để quản lý logic. Cubit không được chứa biến cục bộ lưu trạng thái, mọi thay đổi phải qua `emit(State)`.
    - Toàn bộ Cubit được quản lý tập trung tại `AppGlobalProvider`.
5.  **API Response**: Sử dụng `HelperRestResponse` để chuẩn hóa kết quả về dạng `Either<Failure, T>`.
6.  **UI consistency**:
    - Sử dụng mã màu từ `AppColors`. Không được dùng mã Hex trực tiếp.
    - Sử dụng `EmptyStateWidget` cho tất cả các trường hợp không có dữ liệu để đảm bảo trải nghiệm người dùng đồng nhất.
    - Sử dụng `AppShadow` cho các hiệu ứng đổ bóng card/container.
7.  **Naming**: `PascalCase` cho Class, `camelCase` cho biến/hàm, `snake_case` cho file.
8.  **No Placeholders**: Không sử dụng icon/emoji trực tiếp trong code. Sử dụng asset hoặc IconData phù hợp.

---

## 🛠 CÀI ĐẶT VÀ CHẠY DỰ ÁN

### 1. Chuẩn bị
- Sao chép `.env.example` thành `.env` và điền `BASE_URL`, `GEMINI_API_KEY`.
- `flutter pub get` để cài đặt thư viện.

### 2. Sinh mã tự động
Chạy lệnh sau để tạo các file `.g.dart` và cấu hình DI:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Chạy ứng dụng
```bash
flutter run
```

---

## 📦 THƯ VIỆN CHÍNH

- **Quản lý trạng thái**: `flutter_bloc` (Cubit).
- **Mạng**: `dio`, `retrofit`, `dartz`.
- **Điều hướng**: `go_router`.
- **Dependency Injection**: `get_it`, `injectable`.
- **Tiện ích**: `freezed`, `json_serializable`, `intl`, `flutter_secure_storage`.