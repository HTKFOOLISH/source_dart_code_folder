# 🏗️ Flutter Project Architecture Overview

Cấu trúc thư mục sau đây được thiết kế để giúp dự án Flutter dễ mở rộng, dễ bảo trì và tách biệt rõ ràng giữa các lớp **UI – Logic – Data**.

---

## 📁 Cấu trúc tổng thể

```
lib/
├── ui/
│   ├── core/
│   │   ├── ui/           # Các widget dùng chung (Button, TextField, Dialog,...)
│   │   └── themes/       # Theme, style, color scheme, typography dùng chung
│   └── <FEATURE NAME>/   # Mỗi tính năng riêng của app (ví dụ: login, home,...)
│       ├── view_model/   # ViewModel cho feature (chứa logic UI, xử lý state)
│       │   └── <view_model class>.dart
│       └── widgets/      # Các widget liên quan đến feature
│           ├── <feature>_screen.dart  # Màn hình chính của feature
│           └── <sub_widget>.dart      # Các widget nhỏ hơn
│
├── domain/
│   └── models/
│       └── <model class>.dart  # Các model logic thuần (không phụ thuộc UI hay API)
│
├── data/
│   ├── repositories/
│   │   └── <repository class>.dart  # Lớp trung gian giữa ViewModel và Service
│   ├── services/
│   │   └── <service class>.dart     # Giao tiếp với API, Firebase, Database, ...
│   └── model/
│       └── <api model class>.dart   # Model ánh xạ dữ liệu từ API (Data Transfer Objects)
│
├── config/          # Cấu hình chung (environment, constants, keys,...)
│
├── utils/           # Các hàm tiện ích, helper, validator, formatter,...
│
├── routing/         # Định nghĩa routes, navigation và quản lý chuyển màn hình
│
├── main_staging.dart      # File main cho môi trường Staging
├── main_development.dart  # File main cho môi trường Development
└── main.dart              # File main chính cho môi trường Production
```

---

## 🧩 Giải thích chi tiết

### 1. `ui/`
- **core/ui/**: Chứa các widget tái sử dụng được trong nhiều màn hình (ví dụ: `AppButton`, `CustomCard`, `AppTextField`).
- **core/themes/**: Chứa định nghĩa màu sắc, font, kích thước, và theme cho app.
- **<FEATURE NAME>/**: Mỗi tính năng (feature) có thư mục riêng gồm:
  - **view_model/**: Chứa logic điều khiển UI (MVVM, Riverpod, Provider, v.v.).
  - **widgets/**: Giao diện của tính năng đó.

### 2. `domain/`
- Chứa **business models** – đại diện cho dữ liệu trong logic nghiệp vụ.
- Không phụ thuộc UI hay API, giúp dễ test và tái sử dụng.

### 3. `data/`
- **repositories/**: Đóng vai trò trung gian giữa tầng domain và tầng service.  
  → Xử lý việc lấy dữ liệu từ API, cache, hoặc local storage.
- **services/**: Thực hiện các tác vụ như gọi API, giao tiếp với Firebase, SQLite, hoặc sensor.
- **model/**: Chứa các lớp ánh xạ dữ liệu từ JSON (API model).

### 4. `config/`
- Chứa các file cấu hình toàn cục như:
  - Environment (dev, staging, prod)
  - API base URLs
  - Keys và constants dùng chung

### 5. `utils/`
- Chứa các **helper functions** như:
  - Định dạng ngày (`formatDate`)
  - Kiểm tra chuỗi (`isValidEmail`)
  - Log, Toast, hoặc chuyển đổi kiểu dữ liệu

### 6. `routing/`
- Định nghĩa route name, cấu trúc navigation.
- Có thể dùng các package như `go_router`, `auto_route`.

### 7. `main_*.dart`
- Tách riêng `main.dart` cho từng môi trường:
  - `main_development.dart`: Dành cho giai đoạn dev.
  - `main_staging.dart`: Dành cho test trước khi release.
  - `main.dart`: Dành cho production.

---

## ✅ Ưu điểm của kiến trúc này
- Tách biệt rõ ràng **UI – Logic – Data**
- Dễ mở rộng cho các tính năng mới
- Dễ bảo trì và viết unit test
- Hỗ trợ đa môi trường (dev, staging, prod)
- Giảm sự phụ thuộc giữa các tầng, giúp app dễ dàng thay đổi backend hoặc UI framework

---

📘 **Gợi ý mở rộng**:
- Thêm thư mục `core/exceptions/` để quản lý lỗi.
- Thêm `core/network/` cho quản lý kết nối mạng.
- Thêm `core/storage/` để quản lý local database hoặc cache.
