# Hướng Dẫn Chi Tiết Từng Bước - GitHub Actions CI/CD cho Katalon Studio

## 🎯 Mục Tiêu
Thiết lập CI/CD tự động chạy Katalon Studio tests mỗi khi push code lên GitHub.

---

## 📋 Có 2 Cách - Chọn 1 Cách Phù Hợp:

### **Cách 1: Dùng KRE (Katalon Runtime Engine)** ⭐ KHUYẾN NGHỊ
- ✅ Dễ setup nhất
- ✅ Không cần máy riêng
- ✅ Chạy trên GitHub servers
- ❌ Cần tải KRE mỗi lần chạy (mất thời gian)

### **Cách 2: Dùng Self-Hosted Runner**
- ✅ Nhanh hơn (không cần tải KRE)
- ✅ Có thể dùng Katalon Studio đầy đủ
- ❌ Cần máy Windows chạy 24/7 hoặc khi cần
- ❌ Cần setup phức tạp hơn

---

# 🚀 CÁCH 1: DÙNG KRE (KHUYẾN NGHỊ CHO NGƯỜI MỚI BẮT ĐẦU)

## Bước 1: Kiểm tra file workflow đã có chưa

1. Mở terminal/command prompt trong thư mục project của bạn
2. Kiểm tra xem đã có file `.github/workflows/katalon-tests-kre.yml` chưa:
   ```bash
   dir .github\workflows
   ```
   Hoặc mở File Explorer và vào thư mục `.github\workflows`

3. Nếu chưa có, file đã được tạo sẵn rồi. Nếu có rồi, tiếp tục bước 2.

## Bước 2: Kiểm tra và sửa test suite (nếu cần)

1. Mở file `.github/workflows/katalon-tests-kre.yml` bằng text editor (VS Code, Notepad++, etc.)

2. Tìm dòng này (khoảng dòng 59):
   ```yaml
   -testSuitePath="Test Suites/Functional/Login Testcases"
   ```

3. Nếu bạn muốn chạy test suite khác, sửa thành:
   ```yaml
   -testSuitePath="Test Suites/UI Testing"
   ```
   Hoặc bất kỳ test suite nào bạn muốn.

4. **Lưu file** (Ctrl+S)

## Bước 3: Commit và push lên GitHub

1. Mở terminal trong thư mục project:
   ```bash
   cd "F:\BAV\Năm 4\Kì 1\KTVDBCLPM\KiemThu"
   ```

2. Kiểm tra trạng thái git:
   ```bash
   git status
   ```

3. Thêm các file mới:
   ```bash
   git add .github/
   git add HUONG_DAN_GITHUB_ACTIONS.md
   git add HUONG_DAN_CHI_TIET_GITHUB_ACTIONS.md
   ```

4. Commit:
   ```bash
   git commit -m "Add GitHub Actions CI/CD workflow with KRE"
   ```

5. Push lên GitHub:
   ```bash
   git push origin main
   ```
   (Nếu branch của bạn là `master` thì dùng `git push origin master`)

## Bước 4: Kiểm tra workflow trên GitHub

1. Mở trình duyệt, vào repository trên GitHub:
   ```
   https://github.com/duowg29/KiemThu
   ```

2. Click vào tab **"Actions"** (ở thanh menu trên cùng)

3. Bạn sẽ thấy workflow "Katalon Tests with KRE" đang chạy hoặc đã chạy xong

4. Click vào workflow run mới nhất để xem chi tiết:
   - Xem logs từng bước
   - Xem kết quả test
   - Download test reports (nếu có)

## Bước 5: Chạy thủ công (nếu muốn test ngay)

1. Vào tab **Actions** trên GitHub
2. Ở sidebar bên trái, click **"Katalon Tests with KRE"**
3. Click nút **"Run workflow"** (góc phải trên)
4. Chọn branch (thường là `main`)
5. Click **"Run workflow"**
6. Đợi workflow chạy xong (có thể mất 5-15 phút)

---

# 🖥️ CÁCH 2: DÙNG SELF-HOSTED RUNNER (Nếu bạn có máy Windows riêng)

## Bước 1: Cài đặt Katalon Studio trên máy Windows của bạn

1. Tải Katalon Studio:
   - Vào: https://www.katalon.com/download/
   - Tải phiên bản mới nhất
   - Cài đặt như bình thường

2. Ghi nhớ đường dẫn cài đặt:
   - Thường là: `C:\Program Files\Katalon\Katalon Studio`
   - Hoặc: `C:\Users\<TênUser>\.katalon\packages\KSE-10.4.2`
   - Mở File Explorer và tìm file `katalon.exe` để xác nhận đường dẫn

## Bước 2: Setup Self-Hosted Runner trên GitHub

### 2.1. Lấy token từ GitHub

