# Các Bước Tích Hợp Katalon Studio vào CI/CD

## 1. Tổng Quan

Tích hợp Katalon Studio vào CI/CD (Continuous Integration/Continuous Deployment) cho phép tự động hóa việc chạy test cases mỗi khi có thay đổi code, pull request, hoặc theo lịch định kỳ. Điều này giúp phát hiện lỗi sớm và đảm bảo chất lượng phần mềm.

### Lợi Ích
- **Tự động hóa**: Test tự động chạy khi có code mới
- **Phát hiện lỗi sớm**: Tìm ra vấn đề ngay trong quá trình phát triển
- **Báo cáo tự động**: Kết quả test được lưu trữ và phân tích tự động
- **Tiết kiệm thời gian**: Không cần chạy test thủ công

---

## 2. Yêu Cầu Hệ Thống

### 2.1. Phần Mềm Cần Thiết

1. **Katalon Runtime Engine (KRE)**
   - Phiên bản: 10.4.2 trở lên
   - Đường dẫn cài đặt: `E:\App\Katalon_Studio_Engine_Windows_64-10.4.2`
   - **Lưu ý**: KRE là phiên bản headless của Katalon Studio, không có giao diện đồ họa

2. **GitHub Actions** (hoặc CI/CD platform khác)
   - Repository trên GitHub
   - Quyền truy cập vào GitHub Actions

3. **Katalon API Key**
   - Lấy từ Katalon TestOps hoặc Katalon Platform
   - Dùng để kích hoạt license cho KRE

### 2.2. Cấu Trúc Project

Project Katalon Studio cần có:
- File `.prj` (project file)
- Thư mục `Test Suites/` chứa các test suite
- File `build.gradle` (nếu có)

---

## 3. Các Bước Tích Hợp

### Bước 1: Chuẩn Bị Katalon Runtime Engine (KRE)

#### 3.1.1. Tải và Cài Đặt KRE

1. Truy cập trang download của Katalon Studio
2. Tải **Katalon Runtime Engine** (không phải Katalon Studio GUI)
3. Giải nén vào thư mục cố định, ví dụ: `E:\App\Katalon_Studio_Engine_Windows_64-10.4.2`

**📸 Ảnh cần chụp:**
- Màn hình download KRE từ website Katalon
- Cấu trúc thư mục sau khi giải nén KRE
- File `katalonc.exe` trong thư mục KRE

#### 3.1.2. Kích Hoạt License

KRE cần license để chạy. Có 2 cách:

**Cách 1: Sử dụng API Key (Khuyến nghị)**
- Lấy API Key từ Katalon TestOps
- Lưu vào GitHub Secrets (sẽ hướng dẫn ở bước sau)

**Cách 2: Sử dụng Offline License**
- Tải license file từ Katalon Platform
- Đặt vào thư mục: `%USERPROFILE%\.katalon\license`

**📸 Ảnh cần chụp:**
- Trang Katalon TestOps hiển thị API Key
- Cấu trúc thư mục `.katalon\license` với file license

---

### Bước 2: Tạo GitHub Actions Workflow

#### 3.2.1. Tạo File Workflow

1. Trong repository GitHub, tạo thư mục `.github/workflows/` (nếu chưa có)
2. Tạo file mới: `katalon-tests.yml`

**📸 Ảnh cần chụp:**
- Cấu trúc thư mục `.github/workflows/` trong repository
- File `katalon-tests.yml` mới tạo

#### 3.2.2. Cấu Hình Workflow Trigger

Thêm phần trigger để workflow chạy tự động:

```yaml
name: Katalon Tests CI/CD

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]
  workflow_dispatch:
  schedule:
    - cron: '0 2 * * *'  # Chạy hàng ngày lúc 2h sáng
```

**Giải thích:**
- `push`: Chạy khi có code push lên branch main/master
- `pull_request`: Chạy khi có pull request
- `workflow_dispatch`: Cho phép chạy thủ công từ GitHub UI
- `schedule`: Chạy theo lịch (cron format)

