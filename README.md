# KiemThu

Project kiểm thử tự động sử dụng Katalon Studio với GitHub Actions Self-Hosted Runner.

## 📚 Hướng Dẫn

### Cho Người Mới Bắt Đầu

1. **Setup Self-Hosted Runner:**
   - Xem file: [`HUONG_DAN_SELF_HOSTED_RUNNER.md`](HUONG_DAN_SELF_HOSTED_RUNNER.md)
   - Hướng dẫn chi tiết từ cài đặt đến chạy tests và xem reports

2. **Cấu Hình Workflow cho Máy Của Bạn:**
   - Xem file: [`HUONG_DAN_CAU_HINH_WORKFLOW.md`](HUONG_DAN_CAU_HINH_WORKFLOW.md)
   - Hướng dẫn cách sửa file workflow để phù hợp với máy tính của bạn

### Các File Hướng Dẫn Khác

- **Schedule Tests:** [`HUONG_DAN_SCHEDULE.md`](HUONG_DAN_SCHEDULE.md) - Hướng dẫn chạy tests theo lịch
- **Setup Katalon:** [`HUONG_DAN_SETUP_KATALON_LAN_DAU.md`](HUONG_DAN_SETUP_KATALON_LAN_DAU.md) - Hướng dẫn cài đặt Katalon Studio lần đầu

## 🚀 Quick Start

1. Clone repository
2. Setup Self-Hosted Runner (xem hướng dẫn trên)
3. Cấu hình workflow cho máy của bạn (xem hướng dẫn trên)
4. Push code và xem kết quả trên GitHub Actions

## 📊 Xem Test Results

Sau khi workflow chạy, xem kết quả tại:
- **GitHub Actions:** https://github.com/duowg29/KiemThu/actions
- **Download Reports:** Trong mỗi workflow run, scroll xuống phần "Artifacts"

## ⚙️ Cấu Hình

- **Workflow File:** `.github/workflows/katalon-tests.yml`
- **Katalon Profile:** `Profiles/default.glbl`
- **Test Suites:** `Test Suites/UI/` và `Test Suites/Functional/`

## 📝 Lưu Ý

- Project này sử dụng **Self-Hosted Runner**, không dùng GitHub-hosted runners
- Cần cài đặt Katalon Studio trên máy runner
- Workflow sẽ tự động chạy khi push code hoặc theo lịch (2:00 AM UTC mỗi ngày)