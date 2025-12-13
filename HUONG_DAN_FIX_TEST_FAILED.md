# Hướng Dẫn Sửa Lỗi Test Failed

## 🔍 Bước 1: Xem Logs Chi Tiết

1. **Vào GitHub repository:**
   - https://github.com/duowg29/KiemThu
   - Click tab **"Actions"**

2. **Click vào workflow run bị failed** (màu đỏ)

3. **Click vào job "Run Katalon Studio Tests"**

4. **Xem logs từng step:**
   - Click vào step "Run Katalon Tests" để xem chi tiết
   - Tìm các dòng có chữ **ERROR**, **FAILED**, hoặc màu đỏ

5. **Copy lỗi** để tìm giải pháp

---

## 🐛 Các Lỗi Thường Gặp và Cách Sửa

### Lỗi 1: "Katalon Studio not found"

**Triệu chứng:**
```
ERROR: Katalon Studio not found at C:\Program Files\Katalon\Katalon Studio
```

**Nguyên nhân:** Đường dẫn Katalon trong workflow không đúng

**Giải pháp:**

1. **Tìm đường dẫn Katalon trên máy của bạn:**
   - Mở File Explorer
   - Tìm file `katalon.exe`
   - Thường ở:
     - `C:\Program Files\Katalon\Katalon Studio\katalon.exe`
     - `C:\Users\<TênUser>\.katalon\packages\KSE-10.4.2\katalon.exe`

2. **Sửa file workflow:**
   - Mở: `.github/workflows/katalon-tests.yml`
   - Tìm dòng (khoảng dòng 30):
     ```yaml
     $KATALON_HOME = "$env:ProgramFiles\Katalon\Katalon Studio"
     ```
   - Sửa thành đường dẫn đúng:
     ```yaml
     # Nếu cài trong user directory:
     $KATALON_HOME = "$env:USERPROFILE\.katalon\packages\KSE-10.4.2"
     
     # Hoặc đường dẫn tuyệt đối:
     $KATALON_HOME = "C:\Users\feu29\.katalon\packages\KSE-10.4.2"
     ```

3. **Commit và push:**
   ```bash
   git add .github/workflows/katalon-tests.yml
   git commit -m "Fix Katalon path"
   git push
   ```

---

### Lỗi 2: "Test Suite not found"

**Triệu chứng:**
```
Test Suite 'Test Suites/Functional/Account Management Testcases' not found
```

**Nguyên nhân:** Đường dẫn test suite không đúng

**Giải pháp:**

1. **Kiểm tra test suite có tồn tại:**
   - Mở project Katalon Studio
   - Xem trong thư mục `Test Suites`
   - Ghi nhớ đường dẫn chính xác

2. **Sửa file workflow:**
   - Mở: `.github/workflows/katalon-tests.yml`
   - Tìm dòng:
     ```yaml
     -testSuitePath="Test Suites/Functional/Account Management Testcases"
     ```
   - Sửa thành đường dẫn đúng:
     ```yaml
     -testSuitePath="Test Suites/Functional/Login Testcases"
     # Hoặc
     -testSuitePath="Test Suites/UI Testing"
     ```

3. **Commit và push**

---

### Lỗi 3: "Chrome not found" hoặc "ChromeDriver not found"

**Triệu chứng:**
```
ChromeDriver not found
Cannot find Chrome browser
```

**Nguyên nhân:** Chrome hoặc ChromeDriver chưa được cài đặt

**Giải pháp:**

1. **Cài Chrome (nếu chưa có):**
   - Tải từ: https://www.google.com/chrome/
   - Cài đặt như bình thường

2. **Hoặc dùng Firefox headless:**
   - Sửa workflow:
     ```yaml
     -browserType="Firefox (headless)"
     ```

3. **Hoặc cài ChromeDriver:**
   - Tải ChromeDriver: https://chromedriver.chromium.org/
   - Đặt vào PATH hoặc thư mục Katalon

---

### Lỗi 4: "WebView server has been started" (Bị treo)

**Triệu chứng:** Test bị treo ở "WebView server has been started"

**Giải pháp:**

Các JVM options đã được thêm vào workflow để tắt WebView. Nếu vẫn gặp:

1. **Kiểm tra JVM options trong workflow:**
   - Đảm bảo có dòng:
     ```yaml
     JAVA_OPTS: '-Djava.awt.headless=true -Dorg.eclipse.swt.browser.DefaultType=none ...'
     ```

2. **Nếu vẫn treo, thêm timeout:**
   - Workflow đã có `timeout-minutes: 30`
   - Có thể tăng lên nếu tests chạy lâu

---

### Lỗi 5: "Tests failed with exit code X"

**Triệu chứng:**
```
Tests failed with exit code 1
```

**Nguyên nhân:** Tests thực sự failed (không phải lỗi setup)

**Giải pháp:**

1. **Xem logs chi tiết:**
   - Tìm phần logs của Katalon
   - Xem test nào failed và tại sao

2. **Chạy test local trước:**
   - Mở Katalon Studio
   - Chạy test suite đó local
   - Xem có lỗi gì không

3. **Kiểm tra test data:**
   - Đảm bảo test data files có trong repo
   - Kiểm tra đường dẫn test data

4. **Kiểm tra environment:**
   - URL website có đúng không
   - Credentials có đúng không
   - Network có kết nối được không

---

### Lỗi 6: "Permission denied" hoặc "Access denied"

**Triệu chứng:**
```
Access is denied
Permission denied
```

**Nguyên nhân:** Không có quyền truy cập file/thư mục

**Giải pháp:**

1. **Chạy PowerShell với quyền Administrator:**
   - Right-click PowerShell
   - Chọn "Run as Administrator"

2. **Kiểm tra quyền thư mục:**
   - Đảm bảo runner có quyền đọc/ghi project

---

## 🔧 Debug Workflow

### Bước 1: Kiểm tra đường dẫn Katalon

Chạy lệnh này trên máy runner để tìm Katalon:

```powershell
# Tìm file katalon.exe
Get-ChildItem -Path C:\ -Filter katalon.exe -Recurse -ErrorAction SilentlyContinue | Select-Object FullName

# Hoặc tìm trong user directory
Get-ChildItem -Path $env:USERPROFILE -Filter katalon.exe -Recurse -ErrorAction SilentlyContinue | Select-Object FullName
```

### Bước 2: Test chạy Katalon thủ công

Trên máy runner, chạy thử:

```powershell
# Thay đường dẫn cho đúng
$KATALON_HOME = "C:\Users\feu29\.katalon\packages\KSE-10.4.2"
$PROJECT_PATH = "E:\path\to\project"  # Đường dẫn project

& "$KATALON_HOME\katalon.exe" -runMode=console `
  -projectPath="$PROJECT_PATH" `
  -testSuitePath="Test Suites/Functional/Login Testcases" `
  -executionProfile="default" `
  -browserType="Chrome (headless)"
```

Nếu chạy được local, copy đường dẫn vào workflow.

---

## 📋 Checklist Debug

- [ ] Đã xem logs chi tiết trên GitHub Actions
- [ ] Đã copy lỗi cụ thể
- [ ] Đã kiểm tra đường dẫn Katalon trên máy runner
- [ ] Đã kiểm tra test suite path có đúng không
- [ ] Đã kiểm tra Chrome/ChromeDriver có sẵn không
- [ ] Đã test chạy Katalon thủ công trên máy runner
- [ ] Đã sửa workflow file
- [ ] Đã commit và push
- [ ] Đã chạy lại workflow

---

## 🆘 Nếu Vẫn Không Được

1. **Copy toàn bộ logs** từ GitHub Actions
2. **Kiểm tra:**
   - Runner có online không (Settings → Actions → Runners)
   - Katalon Studio có cài đúng không
   - Project có được checkout đúng không

3. **Thử chạy test đơn giản trước:**
   - Tạo test suite đơn giản
   - Chạy thử xem có hoạt động không

---

## 💡 Tips

1. **Luôn xem logs chi tiết** - đó là nơi có thông tin lỗi
2. **Test local trước** - chạy test trên Katalon Studio local trước khi chạy trên CI
3. **Bắt đầu với test đơn giản** - không nên chạy toàn bộ test suite ngay
4. **Kiểm tra từng bước** - đảm bảo mỗi bước đều đúng trước khi chuyển sang bước tiếp theo

---

**Sau khi sửa, commit và push lại để workflow chạy lại! 🚀**

