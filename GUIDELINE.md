# GUIDELINE – Flutter MQTT Smart Home App

Dự án Flutter điều khiển thiết bị trong nhà qua **MQTT** (HiveMQ Cloud – TLS 8883).  
Mục tiêu của file này: giúp người khác có thể:

- Clone dự án về
- Cài đầy đủ môi trường
- Cấu hình MQTT broker (mỗi người dùng broker riêng)
- Chạy được app trên thiết bị thật hoặc máy ảo
- Hiểu được cấu trúc dự án và luồng hoạt động chính

---

## 0. Thông tin chung

- **Flutter**: 3.35.4
- **Dart**: 3.9.2
- **MQTT broker**: HiveMQ Cloud (free), TCP/TLS port **8883**
- **Nền tảng chạy**: Android (máy ảo/emulator hoặc thiết bị thật)

App sử dụng:

- `provider` – quản lý state
- `shared_preferences` – lưu data cục bộ (user, room, config MQTT…)
- `mqtt_client` – kết nối MQTT

---

## 1. Chuẩn bị môi trường Flutter

### 1.1. Cài Flutter & Android toolchain

1. Tải **Flutter SDK** (nên dùng bản gần với 3.35.4):

   - Tải từ trang chính thức Flutter.
   - Giải nén và thêm đường dẫn `flutter/bin` vào biến môi trường `PATH`.

2. Cài **Android Studio** (hoặc Android SDK + platform tools):

   - Cài Android SDK, platform-tools, build-tools.
   - Tạo **Android Virtual Device (AVD)** để chạy emulator.

3. Kiểm tra môi trường:

   ```bash
   flutter doctor
   ```

   Đảm bảo các mục sau **không còn lỗi đỏ**:

   - Flutter
   - Android toolchain
   - Android Studio
   - Connected device (sẽ có ít nhất một emulator/thiết bị thật khi bạn chạy app)

> Gợi ý: Nếu dùng đúng Flutter **3.35.4** và Dart **3.9.2** thì sẽ giảm rủi ro lỗi không tương thích.

### 1.2. Chuẩn bị thiết bị chạy app

- Cách 1 – **Android Emulator**:

  - Mở Android Studio → Device Manager → tạo AVD → Start.

- Cách 2 – **Điện thoại Android thật**:

  - Bật Developer Options + USB debugging.
  - Cắm cáp → kiểm tra:

    ```bash
    flutter devices
    ```

---

## 2. Clone project & cài dependency

1. Clone repository (thay `<REPO_URL>` bằng URL thực tế):

   ```bash
   git clone <REPO_URL>
   cd <THU_MUC_PROJECT>
   ```

2. Cài dependencies:

   ```bash
   flutter pub get
   ```

Không có package đặc biệt ngoài những gì thể hiện trong code (`provider`, `shared_preferences`, `mqtt_client`, …).

---

## 3. Cấu hình MQTT (HiveMQ Cloud – mỗi người tự tạo broker riêng)

App sử dụng **HiveMQ Cloud free tier** với:

- Giao thức: TCP
- Port: **8883**
- **TLS: Bật (useTls = true)**

Mỗi người dùng cần **tự tạo một HiveMQ Cloud cluster riêng**, sau đó cấu hình app với thông tin của họ.

### 3.1. Tạo HiveMQ Cloud cluster (tóm tắt)

1. Đăng ký tài khoản HiveMQ Cloud (gói free).
2. Tạo 1 cluster mới.
3. Sau khi tạo xong, bạn sẽ có:
   - **Host** dạng: `xxxxxxx.s1.eu.hivemq.cloud`
   - **Port**: `8883` (TLS)
4. Tạo 1 cặp **username / password** cho MQTT client.

Ghi lại:

- `HIVEMQ_HOST` – hostname của cluster
- `HIVEMQ_USERNAME`
- `HIVEMQ_PASSWORD`
- `PORT` = `8883`
- `TLS` = bật (ON)

### 3.2. Cấu hình MQTT trong `lib/main.dart`

Mở file **`lib/main.dart`**. Tại đây có 3 hằng số:

```dart
const hivemqHost = '...';
const hivemqUser = '...';
const hivemqPass = '...';
```

Bạn **phải sửa** thành thông tin cluster của mình, ví dụ:

```dart
const hivemqHost = '<YOUR_HIVEMQ_HOST>';     // ví dụ: abcd1234.s1.eu.hivemq.cloud
const hivemqUser = '<YOUR_HIVEMQ_USERNAME>'; // username tạo trên HiveMQ Cloud
const hivemqPass = '<YOUR_HIVEMQ_PASSWORD>'; // password tương ứng
```

