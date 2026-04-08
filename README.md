# Ứng dụng Vẽ Tranh Đơn Giản

Đề tài 30: Xây dựng ứng dụng vẽ tranh đơn giản bằng Flutter.

## Mô tả

Ứng dụng cho phép người dùng vẽ tự do trên canvas, chọn màu sắc, tuỳ chỉnh nét vẽ, và lưu tranh vào thư viện. Giao diện được xây dựng hoàn toàn bằng tiếng Việt có dấu.

## Công nghệ sử dụng

- **Framework:** Flutter / Dart
- **Kiến trúc:** Cấu trúc thư mục theo mô hình screens / widgets / models / utils

## Cấu trúc thư mục

```
lib/
├── main.dart                          # Điểm vào ứng dụng
├── models/
│   ├── drawing_point.dart             # Model điểm vẽ
│   └── drawing_info.dart              # Model thông tin bức tranh
├── screens/
│   ├── splash_screen.dart             # Màn hình khởi động
│   ├── home_screen.dart               # Màn hình chính
│   ├── drawing_screen.dart            # Màn hình vẽ tranh
│   ├── gallery_screen.dart            # Màn hình thư viện tranh
│   ├── settings_screen.dart           # Màn hình cài đặt
│   └── about_screen.dart              # Màn hình giới thiệu
├── widgets/
│   ├── drawing_canvas.dart            # Widget canvas vẽ (CustomPainter)
│   ├── color_picker_dialog.dart       # Hộp thoại chọn màu
│   └── stroke_width_dialog.dart       # Hộp thoại chọn độ dày nét vẽ
└── utils/
    ├── app_colors.dart                # Bảng màu ứng dụng
    └── app_theme.dart                 # Theme ứng dụng
```

## Các giao diện đã xây dựng

### 1. Màn hình khởi động (Splash Screen)
- Hiển thị logo và tên ứng dụng "Vẽ Tranh"
- Hiệu ứng animation fade-in và scale
- Tự động chuyển sang màn hình chính sau 3 giây

### 2. Màn hình chính (Home Screen)
- Giao diện dạng lưới với 4 mục chính:
  - **Vẽ mới** - Mở canvas vẽ tranh mới
  - **Thư viện** - Xem các bức tranh đã lưu
  - **Cài đặt** - Tuỳ chỉnh ứng dụng
  - **Giới thiệu** - Thông tin ứng dụng
- Header gradient với lời chào

### 3. Màn hình vẽ tranh (Drawing Screen)
- **Vẽ tự do:** Vẽ bằng ngón tay trên canvas trắng
- **Chọn màu sắc:** Bảng chọn 20+ màu sắc (hộp thoại đầy đủ) + 4 màu nhanh trên thanh công cụ
- **Tuỳ chỉnh độ dày nét vẽ:** Thanh trượt từ 1-30px với 6 preset nhanh và xem trước
- **Công cụ tẩy:** Tẩy xoá các chi tiết đã vẽ
- **Hoàn tác (Undo):** Quay lại thao tác trước
- **Làm lại (Redo):** Khôi phục thao tác đã hoàn tác
- **Xoá tất cả:** Xoá toàn bộ bản vẽ (có xác nhận)
- **Lưu tranh:** Đặt tên và lưu bức tranh (có hộp thoại nhập tên)
- **Xác nhận thoát:** Hỏi lưu trước khi thoát nếu đang có bản vẽ

### 4. Màn hình thư viện tranh (Gallery Screen)
- Hiển thị danh sách tranh dạng lưới 2 cột
- Mỗi bức tranh hiển thị: ảnh thu nhỏ, tên, ngày tạo
- **Chỉnh sửa:** Mở bức tranh để tiếp tục vẽ
- **Chia sẻ:** Chia sẻ tranh với bạn bè
- **Đổi tên:** Thay đổi tên bức tranh
- **Xoá:** Xoá bức tranh (có xác nhận)
- **Sắp xếp:** Sắp xếp theo tên hoặc ngày tạo
- Hiển thị trạng thái trống khi chưa có tranh
- Nút tạo bản vẽ mới (FAB)

### 5. Màn hình cài đặt (Settings Screen)
- **Cài đặt chung:**
  - Chế độ tối (bật/tắt)
  - Tự động lưu (bật/tắt)
- **Cài đặt vẽ:**
  - Hiển thị lưới hỗ trợ
  - Độ dày nét vẽ mặc định
  - Loại bút mặc định (Bút tròn, Bút vuông, Bút thư pháp, Bút highlight)
  - Kích thước canvas (Tự do, 1:1, 4:3, 3:4, 16:9)
- **Lưu trữ:**
  - Thư mục lưu trữ
  - Định dạng ảnh (PNG, JPEG, WEBP)
  - Xoá bộ nhớ đệm

### 6. Màn hình giới thiệu (About Screen)
- Logo và tên ứng dụng
- Phiên bản ứng dụng
- Mô tả ứng dụng
- Danh sách 7 tính năng chính
- Thông tin đồ án (đề tài, môn học, công nghệ, năm)

## Điều hướng giữa các giao diện

| Từ              | Đến             | Phương thức          |
|-----------------|-----------------|----------------------|
| Splash Screen   | Home Screen     | Tự động (3 giây)     |
| Home Screen     | Drawing Screen  | Nhấn "Vẽ mới"        |
| Home Screen     | Gallery Screen  | Nhấn "Thư viện"      |
| Home Screen     | Settings Screen | Nhấn "Cài đặt"       |
| Home Screen     | About Screen    | Nhấn "Giới thiệu"    |
| Gallery Screen  | Drawing Screen  | Nhấn "Vẽ mới" / Chỉnh sửa |
| Drawing Screen  | Home Screen     | Nút quay lại (có xác nhận) |

## Cách chạy ứng dụng

```bash
# Cài đặt dependencies
flutter pub get

# Chạy ứng dụng
flutter run
```

## Yêu cầu hệ thống

- Flutter SDK >= 3.0
- Dart SDK >= 3.0
- Android SDK / iOS SDK (tuỳ nền tảng)