**📸 Ảnh cần chụp:**
- Màn hình GitHub Actions với các trigger events
- Màn hình workflow_dispatch (chạy thủ công)

---

### Bước 3: Cấu Hình Job và Steps

#### 3.3.1. Cấu Hình Job

```yaml
jobs:
  run-katalon-tests:
    name: Run Katalon Runtime Engine (KRE) Tests
    runs-on: self-hosted  # Hoặc ubuntu-latest, windows-latest
```

**Lưu ý về `runs-on`:**
- `self-hosted`: Chạy trên máy tự host (cần cài đặt GitHub Actions Runner)
- `windows-latest`: Chạy trên Windows runner của GitHub (miễn phí nhưng có giới hạn)
- `ubuntu-latest`: Chạy trên Linux runner

**📸 Ảnh cần chụp:**
- Màn hình cấu hình self-hosted runner (nếu dùng)
- Hoặc màn hình GitHub Actions runner selection

#### 3.3.2. Step 1: Checkout Code

```yaml
- name: Checkout code
  uses: actions/checkout@v4
```

Step này tải code từ repository về runner.

**📸 Ảnh cần chụp:**
- Log output của step checkout trong GitHub Actions

---

### Bước 4: Cấu Hình Biến Môi Trường và Secrets

#### 3.4.1. Thêm Katalon API Key vào GitHub Secrets

1. Vào repository GitHub → **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Tên: `KATALON_API_KEY`
4. Giá trị: API Key từ Katalon TestOps
5. Click **Add secret**

**📸 Ảnh cần chụp:**
- Màn hình GitHub Secrets với secret `KATALON_API_KEY` đã tạo
- (Che giấu giá trị thực của API key)

#### 3.4.2. Cấu Hình Environment Variables trong Workflow

```yaml
env:
  JAVA_OPTS: '-Djava.awt.headless=true -Dorg.eclipse.swt.browser.DefaultType=none -Dkatalon.webview.enabled=false'
  KATALON_OPTS: '-noSplash -consoleLog'
  KATALON_API_KEY: ${{ secrets.KATALON_API_KEY }}
```

**Giải thích:**
- `JAVA_OPTS`: Cấu hình Java để chạy headless (không cần GUI)
- `KATALON_OPTS`: Tùy chọn cho Katalon (không hiển thị splash screen)
- `KATALON_API_KEY`: Lấy từ GitHub Secrets

**📸 Ảnh cần chụp:**
- Phần environment variables trong workflow file
- Log output hiển thị environment variables đã set

---

### Bước 5: Viết Script Chạy KRE

#### 3.5.1. Kiểm Tra KRE Có Tồn Tại

```powershell
$KRE_HOME = "E:\App\Katalon_Studio_Engine_Windows_64-10.4.2"

if (-not (Test-Path $KRE_HOME)) {
  Write-Host "ERROR: KRE not found at $KRE_HOME" -ForegroundColor Red
  exit 1
}
```

**📸 Ảnh cần chụp:**
- Log output khi KRE được tìm thấy thành công
- Log output khi KRE không tìm thấy (error case)

#### 3.5.2. Tìm KRE Executable

```powershell
$katalonExe = $null
$possibleExes = @(
  "$KRE_HOME\katalonc.exe",
  "$KRE_HOME\katalonc",
  "$KRE_HOME\katalon.exe"
)

foreach ($exe in $possibleExes) {
  if (Test-Path $exe) {
    $katalonExe = $exe
    break
  }
}
```

**📸 Ảnh cần chụp:**
- Log output hiển thị đường dẫn KRE executable đã tìm thấy

#### 3.5.3. Kiểm Tra License