Cấu hình dùng để tạo `MqttConfig`:

```dart
cfg = MqttConfig.tcp(
  host: hivemqHost,
  port: 8883,        // TLS/TCP của HiveMQ Cloud
  useTls: true,      // bắt buộc TLS cho cổng 8883
  username: hivemqUser,
  password: hivemqPass,
  clientId: 'flutter-${DateTime.now().millisecondsSinceEpoch}',
  keepAliveSec: 30,
).copyWith(
  willTopic: 'home/app/status',
  willPayload: 'offline',
  willQos: 1,
  willRetain: true,
);
```

Một số điểm quan trọng:

- **`useTls: true`** – bắt buộc vì HiveMQ Cloud yêu cầu TLS với port 8883.
- **Last Will**: khi client bị mất kết nối, broker sẽ publish:
  - Topic: `home/app/status`
  - Payload: `"offline"`

Ngoài ra, trong `main.dart` còn có cờ:

```dart
const bool DEV_FORCE_OVERWRITE = true;
```

- Nếu **true**: cấu hình MQTT mới sẽ được ghi đè vào SharedPreferences mỗi lần chạy app (tiện để test).
- Khi cấu hình đã ổn định, bạn có thể đổi về `false` để tránh ghi đè.

### 3.3. Cách app lưu & dùng cấu hình MQTT

Trong **`lib/mqtt/mqtt_config.dart`**:

- Class **`MqttConfig`** chứa:
  - `host`, `port`, `transport`, `useTls`, `username`, `password`, `clientId`, `keepAliveSec`, `cleanSession`, `resubscribeOnAutoReconnect`, `willTopic`, `willPayload`, `willQos`, `willRetain`…
- Hàm static:
  - `MqttConfig.load()` – đọc config từ SharedPreferences (key `'mqtt_config_v2'`)
  - `MqttConfig.save(cfg)` – lưu config
  - `MqttConfig.clear()` – xoá config

Trong **`main.dart`**:

1. App gọi `MqttConfig.load()`.
2. Nếu:
   - Chưa có config, hoặc
   - `DEV_FORCE_OVERWRITE == true`  
     ⇒ tạo config mới từ 3 hằng `hivemqHost`, `hivemqUser`, `hivemqPass`, rồi lưu lại bằng `MqttConfig.save(cfg)`.
3. Gọi `MqttService.I.connect(cfg)` để kết nối MQTT **một lần khi khởi động app**.

Ngoài ra, màn `LoginScreen` cũng có `_ensureMqttConnected()`:

- Sau khi đăng nhập thành công, nó sẽ load `MqttConfig` và reconnect nếu cần.

---

## 4. Chạy app

Sau khi:

- Cài xong Flutter + Android SDK
- Clone dự án
- Chạy `flutter pub get`
- Điền cấu hình HiveMQ Cloud vào `main.dart`

thì thực hiện:

1. Bật emulator hoặc cắm điện thoại Android.
2. Trong thư mục project:

   ```bash
   flutter run
   ```

3. App sẽ:
   - Khởi động `main()`.
   - Load/ghi cấu hình MQTT, gọi `MqttService.I.connect(cfg)`.
   - Chạy self-test ping với topic `diag/ping`.
   - Inject các provider:
     - `RoomProvider`
     - `UserProvider`
     - `MqttRoomStore`
   - Chạy `MyApp` với route mặc định là màn **Login**.

### 4.1. Đăng nhập lần đầu

- File: `lib/state/user_provider.dart`

  - Khi `load()`:
    - Đọc danh sách user từ SharedPreferences (`user_accounts_v1`).
    - Nếu danh sách rỗng → tự động tạo user mặc định:
      - **username**: `admin`
      - **password**: `123`

- File: `lib/ui/login/login_screen.dart`
  - Nhập:
    - Username: `admin`
    - Password: `123`
  - Nếu validate thành công:
    - Lưu `username` & `password` vào SharedPreferences.
    - Gọi `_ensureMqttConnected()` để đảm bảo MQTT đang kết nối.
    - Điều hướng sang màn hình Home (`AppRoutes.home`).

---

## 5. Hiểu cấu trúc dự án & luồng chính

### 5.1. Cấu trúc thư mục `lib/`

