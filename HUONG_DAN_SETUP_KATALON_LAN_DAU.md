# Hướng Dẫn Setup Katalon Studio Lần Đầu

## Vấn Đề
Nếu bạn vừa mới tải Katalon Studio và mở project lần đầu, project cần được **build/compile** trước khi có thể chạy từ command line hoặc CI/CD.

## Các Bước Cần Làm

### Bước 1: Mở Project trong Katalon Studio
1. Mở Katalon Studio
2. File → Open Project → Chọn thư mục project của bạn

### Bước 2: Chạy Test Từ GUI Lần Đầu (QUAN TRỌNG!)
**Bước này rất quan trọng** - Katalon cần compile project và setup môi trường lần đầu:

1. Trong Katalon Studio, mở **Test Suites** → **UI** → **Login Testcases**
2. Click nút **Run** (hoặc nhấn F5)
3. Chọn:
   - **Execution Profile**: `default`
   - **Browser**: `Chrome (headless)` hoặc `Chrome`
4. Đợi test chạy xong (có thể mất vài phút lần đầu)

**Tại sao cần làm bước này?**
- Katalon sẽ compile project (build)
- Download dependencies nếu cần
- Tạo các file cấu hình cần thiết
- Setup môi trường chạy test

### Bước 3: Kiểm Tra Project Đã Được Build
Sau khi chạy test từ GUI thành công, kiểm tra:
- Thư mục `build` đã được tạo trong project
- Có file `.classpath` và `.project` trong project root
- Không có lỗi compile trong Problems panel

### Bước 4: Chạy Lại CI/CD
Sau khi đã chạy test từ GUI thành công ít nhất 1 lần, bạn có thể chạy lại GitHub Actions workflow.

## Lưu Ý
- **Phải chạy test từ GUI ít nhất 1 lần** trước khi chạy từ command line
- Nếu test fail trong GUI, cần fix lỗi trước khi chạy CI/CD
- Đảm bảo Chrome/ChromeDriver đã được cài đặt trên máy runner

## Troubleshooting

### Nếu test không chạy được trong GUI:
1. Kiểm tra Chrome đã được cài đặt chưa
2. Kiểm tra test cases có lỗi syntax không (xem Problems panel)
3. Kiểm tra Object Repository có đúng không
4. Kiểm tra Test Data có đúng không

### Nếu vẫn không chạy được sau khi setup:
1. Thử chạy lại test từ GUI
2. Kiểm tra logs trong Katalon Studio (Window → Show View → Log Viewer)
3. Đảm bảo project đã được build thành công (xem thư mục `build`)