1. Vào repository trên GitHub: https://github.com/duowg29/KiemThu
2. Click **Settings** (tab trên cùng)
3. Ở sidebar bên trái, click **Actions** → **Runners**
4. Click nút **"New self-hosted runner"** (góc phải trên)
5. Chọn **"x64"** trong dropdown Architecture
6. **Copy token** (dòng dài có chữ và số, ví dụ: `BDOIHLSJZIVAUBLQ3A6V05DJHU4LS`)
   - ⚠️ **LƯU Ý:** Token này chỉ dùng được 1 lần và có thời hạn ngắn. Nếu hết hạn, tạo token mới.

### 2.2. Download và cài đặt runner trên máy Windows

1. Mở **PowerShell** hoặc **Command Prompt** với quyền Administrator

2. Tạo thư mục cho runner (khuyến nghị):
   ```powershell
   cd C:\
   mkdir actions-runner
   cd actions-runner
   ```

3. Download runner (copy lệnh từ GitHub, ví dụ):
   ```powershell
   Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.329.0/actions-runner-win-x64-2.329.0.zip -OutFile actions-runner-win-x64-2.329.0.zip
   ```
   ⚠️ **Lưu ý:** Version có thể khác, copy đúng lệnh từ trang GitHub của bạn.

4. Giải nén:
   ```powershell
   Add-Type -AssemblyName System.IO.Compression.FileSystem
   [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.329.0.zip", "$PWD")
   ```

5. Xóa file zip (tùy chọn):
   ```powershell
   Remove-Item actions-runner-win-x64-2.329.0.zip
   ```

### 2.3. Cấu hình runner

1. Chạy lệnh config (thay `YOUR_TOKEN` bằng token bạn đã copy):
   ```powershell
   .\config.cmd --url https://github.com/duowg29/KiemThu --token YOUR_TOKEN
   ```

2. Trả lời các câu hỏi:
   - **Enter the name of the runner:** Nhấn Enter để dùng tên mặc định, hoặc đặt tên (ví dụ: `my-windows-runner`)
   - **Enter the name of the work folder:** Nhấn Enter để dùng mặc định
   - **Enter additional labels:** Nhấn Enter (không cần)
   - **Enter name of the runner as an environment variable:** Nhấn Enter

3. Sau khi config xong, bạn sẽ thấy thông báo thành công.

### 2.4. Chạy runner

1. Chạy lệnh:
   ```powershell
   .\run.cmd
   ```

2. Runner sẽ kết nối với GitHub và sẵn sàng nhận jobs.

3. **Lưu ý:** Cửa sổ PowerShell này phải mở để runner hoạt động. Nếu đóng, runner sẽ ngừng.

### 2.5. (Tùy chọn) Cài runner như Windows Service

Để runner chạy tự động khi khởi động máy:

1. Dừng runner hiện tại (Ctrl+C trong PowerShell)

2. Cài đặt service:
   ```powershell
   .\svc.cmd install
   ```

3. Khởi động service:
   ```powershell
   .\svc.cmd start
   ```

4. Kiểm tra status:
   ```powershell
   .\svc.cmd status
   ```

## Bước 3: Sửa file workflow để dùng self-hosted runner

1. Mở file `.github/workflows/katalon-tests.yml`

2. Tìm dòng này (khoảng dòng 13):
   ```yaml
   runs-on: windows-latest
   ```

3. Sửa thành:
   ```yaml
   runs-on: self-hosted
   ```

4. Tìm phần cấu hình đường dẫn Katalon (khoảng dòng 44):
   ```yaml
   $KATALON_HOME = "$env:ProgramFiles\Katalon\Katalon Studio"
   ```

5. Sửa đường dẫn cho đúng với máy của bạn:
   - Nếu cài trong Program Files: giữ nguyên
   - Nếu cài trong user directory:
     ```yaml
     $KATALON_HOME = "$env:USERPROFILE\.katalon\packages\KSE-10.4.2"
     ```
   - Nếu cài ở nơi khác:
     ```yaml
     $KATALON_HOME = "C:\Path\To\Katalon\Studio"
     ```

6. **Lưu file**

## Bước 4: Commit và push

1. Commit thay đổi:
   ```bash
   git add .github/workflows/katalon-tests.yml
   git commit -m "Configure workflow to use self-hosted runner"
   git push origin main
   ```

## Bước 5: Kiểm tra trên GitHub

1. Vào tab **Actions** trên GitHub
2. Workflow sẽ tự động chạy khi bạn push code
3. Bạn sẽ thấy runner của bạn (tên bạn đã đặt) xuất hiện trong danh sách runners

---

# 🔧 TÙY CHỈNH WORKFLOW

## Thay đổi Test Suite

Mở file workflow (`.github/workflows/katalon-tests-kre.yml` hoặc `katalon-tests.yml`), tìm dòng:
```yaml
-testSuitePath="Test Suites/Functional/Login Testcases"
```

Sửa thành test suite bạn muốn:
```yaml
-testSuitePath="Test Suites/UI Testing"
```