```text
lib
 ┣ config
 ┣ models
 ┃ ┣ room.dart
 ┃ ┗ user_model.dart
 ┣ mqtt
 ┃ ┣ mqtt_config.dart
 ┃ ┣ mqtt_service.dart
 ┃ ┣ room_payloads.dart
 ┃ ┗ room_topics.dart
 ┣ routing
 ┃ ┣ app_router.dart
 ┃ ┗ app_routes.dart
 ┣ state
 ┃ ┣ mqtt_room_store.dart
 ┃ ┣ room_provider.dart
 ┃ ┗ user_provider.dart
 ┣ ui
 ┃ ┣ config_screen
 ┃ ┃ ┣ config_room_card.dart
 ┃ ┃ ┗ user_management_screen.dart
 ┃ ┣ devices_screen
 ┃ ┃ ┣ devices_model.dart
 ┃ ┃ ┗ devices_view_model.dart
 ┃ ┣ home_screen
 ┃ ┃ ┣ home_screen.dart
 ┃ ┃ ┗ room_card.dart
 ┃ ┣ login
 ┃ ┃ ┗ login_screen.dart
 ┃ ┣ room_screen
 ┃ ┃ ┗ living_room
 ┃ ┃   ┗ living_room.dart
 ┃ ┗ widgets
 ┃   ┗ show_icon_options.dart
 ┣ main.dart
 ┗ my_app.dart
```

### 5.2. Entry point & routing

- **`lib/main.dart`**

  - `main()`:
    - Khởi tạo Flutter binding.
    - Load/ghi cấu hình MQTT (dựa trên 3 hằng HiveMQ).
    - Kết nối MQTT một lần bằng `MqttService.I.connect(cfg)`.
    - Đăng ký listener connection để phục vụ self-test ping (`diag/ping`).
    - Tạo `MultiProvider`:
      - `RoomProvider`
      - `UserProvider`
      - `MqttRoomStore`
    - Chạy `MyApp`.

- **`lib/my_app.dart`**

  - Khởi tạo `MaterialApp`:
    - Thiết lập theme, colorScheme, AppBarTheme…
    - `onGenerateRoute: onGenerateRoute` (từ `app_router.dart`).
    - Route mặc định trỏ tới `LoginScreen`.

- **`lib/routing/app_routes.dart`**

  - Định nghĩa các route string, ví dụ:
    - `AppRoutes.login = '/login'`
    - `AppRoutes.home = '/home'`
    - `AppRoutes.livingRoom = '/living_room'`
    - `AppRoutes.configRoom = '/config_room'`
    - `AppRoutes.manageUsers = '/manage_users'`
    - …

- **`lib/routing/app_router.dart`**
  - Hàm `onGenerateRoute(RouteSettings settings)`:
    - `AppRoutes.login` → `LoginScreen`
    - `AppRoutes.home` → `HomeScreen`
    - `AppRoutes.livingRoom` → `LivingRoomScreen` (nhận `Room` từ `settings.arguments`)
    - `AppRoutes.configRoom` → `ConfigRoomCard`
    - `AppRoutes.manageUsers` → `UserManagementScreen`

### 5.3. Models & state lưu bằng SharedPreferences

#### Room – `models/room.dart`

- Trường:
  - `id`, `title`, `imagePath`, `deviceCount`, `initialState`.
- Dùng để:
  - Hiển thị danh sách phòng
  - Lưu cấu hình phòng
- Có:
  - `toJson()`, `fromJson()`
  - `listFromJsonString()`, `listToJsonString()`

#### User – `models/user_model.dart`

- Trường:
  - `username`, `password`
- Lưu dưới key `'user_accounts_v1'` trong SharedPreferences.
- **Lưu ý**: mật khẩu ở dạng plain text (đúng theo code hiện tại, không thêm mã hoá).

#### Device – `ui/devices_screen/devices_model.dart`

- Trường:
  - `name`, `pathImageName`, `isOn`, `voltage`, `current`, `power`.
- Dùng để:
  - Biểu diễn thiết bị trong phòng (ví dụ Living Room).
- Có `toJson()` / `fromJson()` để lưu danh sách thiết bị theo phòng.

#### RoomProvider – `state/room_provider.dart`

- Quản lý danh sách `Room`.
- Có danh sách mặc định `myRoomAtStart`:
  - Living Room, Bed Room, Kitchen, Garage, Garden, Reading Room.
- Lưu vào SharedPreferences với key riêng (`rooms_v1`).
- API:
  - `load()` – khởi tạo từ SharedPreferences hoặc danh sách mặc định.
  - `add(room)`, `removeById(id)`, `update(room)`.
  - `rooms` – trả về danh sách phòng.

#### UserProvider – `state/user_provider.dart`

- Quản lý danh sách `User`.
- Lưu vào SharedPreferences (`user_accounts_v1`).
- Khi `load()`:
  - Nếu không có user nào → tạo user mặc định `admin/123`.
