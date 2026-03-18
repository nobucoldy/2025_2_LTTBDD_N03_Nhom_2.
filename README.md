# Nhóm 2- Lập trình cho thiết bị di động
- Nguyễn Quế Bắc (23010574)
- Hoàng Tuần Kiệt (23010517)

## 🚀 Ứng dụng quản lý kế hoạch

Ứng dụng quản lý kế hoạch đa cấp (Plan - Phase - Task) được phát triển bằng **Flutter**. 

---

## 📌 Tổng quan dự án
Ứng dụng giúp người dùng lập kế hoạch chi tiết cho các mục tiêu dài hạn, chia nhỏ thành các giai đoạn (Phases) và các nhiệm vụ cụ thể (Tasks). Hỗ trợ theo dõi tiến độ trực quan thông qua biểu đồ và giao diện hiện đại.

## ✨ Tính năng chính
- **Quản lý đa cấp:** Cấu trúc kế hoạch lồng nhau (Plan > Phase > Task).
- **Dashboard thông minh:** Trực quan hóa tiến độ bằng biểu đồ tròn và cột (sử dụng `fl_chart`).
- **Tương tác hiện đại:** Thao tác vuốt (Slidable) để xóa/hoàn thành nhanh.
- **Chỉnh sửa trực tiếp:** Inline editing ngay tại màn hình chi tiết.
- **Cá nhân hóa:** Hỗ trợ **Dark Mode** và đa ngôn ngữ (**Tiếng Anh / Tiếng Việt**).

## 🛠 Công nghệ sử dụng
- **Framework:** [Flutter](https://flutter.dev/) (v3.x)
- **Language:** [Dart](https://dart.dev/)
- **Libraries:**
  - `fl_chart`: Biểu đồ thống kê.
  - `flutter_slidable`: Tương tác vuốt danh sách.
  - `qr_flutter`: Tạo mã QR.
  - `fluttertoast`: Thông báo phản hồi người dùng.

## 📦 Hướng dẫn cài đặt

Để chạy dự án này trên máy cục bộ, vui lòng làm theo các bước sau:

1. **Clone dự án:**
   ```bash
   git clone [https://github.com/nobucoldy/2025_2_LTTBDD_N03_Nhom_2]

2. **Cài đặt thư viện:**
   ```bash
   flutter pub get

3. **Chạy ứng dụng:**
   ```bash
   flutter run
