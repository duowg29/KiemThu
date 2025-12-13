# Hướng Dẫn Sau Khi Setup Thành Công 🎉

## ✅ Bạn Đã Hoàn Thành!

Workflow GitHub Actions đã chạy thành công! Bây giờ bạn có thể:

---

## 📊 Xem Kết Quả Test

### 1. Xem trên GitHub Actions

1. **Vào tab Actions:**
   - https://github.com/duowg29/KiemThu/actions

2. **Click vào workflow run mới nhất** (màu xanh ✅)

3. **Xem chi tiết:**
   - Click vào job "Run Katalon Studio Tests"
   - Xem logs từng step
   - Kiểm tra kết quả test

### 2. Download Test Reports

1. **Trong workflow run, scroll xuống phần "Artifacts"**

2. **Click "test-reports"** để download

3. **Giải nén file** và xem:
   - HTML reports
   - Screenshots (nếu có)
   - Logs chi tiết

---

## 🔧 Tùy Chỉnh Workflow

### Thay Đổi Test Suite

1. **Mở file:** `.github/workflows/katalon-tests.yml`

2. **Tìm dòng (khoảng dòng 60):**
   ```yaml
   -testSuitePath="Test Suites/Functional/Account Management Testcases"
   ```

3. **Sửa thành test suite bạn muốn:**
   ```yaml
   -testSuitePath="Test Suites/UI Testing"
   # Hoặc
   -testSuitePath="Test Suites/Functional/Login Testcases"
   ```

4. **Commit và push:**
   ```bash
   git add .github/workflows/katalon-tests.yml
   git commit -m "Change test suite to UI Testing"
   git push
   ```

### Thay Đổi Browser

Tìm dòng:
```yaml
-browserType="Chrome (headless)"
```

Có thể đổi thành:
- `"Firefox (headless)"` - Firefox headless
- `"Chrome"` - Chrome có UI (không khuyến nghị trên CI)
- `"Edge (headless)"` - Edge headless

### Thay Đổi Schedule (Lịch Chạy)

Tìm phần `schedule:` (khoảng dòng 9-13):
```yaml
schedule:
  - cron: '0 2 * * *'  # 2:00 AM UTC = 9:00 AM giờ Việt Nam
```

Có thể thay đổi:
- `'0 9 * * *'` - 9:00 AM UTC = 4:00 PM giờ Việt Nam
- `'0 14 * * 1-5'` - Chỉ thứ 2 đến thứ 6
- `'0 */6 * * *'` - Mỗi 6 giờ một lần

Xem thêm trong file `HUONG_DAN_SCHEDULE.md`

### Thay Đổi Timeout

Tìm dòng:
```yaml
timeout-minutes: 30
```

Tăng nếu tests chạy lâu hơn:
```yaml
timeout-minutes: 60  # 1 giờ
```

---

## 🚀 Workflow Sẽ Tự Động Chạy Khi:

1. **Push code** lên branch `main` hoặc `master`
2. **Tạo Pull Request** vào branch `main` hoặc `master`
3. **Theo lịch** (schedule) - mỗi ngày lúc 9:00 AM giờ Việt Nam
4. **Chạy thủ công** - vào Actions tab → chọn workflow → "Run workflow"

---

## 💡 Tips Sử Dụng Hiệu Quả

### 1. Chạy Test Thủ Công

Khi cần test ngay mà không muốn push code:

1. Vào tab **Actions** trên GitHub
2. Click vào workflow "Katalon Tests CI/CD"
3. Click nút **"Run workflow"** (góc phải trên)
4. Chọn branch và click **"Run workflow"**

### 2. Xem Lịch Sử Chạy

- Vào tab **Actions**
- Xem tất cả các lần chạy
- So sánh kết quả giữa các lần chạy

### 3. Nhận Thông Báo

GitHub sẽ tự động gửi email khi:
- Workflow chạy xong (thành công hoặc thất bại)
- Có thể bật/tắt trong Settings → Notifications

### 4. Chạy Nhiều Test Suites

Nếu muốn chạy nhiều test suites, có thể:

**Cách 1: Tạo nhiều jobs**
```yaml
jobs:
  run-login-tests:
    # ... chạy Login Testcases
  
  run-ui-tests:
    # ... chạy UI Testing
```

**Cách 2: Chạy tuần tự trong 1 job**
Thêm nhiều steps chạy Katalon với test suites khác nhau

---

## 🔄 Duy Trì Runner

### Runner Phải Luôn Chạy

Để workflow hoạt động, runner phải:
- ✅ **Đang chạy** (`.\run.cmd` đang mở)
- ✅ **Online** (hiển thị trên GitHub)

### Kiểm Tra Runner Status

1. **Trên GitHub:**
   - Settings → Actions → Runners
   - Xem runner có "Online" không

2. **Trên máy:**
   - Kiểm tra cửa sổ PowerShell có đang chạy `.\run.cmd` không
   - Hoặc kiểm tra service: `.\svc.cmd status`

### Nếu Runner Offline

1. **Mở PowerShell**
2. **Vào thư mục runner:**
   ```powershell
   cd E:\actions-runner
   ```
3. **Chạy lại:**
   ```powershell
   .\run.cmd
   ```

---

## 📋 Checklist Hoàn Thành

- [x] ✅ Runner đã setup và đang chạy
- [x] ✅ Workflow đã chạy thành công
- [ ] Đã xem kết quả test trên GitHub
- [ ] Đã download test reports
- [ ] Đã tùy chỉnh test suite (nếu cần)
- [ ] Đã hiểu cách workflow tự động chạy
- [ ] Đã biết cách chạy thủ công

---

## 🎯 Các Bước Tiếp Theo (Tùy Chọn)

### 1. Tối Ưu Workflow

- Thêm caching để tăng tốc
- Chạy tests song song
- Thêm notifications (Slack, email, etc.)

### 2. Tích Hợp Với Các Tool Khác

- Jira integration
- Test reporting tools
- Code coverage

### 3. Mở Rộng

- Chạy tests trên nhiều browsers
- Chạy tests trên nhiều environments
- Parallel execution

---

## 📚 Tài Liệu Tham Khảo

- **GitHub Actions Docs:** https://docs.github.com/en/actions
- **Katalon Studio:** https://docs.katalon.com/katalon-studio/docs/console-mode-execution.html
- **Self-hosted Runners:** https://docs.github.com/en/actions/hosting-your-own-runners

---

## 🎉 Chúc Mừng!

Bạn đã setup thành công CI/CD với GitHub Actions! 

Workflow sẽ tự động chạy tests mỗi khi bạn push code, giúp bạn:
- ✅ Phát hiện lỗi sớm
- ✅ Đảm bảo chất lượng code
- ✅ Tự động hóa testing process

**Nếu có câu hỏi hoặc cần hỗ trợ, đừng ngần ngại hỏi! 🚀**