- API:
  - `add(user)`, `remove(username)`, `validate(username, password)`.

### 5.4. Lớp MQTT & store runtime

#### MqttConfig – `mqtt/mqtt_config.dart`

- Chứa cấu hình đầy đủ cho MQTT:
  - `host`, `port`, `transport` (TCP/WebSocket)
  - `useTls`, `username`, `password`
  - `clientId`, `keepAliveSec`, `cleanSession`
  - `willTopic`, `willPayload`, `willQos`, `willRetain`
- Các factory:
  - `MqttConfig.tcp(...)`
  - `MqttConfig.websocket(...)`
  - `MqttConfig.local()`
- Persist bằng SharedPreferences (key `'mqtt_config_v2'`):
  - `load()/save()/clear()`

#### MqttService – `mqtt/mqtt_service.dart`

- Singleton: `MqttService.I`.
- Bọc `MqttServerClient`.
- Nhiệm vụ:
  - `connect(MqttConfig cfg)` – thiết lập client, TLS, keepAlive, last will, rồi connect.
  - `disconnect()`
  - `subscribe(topic, qos)`
  - `publishString(topic, payload, qos, retain)`
- Cung cấp:
  - `Stream<MqttIncomingMessage> get messages`
  - `Stream<bool> get connection` – `true` khi kết nối, `false` khi mất kết nối.
- Tự động subscribe lại các topic đã đăng ký khi reconnect (nếu bật `resubscribeOnAutoReconnect` trong config).

#### Topics – `mqtt/room_topics.dart`

- Root topic: `home`.
- Quy ước:
  - Snapshot (thông tin từ thiết bị → app):
    - `home/rooms/{roomId}/snapshot`
  - Command (lệnh từ app → thiết bị):
    - `home/rooms/{roomId}/command`
- Wildcard:
  - `home/rooms/+/snapshot`
  - `home/rooms/+/command`

#### Payload JSON – `mqtt/room_payloads.dart`

- `DeviceStateDto`:

  ```json
  { "id": "light-1", "on": true }
  ```

- `SensorDto`:

  ```json
  { "id": "temp", "value": 26.5 }
  ```

- `RoomPacket` (snapshot của một phòng):

  ```json
  {
    "roomId": "001",
    "devices": [ { "id": "...", "on": true }, ... ],
    "sensors": [ { "id": "...", "value": 12.3 }, ... ],
    "ts": 123456789
  }
  ```

- `RoomCommand` (lệnh điều khiển):

  ```json
  {
    "roomId": "001",
    "devices": [ { "id": "...", "on": true }, ... ],
    "ts": 123456789
  }
  ```

Tất cả được parse/encode theo đúng code hiện tại, không bổ sung logic khác.

#### MqttRoomStore – `state/mqtt_room_store.dart`

- Quản lý **runtime state** từ MQTT cho từng phòng.
- `RoomRuntimeState`:
  - `roomId`
  - `deviceOn: Map<String, bool>`
  - `sensors: Map<String, num>`
  - `ts: int` – timestamp cập nhật cuối.
- Đăng ký listener:
  - `MqttService.messages`:
    - Nhận message, parse theo topic:
      - `_snapshot` → `RoomPacket`
      - `_command` → `RoomCommand` (mirror lệnh).
  - `MqttService.connection`:
    - Khi kết nối lại (`ok == true`) → subscribe:
      - `RoomTopics.wildcardSnapshot()`
      - `RoomTopics.wildcardCommand()`
- Hàm quan trọng:
  - `setDevice(String roomId, String deviceId, bool on)`:
    - Tạo `RoomCommand` chứa 1 `DeviceStateDto`.
    - Gọi `_svc.sendRoomCommand(cmd)` để publish tới `home/rooms/{roomId}/command`.
    - Cập nhật state local cho mượt UI (không cần chờ phản hồi).

### 5.5. UI & luồng sử dụng

#### Login – `ui/login/login_screen.dart`

- Nhập `username` / `password`.
- Validate rỗng, hiển thị lỗi nếu `_submitted = true`.
- Dùng `UserProvider.validate` để kiểm tra.
- Nếu thành công:
  - Lưu thông tin user vào SharedPreferences.
  - Gọi `_ensureMqttConnected()` (dùng `MqttConfig.load()` + `MqttService.I.connect()` nếu cần).
  - Điều hướng đến `HomeScreen`.

#### Home – `ui/home_screen/home_screen.dart`

