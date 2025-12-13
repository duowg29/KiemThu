# Hướng Dẫn Cấu Hình Workflow cho Self-Hosted Runner

## 📋 Mục Đích

File này hướng dẫn cách cấu hình file `.github/workflows/katalon-tests.yml` để phù hợp với máy tính của bạn khi sử dụng Self-Hosted Runner.

---

## 🔧 Các Bước Cấu Hình

### Bước 1: Tìm Đường Dẫn Katalon Studio

Trước khi sửa workflow, bạn cần tìm đường dẫn cài đặt Katalon Studio trên máy của bạn.

#### Cách 1: Tìm qua File Explorer

1. Mở **File Explorer** (Windows + E)
2. Tìm file `katalon.exe` hoặc `katalonc.exe`
3. Thường ở một trong các vị trí sau:
   - `C:\Users\<TênUser>\.katalon\packages\KSE-10.4.2\`
   - `C:\Program Files\Katalon\Katalon Studio\`
   - `C:\Program Files (x86)\Katalon\Katalon Studio\`

4. **Copy đường dẫn đầy đủ** (không bao gồm `katalon.exe`)

#### Cách 2: Tìm qua PowerShell

Mở PowerShell và chạy:

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

---

### Bước 2: Mở File Workflow

1. Mở project trong editor (VS Code, IntelliJ, v.v.)
2. Tìm file: `.github/workflows/katalon-tests.yml`
3. Mở file để chỉnh sửa

---

### Bước 3: Cập Nhật Đường Dẫn Katalon

Tìm dòng **khoảng dòng 36-44** trong file workflow:

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

#### Cách Sửa:

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

---

### Bước 4: Kiểm Tra Test Suite Path (Tùy Chọn)

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

---

### Bước 5: Kiểm Tra Base URL (Tùy Chọn)

Nếu bạn muốn test trên URL khác, có 2 cách:

#### Cách 1: Sửa trong Profile (Khuyến nghị)

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

#### Cách 2: Sửa trong Workflow

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

---

### Bước 6: Kiểm Tra Browser (Tùy Chọn)

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

---

### Bước 7: Kiểm Tra Execution Profile (Tùy Chọn)

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

---

## ✅ Kiểm Tra Cấu Hình

Sau khi sửa, kiểm tra lại:

1. **Đường dẫn Katalon:**
   - Đảm bảo đường dẫn đúng
   - File `katalon.exe` hoặc `katalonc.exe` phải tồn tại tại đường dẫn đó

2. **Test Suite:**
   - Đảm bảo test suite tồn tại
   - File `.ts` phải có trong project

3. **Base URL:**
   - Đảm bảo URL có thể truy cập được
   - Nếu dùng localhost, đảm bảo server đang chạy

4. **Syntax:**
   - Đảm bảo không có lỗi syntax YAML
   - Các dấu ngoặc kép phải đúng

---

## 🧪 Test Cấu Hình

### Cách 1: Chạy Workflow Thủ Công

1. Commit và push các thay đổi:
   ```bash
   git add .github/workflows/katalon-tests.yml
   git commit -m "Configure workflow for my machine"
   git push
   ```

2. Vào GitHub Actions:
   - https://github.com/duowg29/KiemThu/actions

3. Click **"Run workflow"** → Chọn branch → **"Run workflow"**

4. Xem logs để kiểm tra:
   - Đường dẫn Katalon có đúng không
   - Test suite có được tìm thấy không
   - Tests có chạy không

### Cách 2: Test Local Trước

Trước khi push, bạn có thể test lệnh Katalon trực tiếp trên máy:

```powershell
# Thay các giá trị cho phù hợp
$KATALON_HOME = "C:\Users\YourName\.katalon\packages\KSE-10.4.2"
$PROJECT_PATH = "E:\path\to\project"
$TEST_SUITE = "Test Suites/UI/Login Testcases"

# Chạy thử
& "$KATALON_HOME\katalon.exe" -runMode=console `
  -projectPath="$PROJECT_PATH" `
  -testSuitePath="$TEST_SUITE" `
  -executionProfile=default `
  -browserType="Chrome (headless)"