```powershell
$katalonApiKey = $env:KATALON_API_KEY
$offlineLicensePath = "$env:USERPROFILE\.katalon\license"

if ($katalonApiKey) {
  Write-Host "Using API key for license activation" -ForegroundColor Green
} elseif (Test-Path $offlineLicensePath) {
  Write-Host "Found offline license files" -ForegroundColor Green
} else {
  Write-Host "WARNING: No license found" -ForegroundColor Yellow
}
```

**📸 Ảnh cần chụp:**
- Log output khi license được kích hoạt thành công
- Log output cảnh báo khi không có license

---

### Bước 6: Cấu Hình Project và Test Suite Paths

#### 3.6.1. Xác Định Project Path

```powershell
$projectPath = (Resolve-Path $PWD).Path -replace '\\', '/'
```

**Lưu ý**: Project path phải là absolute path và chứa file `.prj`

**📸 Ảnh cần chụp:**
- Log output hiển thị project path đã resolve
- File `.prj` trong project directory

#### 3.6.2. Xác Định Test Suite Path

```powershell
$testSuitePath = "Test Suites/UI/Navigation Testcases"
```

**Lưu ý**: 
- Path là relative path từ project root
- Không bao gồm extension `.ts`
- Có thể có khoảng trắng trong tên

**📸 Ảnh cần chụp:**
- Cấu trúc thư mục Test Suites trong project
- File test suite `.ts` tương ứng

#### 3.6.3. Kiểm Tra Project File

```powershell
$projectFile = Get-ChildItem -Path $projectPath -Filter "*.prj" -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $projectFile) {
  Write-Host "ERROR: No .prj file found" -ForegroundColor Red
  exit 1
}
```

**📸 Ảnh cần chụp:**
- Log output khi tìm thấy file `.prj`
- Log output khi không tìm thấy file `.prj` (error case)

---

### Bước 7: Xây Dựng Lệnh Chạy KRE

#### 3.7.1. Tạo Arguments cho KRE

```powershell
$katalonArgs = @(
  '-data', '@noDefault'
  '-runMode=console'
  '-console'
  '-noSplash'
  '-consoleLog'
  "-projectPath=$projectPath"
  "-testSuitePath=$testSuitePathFormatted"
  '-executionProfile=default'
  '-browserType=Chrome (headless)'
  "-g_baseUrl=$baseUrl"
  "-reportFolder=$reportFolder"
  '-retry=0'
)

if ($katalonApiKey) {
  $katalonArgs += "-apiKey=$katalonApiKey"
}
```

**Giải thích các tham số:**
- `-data @noDefault`: Không dùng workspace mặc định
- `-runMode=console`: Chạy ở chế độ console
- `-projectPath`: Đường dẫn đến project
- `-testSuitePath`: Đường dẫn đến test suite
- `-browserType=Chrome (headless)`: Chạy Chrome ở chế độ headless
- `-g_baseUrl`: Base URL của ứng dụng test
- `-reportFolder`: Thư mục lưu báo cáo
- `-apiKey`: API key để kích hoạt license

**📸 Ảnh cần chụp:**
- Log output hiển thị đầy đủ arguments đã build
- Command line cuối cùng được execute

#### 3.7.2. Chạy KRE Process

```powershell
$processInfo = New-Object System.Diagnostics.ProcessStartInfo
$processInfo.FileName = $katalonExe
$processInfo.Arguments = $argumentsString -join ' '
$processInfo.UseShellExecute = $false
$processInfo.RedirectStandardOutput = $true
$processInfo.RedirectStandardError = $true
$processInfo.CreateNoWindow = $true
$processInfo.WorkingDirectory = $projectPath

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $processInfo
$process.Start()
```

**📸 Ảnh cần chụp:**
- Log output khi process bắt đầu chạy (PID, start time)
- Real-time output từ KRE trong quá trình chạy
- Log output khi process hoàn thành (exit code, duration)

---

### Bước 8: Xử Lý Output và Monitoring

#### 3.8.1. Capture Real-time Output

