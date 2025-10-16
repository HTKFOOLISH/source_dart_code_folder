# num_1_test

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Cấu trúc thư mục mẫu

```sh
lib
├─── config                               # Chứa các cấu hình toàn cục cho ứng dụng
├─┬─ data                                 # Tầng dữ liệu (Data Layer) chịu trách nhiệm lấy, lưu và xử lý dữ liệu thực tế (từ API, database, local storage, MQTT, v.v.)
│ ├─┬─ model                              # Chứa các model dữ liệu thô được map trực tiếp từ nguồn (ví dụ JSON từ API)
│ │ └─── <api model class>.dart
│ ├─┬─ repositories                       # Là lớp trung gian giữa ViewModel và Service. Đóng vai trò tổng hợp dữ liệu từ nhiều nguồn (API, cache, local database…). Che giấu chi tiết cách dữ liệu được lấy ra.
│ │ └─── <repository class>.dart
│ └─┬─ services                           # Là lớp làm việc trực tiếp với nguồn dữ liệu thực tế.
│   └─── <service class>.dart
├─┬─ domain                               # Tầng nghiệp vụ (Business / Entities Layer). Mục đích: gom các mô hình dữ liệu (model) mà cả UI và Data đều dùng chung
│ └─┬─ models                             # các model API (data từ mạng)
│   └─── <model name>.dart
├─── routing                              # Chứa logic điều hướng giữa các màn hình (navigation).
├─┬─ ui                                   # Presentation Layer (tầng giao diện người dùng), nơi xử lý UI và state logic
│ ├─┬─ core                               # Chứa các phần dùng chung giữa nhiều màn hình (nhiều feature)
│ │ ├─── themes                           # theme, style chung (màu sắc, typography, style app, ...)
│ │ └─┬─ ui                               # các widget tái sử dụng
│ │   └─── <shared_widgets>
│ └─┬─ <FEATURE_NAME>                     # Chứa mỗi tính năng (feature) của app => có thư mục riêng để dễ quản lý
│   ├─┬─ view_model                       # Chứa logic xử lý và quản lý state cho feature đó.
│   │ └─── <view_model class>.dart
│   └─┬─ widgets                          # Chứa các widget UI của feature đó như:
│     ├── <feature name>_screen.dart      # - giao diện chính
│     └── <other widgets>                 # - các widgets con nhỏ hơn
├─── utils                                # Chứa các hàm tiện ích hoặc lớp helper được dùng chung trong toàn bộ app
├─── main_development.dart
├─── main_staging.dart
└─── main.dart

# The test folder contains unit and widget tests
test
├─── data
├─── domain
├─── ui
└─── utils

# The testing folder contains mocks other classes need to execute tests
testing
├─── fakes
└─── models
```

Với:

- Folder `ui` chia theo feature, chứa `view_model` và `widgets`.
- Folder `data` chứa repository, service, và các lớp model dùng cho API.
- `domain` chứa các kiểu dữ liệu dùng chung (models) mà cả data layer và ui layer đều dùng.
- Ngoài ra, ứng dụng có 3 điểm vào `main` khác nhau cho môi trường: production, development, staging.
- Về test: thư mục `test/` có cấu trúc tương ứng với `lib/`. Có thêm thư mục `testing/` chứa mocks, fake classes phục vụ test.

| Tầng      | Mục đích                                         | Kết nối với             |
| --------- | ------------------------------------------------ | ----------------------- |
| `ui`      | Hiển thị giao diện và xử lý tương tác người dùng | ViewModel               |
| `domain`  | Chứa mô hình nghiệp vụ, thuần dữ liệu            | Repository và ViewModel |
| `data`    | Quản lý truy cập dữ liệu (API, DB, Firebase)     | Repository gọi Service  |
| `config`  | Cấu hình môi trường, endpoint                    | Toàn app                |
| `utils`   | Các hàm hỗ trợ chung                             | Toàn app                |
| `routing` | Điều hướng giữa các trang                        | Toàn app                |