## Thay đổi Browser

Tìm dòng:
```yaml
-browserType="Chrome (headless)"
```

Có thể đổi thành:
- `"Chrome (headless)"` - Chrome không UI (khuyến nghị)
- `"Firefox (headless)"` - Firefox không UI
- `"Chrome"` - Chrome có UI (không khuyến nghị trên CI)

## Thay đổi Timeout

Tìm dòng:
```yaml
timeout-minutes: 30
```

Sửa thành số phút bạn muốn (ví dụ: `60` cho 1 giờ).

## Thêm Environment Variables

Nếu test của bạn cần biến môi trường, thêm vào step "Run Katalon Tests":
```yaml
- name: Run Katalon Tests
  env:
    JAVA_OPTS: '...'
    MY_CUSTOM_VAR: "value"
    ANOTHER_VAR: "another_value"
  run: |
    # ...
```

---

# 🐛 XỬ LÝ LỖI THƯỜNG GẶP

## Lỗi: "KRE not found" hoặc "Katalon Studio not found"

**Nguyên nhân:** Đường dẫn không đúng hoặc chưa cài đặt.

**Giải pháp:**
1. Kiểm tra đường dẫn trong workflow file
2. Đảm bảo Katalon Studio/KRE đã được cài đặt đúng
3. Với self-hosted runner: kiểm tra đường dẫn trên máy runner

## Lỗi: "WebView server has been started"

**Nguyên nhân:** WebView server vẫn khởi động.

**Giải pháp:**
- Các JVM options đã được thêm vào workflow để tắt WebView
- Nếu vẫn gặp, có thể do version Katalon. Thử update version.

## Lỗi: "Chrome not found"

**Nguyên nhân:** Chrome chưa được cài trên runner.

**Giải pháp:**
- GitHub-hosted runners có Chrome sẵn
- Với self-hosted runner: cài Chrome hoặc dùng headless mode

## Lỗi: Timeout

**Nguyên nhân:** Tests chạy quá lâu.

**Giải pháp:**
- Tăng `timeout-minutes` trong workflow
- Kiểm tra tests có bị treo không

## Lỗi: "Runner is offline"

**Nguyên nhân:** Self-hosted runner không chạy.

**Giải pháp:**
1. Kiểm tra runner có đang chạy không (PowerShell window mở)
2. Nếu dùng service: kiểm tra service status
3. Restart runner nếu cần

---

# 📊 XEM KẾT QUẢ

## Xem Logs

1. Vào tab **Actions** trên GitHub
2. Click vào workflow run
3. Click vào job "Run Katalon Tests"
4. Xem logs từng step

## Download Test Reports

1. Ở cuối workflow run, phần **Artifacts**
2. Click **"test-reports"** để download
3. Giải nén và xem reports

## Xem Test Results

- Logs sẽ hiển thị kết quả test
- Nếu có HTML reports, download từ Artifacts

---

# ✅ CHECKLIST

## Cho Cách 1 (KRE):
- [ ] File `.github/workflows/katalon-tests-kre.yml` đã có
- [ ] Đã sửa test suite (nếu cần)
- [ ] Đã commit và push lên GitHub
- [ ] Đã kiểm tra workflow chạy trên GitHub Actions tab
- [ ] Đã xem kết quả và logs

## Cho Cách 2 (Self-hosted):
- [ ] Đã cài Katalon Studio trên máy Windows
- [ ] Đã ghi nhớ đường dẫn cài đặt
- [ ] Đã download và cài đặt GitHub Actions runner
- [ ] Đã config runner với token từ GitHub
- [ ] Runner đang chạy (PowerShell window mở hoặc service running)
- [ ] Đã sửa workflow file (`runs-on: self-hosted`)
- [ ] Đã sửa đường dẫn Katalon trong workflow
- [ ] Đã commit và push
- [ ] Đã kiểm tra workflow chạy trên GitHub

---

# 🎉 HOÀN THÀNH!

Sau khi setup xong, mỗi khi bạn:
- **Push code** lên branch `main` hoặc `master`
- **Tạo Pull Request**
- **Chạy thủ công** từ tab Actions

Workflow sẽ tự động chạy tests và bạn có thể xem kết quả trên GitHub!

---

# 📚 TÀI LIỆU THAM KHẢO

- GitHub Actions Docs: https://docs.github.com/en/actions
- Self-hosted Runners: https://docs.github.com/en/actions/hosting-your-own-runners
- Katalon Runtime Engine: https://docs.katalon.com/katalon-runtime-engine/docs/overview.html
- Katalon Console Mode: https://docs.katalon.com/katalon-studio/docs/console-mode-execution.html

---

**Nếu gặp vấn đề, kiểm tra:**
1. Logs trong GitHub Actions tab
2. Runner status (nếu dùng self-hosted)
3. Đường dẫn Katalon Studio
4. Test suite path có đúng không

**Chúc bạn thành công! 🚀**