```powershell
$outputBuilder = New-Object System.Text.StringBuilder
$errorBuilder = New-Object System.Text.StringBuilder

$outputEvent = Register-ObjectEvent -InputObject $process -EventName OutputDataReceived -Action {
    if ($EventArgs.Data) {
        $line = $EventArgs.Data
        [void]$Event.MessageData.AppendLine($line)
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] $line" -ForegroundColor Cyan
    }
} -MessageData $outputBuilder

$process.BeginOutputReadLine()
$process.BeginErrorReadLine()
```

**📸 Ảnh cần chụp:**
- Real-time log output trong quá trình test chạy
- Timestamp và colored output

#### 3.8.2. Monitor Process với Timeout

```powershell
$timeoutMinutes = 25
$startTime = Get-Date

while (-not $process.HasExited) {
    $elapsed = (Get-Date) - $startTime
    if ($elapsed.TotalSeconds -ge ($timeoutMinutes * 60)) {
        Write-Host "TIMEOUT: Process exceeded $timeoutMinutes minutes" -ForegroundColor Red
        $process.Kill()
        break
    }
    Start-Sleep -Seconds 10
}
```

**📸 Ảnh cần chụp:**
- Status updates mỗi 30 giây trong quá trình chạy
- Log output khi timeout xảy ra

---

### Bước 9: Phân Tích Kết Quả Test

#### 3.9.1. Kiểm Tra Reports Folder

```powershell
if (Test-Path "Reports") {
  $reportFiles = Get-ChildItem -Path "Reports" -Recurse -File
  Write-Host "Found $($reportFiles.Count) report file(s)"
}
```

**📸 Ảnh cần chụp:**
- Cấu trúc thư mục Reports sau khi test chạy xong
- Các file report được tạo (HTML, CSV, XML)

#### 3.9.2. Đọc JUnit Report

```powershell
$junitReports = Get-ChildItem -Path "Reports" -Recurse -Filter "JUnit_Report.xml"
if ($junitReports) {
  [xml]$junitXml = Get-Content $junitReports.FullName
  $totalTests = $junitXml.testsuites.tests
  $failures = $junitXml.testsuites.failures
  $errors = $junitXml.testsuites.errors
  
  Write-Host "Test Results Summary:"
  Write-Host "  Total Tests: $totalTests"
  Write-Host "  Failures: $failures"
  Write-Host "  Errors: $errors"
}
```

**📸 Ảnh cần chụp:**
- Log output hiển thị test results summary
- Nội dung file JUnit_Report.xml (một phần)
- HTML report được mở trong browser

#### 3.9.3. Xử Lý Exit Code

```powershell
if ($exitCode -eq 0) {
  Write-Host "SUCCESS: Tests completed successfully" -ForegroundColor Green
} elseif ($exitCode -eq 1) {
  Write-Host "EXIT CODE 1: Tests executed but may have failures" -ForegroundColor Yellow
} elseif ($exitCode -eq 2) {
  Write-Host "ERROR: Configuration/Project error" -ForegroundColor Red
}
```

**Giải thích Exit Codes:**
- `0`: Tất cả test pass
- `1`: Test chạy nhưng có failures hoặc warnings
- `2`: Lỗi cấu hình hoặc project
- `3`: Lỗi trong quá trình thực thi test

**📸 Ảnh cần chụp:**
- Log output với exit code và kết quả tương ứng
- GitHub Actions workflow status (success/failure)

---

### Bước 10: Format và Upload Reports

#### 3.10.1. Format CSV Report cho Excel

```powershell
$csvFiles = Get-ChildItem -Path "Reports" -Recurse -Filter "*.csv"
$mainCsv = $csvFiles | Where-Object { $_.Name -eq 'report.csv' } | Select-Object -First 1

# Đọc và format với UTF-8 BOM cho Excel
$utf8WithBom = New-Object System.Text.UTF8Encoding $true
$content = Get-Content $mainCsv.FullName
$outputCsv = Join-Path "Reports" "test-results-formatted.csv"

$writer = New-Object System.IO.StreamWriter($outputCsv, $false, $utf8WithBom)
foreach ($line in $content) {
  $writer.WriteLine($line)
}
$writer.Close()
```