- Lấy danh sách phòng từ `RoomProvider`.
- Hiển thị từng phòng bằng `RoomCard` (`ui/home_screen/room_card.dart`):
  - Ảnh, tên phòng, số device.
  - `onTap`: mở màn Living Room tương ứng (route `AppRoutes.livingRoom` + truyền `Room`).
  - `onLongPress`: logic xoá phòng.
  - `onDoubleTap`: logic khác theo code hiện hành (ví dụ toggle trạng thái).
- Nút `+` (FAB):
  - Điều hướng sang `ConfigRoomCard` để thêm phòng.
- AppBar có nút menu:
  - Hiển thị `ShowIconOptions`:
    - Đi đến màn Config Room
    - Đi đến Manage Users
    - Logout

#### Config Room – `ui/config_screen/config_room_card.dart`

- Form cấu hình:
  - `Name`
  - `No.Devices`
  - Ảnh phòng
  - `initialState` (bật/tắt ban đầu)
- Khi `Save`:
  - Tạo `Room` mới hoặc cập nhật Room cũ (tuỳ theo bạn mở màn hình để add hay edit).
  - Dùng `RoomProvider` để lưu.

#### Manage Users – `ui/config_screen/user_management_screen.dart`

- Dùng `UserProvider`:
  - Hiển thị list user.
  - Thêm user (qua dialog + form).
  - Xoá user (không cho xoá user cuối cùng).
- Có nút **Reconnect MQTT**:
  - Gọi `MqttConfig.load()` + `MqttService.I.connect(cfg)`.

#### Living Room – `ui/room_screen/living_room/living_room.dart`

- `LivingRoomScreen` nhận `Room` từ `RouteSettings.arguments`.
- Bên trong:
  - Dùng `ChangeNotifierProvider<DevicesViewModel>`:
    - `DevicesViewModel` liên kết với `MqttRoomStore`.
  - Load danh sách `Device` cho phòng:
    - Nếu đã lưu trong SharedPreferences → dùng lại.
    - Nếu chưa → dùng danh sách mặc định cho phòng đó (theo logic trong code).
  - Gọi `viewModel.bindRoom(roomId, devices)` để:
    - Ánh xạ `roomId` với `MqttRoomStore`.
    - Lắng nghe cập nhật từ MQTT.
- Khi user bật/tắt thiết bị:
  - UI gọi `viewModel.toggleDevice(device, value)`.
  - ViewModel:
    - Cập nhật trạng thái `device.isOn`.
    - Gọi `store.setDevice(roomId, deviceId, value)` → publish MQTT.

Ngoài ra còn có phần mô phỏng sensor bằng `Timer` + `Random` phục vụ hiển thị UI, không thêm giao thức MQTT mới.

#### Menu overlay – `ui/widgets/show_icon_options.dart`

- Hiển thị một menu nổi (overlay) gồm:
  - Điều hướng đến Config Room
  - Điều hướng đến Manage Users
  - **Logout**:
    - Xoá `'username'` & `'password'` trong SharedPreferences.
    - `Navigator.pushNamedAndRemoveUntil(AppRoutes.login, ...)`
    - Hiển thị SnackBar “You are logged out!”

---

## 6. Quy trình nhanh cho người mới

1. Cài Flutter + Android SDK (tương thích Flutter 3.35.4).
2. Clone repo:

   ```bash
   git clone <REPO_URL>
   cd <THU_MUC_PROJECT>
   flutter pub get
   ```

3. Tạo HiveMQ Cloud cluster (free), lấy:

   - Host
   - Username
   - Password
   - Port 8883 (TLS)

4. Mở `lib/main.dart`, sửa:

   ```dart
   const hivemqHost = '<YOUR_HIVEMQ_HOST>';
   const hivemqUser = '<YOUR_HIVEMQ_USERNAME>';
   const hivemqPass = '<YOUR_HIVEMQ_PASSWORD>';
   ```

   Đảm bảo `useTls: true` và port là `8883` như code hiện tại.

5. Bật emulator hoặc cắm điện thoại Android, rồi chạy:

   ```bash
   flutter run
   ```

6. Đăng nhập lần đầu:

   - Username: `admin`
   - Password: `123`

7. Sau khi login:
   - Vào Home → xem danh sách phòng.
   - Thêm/sửa/xoá phòng.
   - Vào Living Room → bật/tắt thiết bị → app publish lệnh MQTT theo cấu trúc sẵn có.
   - Vào Manage Users → quản lý tài khoản.
   - Dùng menu (ShowIconOptions) để logout hoặc đi đến các màn cấu hình.

Chỉ cần làm đúng các bước trong file **GUIDELINE.md** này, bạn sẽ chạy được app với broker HiveMQ Cloud riêng nhưng cùng cấu hình và logic như nhóm dự án đã triển khai.
