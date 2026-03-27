# EHealth - Mobile Patient App

Ứng dụng Flutter dành cho bệnh nhân trong hệ thống EHealth, tích hợp trợ lý AI và đặt lịch khám.

## 🏗 KIẾN TRÚC DỰ ÁN (Clean Architecture)

Dự án tuân thủ **Clean Architecture** kết hợp với **Feature-Based structure** để đảm bảo tính mở rộng và dễ bảo trì.

### Cấu trúc thư mục chi tiết (Project Tree):

```text
EHealth_Mobile/
├── assets/                                     # Tài nguyên tĩnh (Ảnh, Icons, Fonts)
├── lib/
│   ├── app/                                    # Cấu hình cấp ứng dụng
│   │   ├── dependency_injection/               # Thiết lập GetIt & Injectable
│   │   ├── helper/                             # Các tiện ích (Dialog, Format, Validation)
│   │   ├── theme/                              # Quản lý Theme & Màu sắc
│   │   ├── app_global_provider.dart            # Global providers
│   │   └── route_manager.dart                  # Cấu hình điều hướng (GoRouter)
│   ├── data/                                   # Tầng dữ liệu (Infrastructure)
│   │   ├── network/                            # Network (Dio, Retrofit Service, Interceptors)
│   │   ├── request/                            # Model cho yêu cầu API
│   │   ├── response/                           # Model cho phản hồi API
│   │   ├── repository.dart                     # Interface cho Repositories
│   │   └── repository_implement.dart           # Implementation của Repositories (Singleton)
│   ├── domain/                                 # Tầng nghiệp vụ (Business Entities)
│   │   ├── medical_facility.dart               # Thực thể (Entities)
│   │   ├── pagination.dart                     # Thực thể dùng chung
│   │   └── user_profile.dart                   # Thực thể người dùng
│   ├── presentation/                           # Tầng giao diện (UI)
│   │   ├── screens/                            # Màn hình theo tính năng (Feature-based)
│   │   │   ├── ai_assistant/                   # Tính năng Trợ lý AI
│   │   │   ├── auth/                           # Tính năng Xác thực
│   │   │   ├── home/                           # Màn hình chính
│   │   │   └── ...                             # Các tính năng khác (Search, Settings,...)
│   │   └── widgets/                            # Các Widget dùng chung toàn App
│   ├── firebase_options.dart                   # Cấu hình Firebase (Tự động tạo)
│   ├── gemini_services.dart                    # Dịch vụ AI Gemini
│   └── main.dart                               # Điểm bắt đầu ứng dụng
├── .env                                        # Biến môi trường
├── Makefile                                    # Lệnh tắt cho Build & Clean
├── pubspec.yaml                                # Quản lý dependencies
└── README.md                                   # Tài liệu hướng dẫn
```

### Giải thích các thư mục chính:

- **lib/app/**: Chứa cấu hình toàn ứng dụng (Dependency Injection, Theme, Global Providers, App Helpers).
- **lib/data/**: Tầng dữ liệu (Network, Request/Response model cho API, Repository Implementations).
- **lib/domain/**: Tầng nghiệp vụ (Entities, Repository Interfaces).
- **lib/presentation/**: Tầng giao diện (Screens theo tính năng, Cubits, Reusable Widgets).

---

## 🚀 LUỒNG PHÁT TRIỂN TÍNH NĂNG (Feature Workflow)

Để thêm một tính năng mới (ví dụ: Gọi API), hãy tuân thủ các bước sau:

### Bước 1: Khai báo API Route
Mở `lib/constant/common_constant.dart` hoặc class `RouteApi` trong `lib/data/network/router.dart` để định nghĩa endpoint.

### Bước 2: Tạo Model (Data Layer)
- Tạo Request/Response model trong `lib/data/request/` hoặc `lib/data/response/`.
- Sử dụng `@JsonSerializable`.
- **Bắt buộc**: Implement hàm `.map()` để chuyển đổi dữ liệu từ Response (Data layer) sang Entity (Domain layer).

### Bước 3: Định nghĩa Repository (Domain Layer)
- Khai báo interface trong `lib/data/repository.dart`.
- Trả về dạng `Future<Either<Failure, T>>` (Functional Programming).

### Bước 4: Implement Repository (Data Layer)
- Viết cụ thể logic trong `lib/data/repository_implement.dart`.
- Sử dụng `@Singleton(as: Repository)` để Injectable tự động nhận diện.
- Parse dữ liệu qua `HelperRestResponse` và catch lỗi qua `ErrorHandler`.

### Bước 5: State Management (Presentation Layer)
- Tạo Cubit và State trong thư mục của tính năng đó (`lib/presentation/screens/[feature]/cubit/`).
- Khởi tạo Repository thông qua `getIt<Repository>()`.
- **Quy tắc**: Toàn bộ dữ liệu hiển thị phải nằm trong `State`, không lưu biến cục bộ trong `Cubit`.

---

## 🛠 CẤU HÌNH VÀ CÀI ĐẶT

### 1. Cài đặt môi trường
- Tạo file `.env` tại thư mục gốc và cấu hình các biến môi trường (Base URL, API Keys).
- Đảm bảo Flutter SDK đã được cài đặt.

### 2. Lệnh cơ bản
Tải dependencies:
```bash
flutter pub get
```

Chạy build_runner (Sinh mã cho Retrofit, Injectable, JsonSerializable, Freezed):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📜 QUY TẮC PHONG CÁCH CODE (Coding Standards)

- **UI & Logic**: UI chỉ chứa code giao diện, Business Logic bắt buộc nằm trong Cubit.
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