```

Nếu lệnh này chạy được, workflow cũng sẽ chạy được.

---

## 📝 Checklist Cấu Hình

Trước khi commit, đảm bảo:

- [ ] ✅ Đã tìm được đường dẫn Katalon Studio
- [ ] ✅ Đã cập nhật `$KATALON_HOME_ORIGINAL` trong workflow
- [ ] ✅ Đã kiểm tra test suite path (nếu cần)
- [ ] ✅ Đã kiểm tra base URL (nếu cần)
- [ ] ✅ Đã kiểm tra browser type (nếu cần)
- [ ] ✅ Đã test workflow chạy thành công

---

## 🐛 Troubleshooting

### Lỗi: "Katalon Studio not found"

**Nguyên nhân:** Đường dẫn Katalon không đúng

**Giải pháp:**
1. Kiểm tra lại đường dẫn trong workflow
2. Đảm bảo file `katalon.exe` tồn tại tại đường dẫn đó
3. Thử dùng đường dẫn tuyệt đối thay vì biến môi trường

### Lỗi: "Test suite not found"

**Nguyên nhân:** Test suite path không đúng

**Giải pháp:**
1. Kiểm tra tên test suite trong project
2. Đảm bảo dùng forward slash `/` thay vì backslash `\`
3. Không cần thêm extension `.ts`

### Lỗi: "Package path is too long"

**Nguyên nhân:** Đường dẫn Katalon quá dài (>260 ký tự)

**Giải pháp:**
1. Bật Windows Developer Mode
2. Hoặc di chuyển Katalon sang đường dẫn ngắn hơn (ví dụ: `C:\KS\KSE-10.4.2`)

### Lỗi: Tests không chạy

**Nguyên nhân:** Nhiều nguyên nhân có thể

**Giải pháp:**
1. Kiểm tra runner có đang chạy không (`.\run.cmd`)
2. Kiểm tra logs trong GitHub Actions
3. Đảm bảo Katalon có thể chạy được trên máy của bạn

---

## 📚 Ví Dụ Cấu Hình Hoàn Chỉnh

### Ví Dụ 1: Katalon ở User Directory

```yaml
run: |
  # Katalon ở user directory
  $KATALON_HOME_ORIGINAL = "$env:USERPROFILE\.katalon\packages\KSE-10.4.2"
  
  # Test suite mặc định
  $testSuitePath = "Test Suites/UI/Login Testcases"
  
  # Base URL từ profile
  $baseUrl = "http://localhost/CAMNEST/"
```

### Ví Dụ 2: Katalon ở Program Files

```yaml
run: |
  # Katalon ở Program Files
  $KATALON_HOME_ORIGINAL = "$env:ProgramFiles\Katalon\Katalon Studio"
  
  # Test suite khác
  $testSuitePath = "Test Suites/Functional/Account Management Testcases"
  
  # Base URL khác
  $baseUrl = "https://staging.example.com/CAMNEST/"
```

### Ví Dụ 3: Katalon ở Đường Dẫn Tùy Chỉnh

```yaml
run: |
  # Katalon ở đường dẫn tùy chỉnh
  $KATALON_HOME_ORIGINAL = "D:\Tools\Katalon\KSE-10.4.2"
  
  # Test suite tùy chỉnh
  $testSuitePath = "Test Suites/UI/Signup Testcases"
  
  # Base URL từ profile (không override)
  # $baseUrl sẽ được lấy từ Profiles/default.glbl
```

---

## 🔗 Liên Kết Hữu Ích

- **File Workflow:** `.github/workflows/katalon-tests.yml`
- **Hướng Dẫn Setup Runner:** `HUONG_DAN_SELF_HOSTED_RUNNER.md`
- **GitHub Actions:** https://github.com/duowg29/KiemThu/actions
- **Katalon Documentation:** https://docs.katalon.com/

---

## 💡 Tips

1. **Luôn test local trước:** Chạy lệnh Katalon trực tiếp trên máy trước khi push workflow

2. **Dùng biến môi trường:** Thay vì hardcode đường dẫn, dùng `$env:USERPROFILE` hoặc `$env:ProgramFiles`

3. **Kiểm tra logs:** Luôn xem logs trong GitHub Actions để debug

4. **Backup cấu hình:** Commit cấu hình của bạn vào git để dễ dàng rollback nếu cần

5. **Documentation:** Ghi chú lại cấu hình của bạn trong file này hoặc README

---

**Cập nhật lần cuối:** 13/12/2025