**Lưu ý**: UTF-8 BOM cần thiết để Excel hiển thị đúng tiếng Việt

**📸 Ảnh cần chụp:**
- File CSV gốc và file CSV đã format
- Mở file CSV trong Excel để kiểm tra encoding

#### 3.10.2. Upload Artifact

```yaml
- name: Upload Formatted CSV Report
  if: always()
  uses: actions/upload-artifact@v4
  with:
    name: test-results-excel
    path: Reports/test-results-formatted.csv
    if-no-files-found: warn
    retention-days: 30
```

**📸 Ảnh cần chụp:**
- Màn hình GitHub Actions artifacts sau khi upload
- Download và mở artifact để kiểm tra

---

## 4. Kiểm Tra và Xác Thực

### 4.1. Test Workflow Lần Đầu

1. Push code lên repository
2. Vào tab **Actions** trên GitHub
3. Xem workflow đang chạy
4. Kiểm tra logs từng step

**📸 Ảnh cần chụp:**
- Màn hình GitHub Actions với workflow đang chạy
- Log output của từng step (checkout, run tests, upload artifacts)
- Workflow status: success hoặc failure

### 4.2. Kiểm Tra Kết Quả

1. Xem test results summary trong logs
2. Download artifacts (CSV report)
3. Kiểm tra HTML report (nếu có)

**📸 Ảnh cần chụp:**
- Test results summary trong GitHub Actions logs
- HTML report mở trong browser
- CSV report mở trong Excel

### 4.3. Xử Lý Lỗi Thường Gặp

#### Lỗi: KRE not found
- **Nguyên nhân**: Đường dẫn KRE không đúng
- **Giải pháp**: Kiểm tra và cập nhật `$KRE_HOME`

#### Lỗi: License activation failed
- **Nguyên nhân**: API key không đúng hoặc không có
- **Giải pháp**: Kiểm tra GitHub Secrets

#### Lỗi: Test suite not found
- **Nguyên nhân**: Đường dẫn test suite không đúng
- **Giải pháp**: Kiểm tra tên test suite và cập nhật `$testSuitePath`

#### Lỗi: Exit code 2
- **Nguyên nhân**: Lỗi cấu hình project
- **Giải pháp**: Kiểm tra file `.prj` và project structure

**📸 Ảnh cần chụp:**
- Log output của các lỗi thường gặp
- Cách fix từng lỗi

---

## 5. Tối Ưu Hóa và Best Practices

### 5.1. Sử Dụng Matrix Strategy

Chạy test trên nhiều browser/profiles:

```yaml
strategy:
  matrix:
    browser: [Chrome, Firefox, Edge]
    profile: [default, staging, production]
```

**📸 Ảnh cần chụp:**
- Matrix build với nhiều jobs chạy song song
- Kết quả của từng matrix combination

### 5.2. Caching Dependencies

Cache KRE và dependencies để tăng tốc:

```yaml
- name: Cache KRE
  uses: actions/cache@v3
  with:
    path: E:\App\Katalon_Studio_Engine_Windows_64-10.4.2
    key: katalon-kre-10.4.2
```

### 5.3. Parallel Test Execution

Chia test suite thành nhiều phần và chạy song song:

```yaml
jobs:
  test-suite-1:
    # ...
  test-suite-2:
    # ...
```

**📸 Ảnh cần chụp:**
- Multiple jobs chạy song song
- Tổng thời gian execution giảm

### 5.4. Notifications

Thêm notification khi test fail:

```yaml
- name: Notify on failure
  if: failure()
  uses: actions/github-script@v6
  with:
    script: |
      // Send notification
```

---

## 6. Tổng Kết

### 6.1. Checklist Hoàn Thành

