# Hướng Dẫn Hoàn Chỉnh: Self-Hosted Runner cho GitHub Actions với Katalon Studio

## 📋 Mục Lục

1. [Tổng Quan](#tổng-quan)
2. [Yêu Cầu Hệ Thống](#yêu-cầu-hệ-thống)
3. [Bước 1: Cài Đặt Katalon Studio](#bước-1-cài-đặt-katalon-studio)
4. [Bước 2: Setup Self-Hosted Runner](#bước-2-setup-self-hosted-runner)
5. [Bước 3: Cấu Hình Workflow](#bước-3-cấu-hình-workflow)
6. [Bước 4: Chạy Workflow và Xem Kết Quả](#bước-4-chạy-workflow-và-xem-kết-quả)
7. [Bước 5: Xem và Download Test Reports](#bước-5-xem-và-download-test-reports)
8. [Troubleshooting](#troubleshooting)
9. [Các Tính Năng Nâng Cao](#các-tính-năng-nâng-cao)

---

## 🎯 Tổng Quan

Self-Hosted Runner cho phép bạn chạy GitHub Actions workflows trên máy tính của chính bạn, giúp:
- ✅ Chạy Katalon Studio tests trên môi trường local
- ✅ Không cần Katalon Runtime Engine (KRE)
- ✅ Kiểm soát hoàn toàn môi trường test
- ✅ Xem reports trực tiếp trên GitHub Actions
- ✅ Tự động chạy tests khi push code hoặc theo lịch

### Workflow Hiện Tại

File workflow: `.github/workflows/katalon-tests.yml`

**Triggers:**
- ✅ Push code lên `main` hoặc `master`
- ✅ Tạo Pull Request
- ✅ Chạy thủ công (workflow_dispatch)
- ✅ Chạy theo lịch: Mỗi ngày lúc 2:00 AM UTC (9:00 AM giờ Việt Nam)

---

## 💻 Yêu Cầu Hệ Thống

### Phần Mềm Cần Thiết:
- ✅ **Windows 10/11** (64-bit)
- ✅ **Katalon Studio** (phiên bản 10.4.2 hoặc mới hơn)
- ✅ **Java** (thường đi kèm với Katalon)
- ✅ **Chrome Browser** (cho headless testing)
- ✅ **Git** (để clone repository)
- ✅ **PowerShell** (đã có sẵn trên Windows)

### Yêu Cầu Khác:
- ✅ **Kết nối Internet** ổn định
- ✅ **GitHub Account** với quyền truy cập repository
- ✅ **Dung lượng ổ đĩa:** Tối thiểu 5GB trống

---

## 📥 Bước 1: Cài Đặt Katalon Studio

### 1.1. Download Katalon Studio

1. Truy cập: https://www.katalon.com/download/
2. Chọn **"Katalon Studio"** (không phải KRE)
3. Download file `.exe` cho Windows
4. Chạy file installer và làm theo hướng dẫn

### 1.2. Cài Đặt và Kích Hoạt

1. **Mở Katalon Studio** lần đầu
2. **Đăng nhập** với tài khoản Katalon (hoặc tạo tài khoản mới)
3. **Kích hoạt trial** hoặc license nếu có
4. **Mở project** của bạn (clone từ GitHub nếu chưa có)

### 1.3. Xác Nhận Đường Dẫn Cài Đặt

Katalon Studio thường được cài ở một trong các vị trí sau:

- `C:\Users\<TênUser>\.katalon\packages\KSE-10.4.2\` (phổ biến nhất)
- `C:\Program Files\Katalon\Katalon Studio\`

**Kiểm tra đường dẫn:**

**Cách 1: Tìm qua File Explorer**
1. Mở **File Explorer** (Windows + E)
2. Tìm file `katalon.exe` hoặc `katalonc.exe`
3. Copy đường dẫn đầy đủ (không bao gồm `katalon.exe`)

**Cách 2: Tìm qua PowerShell**
```powershell
# Tìm trong user directory
Get-ChildItem -Path $env:USERPROFILE -Filter katalon.exe -Recurse -ErrorAction SilentlyContinue | Select-Object FullName

# Hoặc tìm trong toàn bộ ổ C
Get-ChildItem -Path C:\ -Filter katalon.exe -Recurse -ErrorAction SilentlyContinue | Select-Object FullName
```

**Ví dụ kết quả:**
```
C:\Users\feu29\.katalon\packages\KSE-10.4.2\katalon.exe
```

Đường dẫn bạn cần: `C:\Users\feu29\.katalon\packages\KSE-10.4.2`

**Lưu lại đường dẫn này** - bạn sẽ cần nó ở bước 3!

---

## 🚀 Bước 2: Setup Self-Hosted Runner

### 2.1. Chọn Vị Trí Cài Đặt Runner

**Bạn có thể cài runner ở BẤT KỲ Ổ ĐĨA NÀO:**
- ✅ Ổ C: `C:\actions-runner`
- ✅ Ổ E: `E:\actions-runner` ⭐ (Khuyến nghị nếu ổ E có nhiều dung lượng)
- ✅ Ổ D: `D:\actions-runner`
- ✅ Bất kỳ thư mục nào khác

**Ví dụ:** Chúng ta sẽ dùng ổ E trong hướng dẫn này.

### 2.2. Mở PowerShell

1. Nhấn `Windows + X`
2. Chọn **"Windows PowerShell"** hoặc **"Terminal"**
3. Hoặc tìm "PowerShell" trong Start Menu

### 2.3. Tạo Thư Mục và Download Runner

```powershell
# Chuyển sang ổ E (hoặc ổ bạn muốn)
E:

# Tạo thư mục actions-runner
mkdir actions-runner

# Vào thư mục vừa tạo
cd actions-runner

# Download GitHub Actions Runner
# Thay v2.329.0 bằng phiên bản mới nhất nếu cần
Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.329.0/actions-runner-win-x64-2.329.0.zip -OutFile actions-runner-win-x64-2.329.0.zip
```

### 2.4. Giải Nén File

```powershell
# Giải nén file zip
Expand-Archive -Path actions-runner-win-x64-2.329.0.zip -DestinationPath .

# Xóa file zip (tùy chọn)
Remove-Item actions-runner-win-x64-2.329.0.zip
```

### 2.5. Lấy Token Từ GitHub

1. **Vào repository trên GitHub:**
   - https://github.com/duowg29/KiemThu

2. **Vào Settings:**
   - Click tab **"Settings"** (ở trên cùng)
   - Scroll xuống phần **"Actions"** (bên trái)
   - Click **"Runners"**

3. **Tạo Runner mới:**
   - Click nút **"New self-hosted runner"**
   - Chọn **"Windows"**
   - Copy **token** được hiển thị (dạng: `AXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`)

### 2.6. Cấu Hình Runner

```powershell
# Chạy lệnh config (thay YOUR_TOKEN bằng token bạn vừa copy)
.\config.cmd --url https://github.com/duowg29/KiemThu --token YOUR_TOKEN
```

**Khi được hỏi:**
- **Runner name:** Nhấn Enter để dùng tên mặc định, hoặc đặt tên tùy chỉnh (ví dụ: `my-windows-runner`)
- **Labels:** Nhấn Enter để bỏ qua
- **Work folder:** Nhấn Enter để dùng mặc định

**Kết quả:** Bạn sẽ thấy dòng "√ Runner successfully added"

### 2.7. Chạy Runner

```powershell
# Chạy runner
.\run.cmd
```

**Lưu ý:** 
- Runner sẽ chạy và chờ jobs từ GitHub Actions
- **Giữ cửa sổ PowerShell này mở** - đây là runner đang chạy
- Để dừng runner, nhấn `Ctrl + C`

### 2.8. (Tùy Chọn) Chạy Runner Như Windows Service

Nếu muốn runner tự động chạy khi khởi động máy:

```powershell
# Cài đặt như service
.\svc.cmd install

# Khởi động service
.\svc.cmd start

# Xem trạng thái
.\svc.cmd status
```

**Lưu ý:** Nếu lệnh `svc.cmd` không có, bạn có thể tiếp tục dùng `run.cmd` bình thường.

---

## ⚙️ Bước 3: Cấu Hình Workflow

### 3.1. Kiểm Tra File Workflow

File workflow đã được tạo sẵn tại: `.github/workflows/katalon-tests.yml`

### 3.2. Cập Nhật Đường Dẫn Katalon

1. **Mở file:** `.github/workflows/katalon-tests.yml`

2. **Tìm dòng (khoảng dòng 36-44):**
   ```yaml
   run: |
     # Thay đổi đường dẫn này theo đường dẫn Katalon Studio trên runner của bạn
     # Option 1: Nếu cài trong Program Files
     # $KATALON_HOME_ORIGINAL = "$env:ProgramFiles\Katalon\Katalon Studio"
     
     # Option 2: Nếu cài trong user directory (uncomment dòng này và comment dòng trên)
      $KATALON_HOME_ORIGINAL = "$env:USERPROFILE\.katalon\packages\KSE-10.4.2"
     
     # Option 3: Nếu dùng đường dẫn tùy chỉnh (uncomment và sửa)
     # $KATALON_HOME_ORIGINAL = "C:\Path\To\Katalon\Studio"
   ```

3. **Sửa theo đường dẫn Katalon của bạn:**

   **Nếu Katalon ở user directory** (thường gặp nhất):
   - Giữ nguyên dòng 41 nếu đường dẫn đúng
   - Hoặc sửa `KSE-10.4.2` thành phiên bản của bạn (ví dụ: `KSE-10.5.0`)

   **Nếu Katalon ở Program Files:**
   ```yaml
   # Uncomment dòng này:
   $KATALON_HOME_ORIGINAL = "$env:ProgramFiles\Katalon\Katalon Studio"
   
   # Comment dòng 41:
   # $KATALON_HOME_ORIGINAL = "$env:USERPROFILE\.katalon\packages\KSE-10.4.2"
   ```

   **Nếu Katalon ở vị trí khác:**
   ```yaml
   # Uncomment và sửa đường dẫn:
   $KATALON_HOME_ORIGINAL = "C:\Your\Custom\Path\To\Katalon\Studio"
   ```

   **Ví dụ cụ thể:**
   - Nếu Katalon ở: `C:\Users\john\.katalon\packages\KSE-10.4.2`
     → Giữ nguyên: `$KATALON_HOME_ORIGINAL = "$env:USERPROFILE\.katalon\packages\KSE-10.4.2"`
   
   - Nếu Katalon ở: `C:\Program Files\Katalon\Katalon Studio`
     → Sửa thành: `$KATALON_HOME_ORIGINAL = "$env:ProgramFiles\Katalon\Katalon Studio"`
   
   - Nếu Katalon ở: `D:\Tools\Katalon\KSE-10.4.2`
     → Sửa thành: `$KATALON_HOME_ORIGINAL = "D:\Tools\Katalon\KSE-10.4.2"`

### 3.3. Cập Nhật Test Suite (Tùy Chọn)

Nếu bạn muốn chạy test suite khác, tìm dòng **khoảng dòng 107**:

```yaml
$testSuitePath = "Test Suites/UI/Login Testcases"
```

**Sửa thành test suite bạn muốn:**

```yaml
# Ví dụ:
$testSuitePath = "Test Suites/UI/Signup Testcases"
# Hoặc
$testSuitePath = "Test Suites/Functional/Account Management Testcases"
```

**Lưu ý:** 
- Dùng test suite cụ thể (ví dụ: `Login Testcases.ts`)
- Tránh dùng test suite collection (ví dụ: `UI Testing.ts`) vì có thể không chạy được trong console mode

### 3.4. Kiểm Tra Base URL (Tùy Chọn)

Nếu bạn muốn test trên URL khác, có 2 cách:

**Cách 1: Sửa trong Profile (Khuyến nghị)**

1. Mở file: `Profiles/default.glbl`
2. Tìm dòng:
   ```xml
   <value>https://upward-cunning-anteater.ngrok-free.app/CAMNEST/</value>
   ```
3. Sửa thành URL của bạn:
   ```xml
   <value>http://localhost/CAMNEST/</value>
   <!-- Hoặc -->
   <value>https://your-domain.com/CAMNEST/</value>
   ```

**Cách 2: Sửa trong Workflow**

Tìm dòng **khoảng dòng 187**:

```yaml
$baseUrl = "https://upward-cunning-anteater.ngrok-free.app/CAMNEST/"
```

Sửa thành URL của bạn:

```yaml
$baseUrl = "http://localhost/CAMNEST/"
# Hoặc
$baseUrl = "https://your-domain.com/CAMNEST/"
```

**Lưu ý:** URL trong workflow sẽ override URL trong profile.

### 3.5. Kiểm Tra Browser (Tùy Chọn)

Nếu bạn muốn test trên browser khác, tìm dòng **khoảng dòng 230**:

```yaml
-browserType="Chrome (headless)"
```

**Các tùy chọn:**

```yaml
-browserType="Chrome (headless)"        # Chrome headless (khuyến nghị)
-browserType="Firefox (headless)"       # Firefox headless
-browserType="Edge (headless)"          # Edge headless
-browserType="Chrome"                   # Chrome có GUI (không khuyến nghị)
```

### 3.6. Kiểm Tra Execution Profile (Tùy Chọn)

Nếu bạn có profile khác, tìm dòng **khoảng dòng 229**:

```yaml
-executionProfile=default
```

Sửa thành profile của bạn:

```yaml
-executionProfile=production
# Hoặc
-executionProfile=staging
```

**Lưu ý:** Profile phải tồn tại trong thư mục `Profiles/` với tên `profile-name.glbl`.

### 3.7. Commit và Push

```bash
git add .github/workflows/katalon-tests.yml
git commit -m "Configure workflow for my machine"
git push
```

---

## ▶️ Bước 4: Chạy Workflow và Xem Kết Quả

### 4.1. Chạy Workflow Thủ Công

1. **Vào repository trên GitHub:**
   - https://github.com/duowg29/KiemThu

2. **Vào tab Actions:**
   - Click tab **"Actions"** (ở trên cùng)

3. **Chọn workflow:**
   - Click **"Katalon Tests CI/CD"** (bên trái)

4. **Chạy workflow:**
   - Click nút **"Run workflow"** (bên phải)
   - Chọn branch (thường là `main`)
   - Click **"Run workflow"**

### 4.2. Workflow Tự Động Chạy

Workflow sẽ tự động chạy khi:
- ✅ **Push code** lên repository
- ✅ **Tạo Pull Request**
- ✅ **Theo lịch** (đã cấu hình chạy mỗi ngày lúc 2:00 AM UTC = 9:00 AM giờ Việt Nam)

### 4.3. Xem Workflow Đang Chạy

1. **Vào tab Actions:**
   - https://github.com/duowg29/KiemThu/actions

2. **Click vào workflow run mới nhất** (có icon màu vàng 🟡 đang chạy)

3. **Xem chi tiết:**
   - Click vào job **"Run Katalon Studio Tests"**
   - Xem logs từng step:
     - ✅ **Checkout code** - Lấy code từ GitHub
     - 🟡 **Run Katalon Tests** - Đang chạy tests
     - ⏳ **Upload Test Reports and Logs** - Đang upload reports

### 4.4. Xem Logs Chi Tiết

Trong step **"Run Katalon Tests"**, bạn sẽ thấy:
- ✅ Đường dẫn Katalon được tìm thấy
- ✅ Test suite được tìm thấy
- ✅ Số lượng test cases
- ✅ Base URL đang dùng
- ✅ Logs từ Katalon execution
- ✅ Exit code khi hoàn thành

---

## 📊 Bước 5: Xem và Download Test Reports

### 5.1. Xem Reports Trên GitHub Actions

1. **Sau khi workflow hoàn thành:**
   - Vào workflow run (màu xanh ✅ nếu thành công, đỏ ❌ nếu failed)

2. **Scroll xuống phần "Artifacts":**
   - Bạn sẽ thấy **"test-reports"**

3. **Download reports:**
   - Click **"test-reports"**
   - File sẽ được download dạng `.zip`

4. **Giải nén và xem:**
   - Giải nén file `.zip`
   - Mở file `Reports/test-report.html` trong browser
   - Xem các file logs nếu cần

### 5.2. Nội Dung Reports

Trong thư mục `test-reports`, bạn sẽ có:

- **`Reports/test-report.html`** - HTML report chính
- **`Reports/test-report.json`** - JSON report (cho automation)
- **`Reports/test-summary.txt`** - Text summary
- **`katalon-output.txt`** - Logs chi tiết từ Katalon
- **Các file reports khác** (nếu Katalon tạo thêm)

### 5.3. Xem Reports Trực Tiếp Trong Logs

Trong logs của workflow, scroll xuống phần:
```
=== Last 100 lines of Katalon Output ===
```

Bạn sẽ thấy:
- Test execution logs
- Test results (Pass/Fail)
- Screenshots (nếu có)
- Error messages (nếu có lỗi)

---

## 🔧 Troubleshooting

### Lỗi 1: "Katalon Studio not found"

**Triệu chứng:**
```
ERROR: Katalon Studio not found at C:\Users\...
```

**Giải pháp:**
1. Kiểm tra đường dẫn Katalon trong workflow
2. Đảm bảo Katalon đã được cài đặt đúng
3. Sửa đường dẫn trong `.github/workflows/katalon-tests.yml`

**Kiểm tra:**
```powershell
# Test xem Katalon có tồn tại không
Test-Path "C:\Users\YourName\.katalon\packages\KSE-10.4.2\katalon.exe"
```

### Lỗi 2: "Test Suite not found"

**Triệu chứng:**
```
WARNING: Test suite file not found
```

**Giải pháp:**
1. Kiểm tra tên test suite trong workflow
2. Đảm bảo test suite có tồn tại trong project
3. Sửa `$testSuitePath` trong workflow
4. Đảm bảo dùng forward slash `/` thay vì backslash `\`
5. Không cần thêm extension `.ts`

### Lỗi 3: "Package path is too long"

**Triệu chứng:**
```
Execution failed: Package path is too long
```

**Giải pháp:**

**Cách 1: Bật Windows Developer Mode (Khuyến nghị)**
1. Settings → Privacy & Security → For developers
2. Bật **Developer Mode**
3. Restart máy

**Cách 2: Di chuyển Katalon sang đường dẫn ngắn hơn**
1. Copy Katalon từ `C:\Users\...` sang `C:\KS\KSE-10.4.2`
2. Cập nhật đường dẫn trong workflow

### Lỗi 4: "Tests completed too quickly"

**Triệu chứng:**
```
WARNING: Test completed too quickly (0.04 seconds)
```

**Giải pháp:**
1. Kiểm tra test suite có test cases không
2. Kiểm tra Katalon có chạy đúng không (xem logs)
3. Đảm bảo runner đang chạy (`.\run.cmd`)

### Lỗi 5: "No reports found"

**Triệu chứng:**
```
No reports found. Creating new report...
```

**Giải pháp:**
1. Kiểm tra Katalon có chạy đúng không
2. Xem logs để tìm lỗi
3. Đảm bảo `-reportFolder` được set đúng

### Lỗi 6: Katalon mở GUI thay vì chạy console mode

**Triệu chứng:**
- Katalon Studio GUI mở ra
- Tests không chạy

**Giải pháp:**
1. Đảm bảo dùng `katalonc.exe` (console-only version)
2. Kiểm tra `JAVA_OPTS` và `KATALON_OPTS` được set đúng
3. Đảm bảo flags `-runMode=console` và `-console` có trong command

### Lỗi 7: Runner không nhận jobs

**Triệu chứng:**
- Workflow pending mãi không chạy

**Giải pháp:**
1. Kiểm tra runner có đang chạy không (`.\run.cmd`)
2. Kiểm tra runner có online trên GitHub không:
   - Settings → Actions → Runners
   - Xem runner có status "Online" không
3. Restart runner nếu cần

---

## 🚀 Các Tính Năng Nâng Cao

### Chạy Nhiều Test Suites

Để chạy nhiều test suites, tạo nhiều jobs trong workflow:

```yaml
jobs:
  run-login-tests:
    runs-on: self-hosted
    steps:
      - name: Run Login Tests
        run: |
          # Chạy Login Testcases
          
  run-signup-tests:
    runs-on: self-hosted
    steps:
      - name: Run Signup Tests
        run: |
          # Chạy Signup Testcases
```

### Chạy Tests Theo Lịch

Workflow đã được cấu hình chạy mỗi ngày lúc 2:00 AM UTC (9:00 AM giờ Việt Nam).

Để thay đổi lịch, sửa trong `.github/workflows/katalon-tests.yml`:

```yaml
schedule:
  - cron: '0 2 * * *'  # 2:00 AM UTC mỗi ngày
  # - cron: '0 9 * * *'  # 9:00 AM UTC mỗi ngày (4:00 PM giờ Việt Nam)
  # - cron: '0 0 * * *'  # Nửa đêm UTC mỗi ngày (7:00 AM giờ Việt Nam)
  # - cron: '0 14 * * 1-5'  # 2:00 PM UTC từ thứ 2 đến thứ 6 (9:00 PM giờ Việt Nam)
  # - cron: '0 */6 * * *'  # Mỗi 6 giờ một lần
```

### Thay Đổi Browser

Để test trên browser khác, sửa trong workflow:

```yaml
-browserType="Chrome (headless)"
# Hoặc
-browserType="Firefox (headless)"
-browserType="Edge (headless)"
```

### Thêm Environment Variables

Để thêm biến môi trường, sửa trong workflow:

```yaml
env:
  JAVA_OPTS: '...'
  KATALON_OPTS: '...'
  MY_CUSTOM_VAR: 'my-value'
```

### Chạy Tests Song Song

Để chạy nhiều test suites song song, dùng `matrix`:

```yaml
strategy:
  matrix:
    test-suite: 
      - "Test Suites/UI/Login Testcases"
      - "Test Suites/UI/Signup Testcases"
```

---

## 📝 Checklist Setup

Trước khi bắt đầu, đảm bảo:

- [ ] ✅ Đã cài đặt Katalon Studio
- [ ] ✅ Đã tìm được đường dẫn Katalon Studio
- [ ] ✅ Đã download và cấu hình Self-Hosted Runner
- [ ] ✅ Đã chạy runner (`.\run.cmd`)
- [ ] ✅ Đã cập nhật `$KATALON_HOME_ORIGINAL` trong workflow
- [ ] ✅ Đã kiểm tra test suite path (nếu cần)
- [ ] ✅ Đã kiểm tra base URL (nếu cần)
- [ ] ✅ Đã commit và push workflow
- [ ] ✅ Đã chạy workflow lần đầu
- [ ] ✅ Đã xem và download reports

---

## 🔑 Các Lệnh Quan Trọng

```powershell
# Chạy runner
.\run.cmd

# Dừng runner
Ctrl + C

# Xem status runner (nếu dùng service)
.\svc.cmd status

# Restart runner (nếu dùng service)
.\svc.cmd restart

# Test lệnh Katalon local (trước khi push)
$KATALON_HOME = "C:\Users\YourName\.katalon\packages\KSE-10.4.2"
$PROJECT_PATH = "E:\path\to\project"
$TEST_SUITE = "Test Suites/UI/Login Testcases"

& "$KATALON_HOME\katalon.exe" -runMode=console `
  -projectPath="$PROJECT_PATH" `
  -testSuitePath="$TEST_SUITE" `
  -executionProfile=default `
  -browserType="Chrome (headless)"
```

---

## 🔗 Liên Kết Hữu Ích

- **GitHub Actions:** https://github.com/duowg29/KiemThu/actions
- **Runner Settings:** https://github.com/duowg29/KiemThu/settings/actions/runners
- **Workflow File:** `.github/workflows/katalon-tests.yml`
- **Katalon Documentation:** https://docs.katalon.com/

---

## 💡 Tips

1. **Luôn test local trước:** Chạy lệnh Katalon trực tiếp trên máy trước khi push workflow

2. **Dùng biến môi trường:** Thay vì hardcode đường dẫn, dùng `$env:USERPROFILE` hoặc `$env:ProgramFiles`

3. **Kiểm tra logs:** Luôn xem logs trong GitHub Actions để debug

4. **Backup cấu hình:** Commit cấu hình của bạn vào git để dễ dàng rollback nếu cần

5. **Documentation:** Ghi chú lại cấu hình của bạn trong file này hoặc README

---

## 🎉 Chúc Mừng!

Bạn đã hoàn thành setup Self-Hosted Runner cho GitHub Actions với Katalon Studio!

Nếu có vấn đề, xem phần **Troubleshooting** hoặc kiểm tra logs trong GitHub Actions.

---

**Cập nhật lần cuối:** 13/12/2025