- [ ] KRE đã được cài đặt và kích hoạt license
- [ ] GitHub Secrets đã được cấu hình (KATALON_API_KEY)
- [ ] Workflow file đã được tạo và cấu hình đúng
- [ ] Project path và test suite path đã được xác định đúng
- [ ] Workflow chạy thành công và tạo reports
- [ ] Artifacts được upload và có thể download
- [ ] Test results được phân tích đúng

### 6.2. Kết Quả Đạt Được

Sau khi tích hợp thành công:
- ✅ Test tự động chạy khi có code mới
- ✅ Kết quả test được lưu trữ và phân tích
- ✅ Báo cáo được format và upload tự động
- ✅ Phát hiện lỗi sớm trong quá trình phát triển

---

## 7. Tài Liệu Tham Khảo

- [Katalon Runtime Engine Documentation](https://docs.katalon.com/katalon-runtime-engine/docs/overview.html)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Katalon CI/CD Integration Guide](https://docs.katalon.com/katalon-studio/docs/integration-with-ci-cd-tools.html)

---

## Phụ Lục: Danh Sách Ảnh Cần Chụp

### A. Chuẩn Bị Môi Trường
1. Màn hình download KRE từ website Katalon
2. Cấu trúc thư mục KRE sau khi giải nén
3. File `katalonc.exe` trong thư mục KRE
4. Trang Katalon TestOps hiển thị API Key
5. Cấu trúc thư mục `.katalon\license` với file license

### B. Cấu Hình GitHub
6. Cấu trúc thư mục `.github/workflows/` trong repository
7. File `katalon-tests.yml` mới tạo
8. Màn hình GitHub Actions với các trigger events
9. Màn hình workflow_dispatch (chạy thủ công)
10. Màn hình GitHub Secrets với secret `KATALON_API_KEY` đã tạo

### C. Cấu Hình Workflow
11. Phần environment variables trong workflow file
12. Log output hiển thị environment variables đã set
13. Log output khi KRE được tìm thấy thành công
14. Log output hiển thị đường dẫn KRE executable
15. Log output khi license được kích hoạt thành công

### D. Cấu Hình Project
16. Log output hiển thị project path đã resolve
17. File `.prj` trong project directory
18. Cấu trúc thư mục Test Suites trong project
19. File test suite `.ts` tương ứng
20. Log output khi tìm thấy file `.prj`

### E. Chạy Test
21. Log output hiển thị đầy đủ arguments đã build
22. Command line cuối cùng được execute
23. Log output khi process bắt đầu chạy (PID, start time)
24. Real-time output từ KRE trong quá trình chạy
25. Status updates mỗi 30 giây trong quá trình chạy
26. Log output khi process hoàn thành (exit code, duration)

### F. Kết Quả và Reports
27. Cấu trúc thư mục Reports sau khi test chạy xong
28. Các file report được tạo (HTML, CSV, XML)
29. Log output hiển thị test results summary
30. Nội dung file JUnit_Report.xml (một phần)
31. HTML report được mở trong browser
32. Log output với exit code và kết quả tương ứng
33. GitHub Actions workflow status (success/failure)

### G. Artifacts
34. File CSV gốc và file CSV đã format
35. Mở file CSV trong Excel để kiểm tra encoding
36. Màn hình GitHub Actions artifacts sau khi upload
37. Download và mở artifact để kiểm tra

### H. Kiểm Tra và Xác Thực
38. Màn hình GitHub Actions với workflow đang chạy
39. Log output của từng step (checkout, run tests, upload artifacts)
40. Test results summary trong GitHub Actions logs
41. CSV report mở trong Excel

### I. Xử Lý Lỗi
42. Log output của các lỗi thường gặp
43. Cách fix từng lỗi

### J. Tối Ưu Hóa
44. Matrix build với nhiều jobs chạy song song
45. Kết quả của từng matrix combination
46. Multiple jobs chạy song song

---

**Lưu ý**: Tất cả ảnh nên có chú thích rõ ràng và được đánh số theo thứ tự trong báo cáo.

