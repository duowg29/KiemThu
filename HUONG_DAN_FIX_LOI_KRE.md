# Hướng Dẫn Sửa Lỗi Download KRE

## ❌ Vấn Đề

Workflow `katalon-tests-kre.yml` bị lỗi khi download Katalon Runtime Engine (KRE) vì:
- KRE không có sẵn trên GitHub releases theo format đó
- URL download không đúng hoặc version không tồn tại

## ✅ Giải Pháp: Dùng Self-Hosted Runner

**Khuyến nghị:** Dùng self-hosted runner thay vì KRE vì:
- ✅ Không cần download KRE
- ✅ Dùng Katalon Studio đầy đủ (đã cài sẵn)
- ✅ Nhanh hơn, ổn định hơn
- ✅ Không gặp lỗi download

---

## 🚀 Các Bước Setup

### Bước 1: Cài Katalon Studio trên máy Windows

1. Tải Katalon Studio: https://www.katalon.com/download/
2. Cài đặt như bình thường
3. **Ghi nhớ đường dẫn cài đặt:**
   - Thường là: `C:\Program Files\Katalon\Katalon Studio`
   - Hoặc: `C:\Users\<TênUser>\.katalon\packages\KSE-10.4.2`

### Bước 2: Setup Self-Hosted Runner

1. **Vào GitHub repository:**
   - https://github.com/duowg29/KiemThu
   - Click **Settings** → **Actions** → **Runners**

2. **Tạo runner mới:**
   - Click **"New self-hosted runner"**
   - Chọn **"x64"** (Windows 64-bit)
   - Copy các lệnh từ GitHub

3. **Chạy trên máy Windows của bạn:**
   ```powershell
   # Tạo thư mục
   cd C:\
   mkdir actions-runner
   cd actions-runner
   
   # Download runner (copy lệnh từ GitHub)
   Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.329.0/actions-runner-win-x64-2.329.0.zip -OutFile actions-runner-win-x64-2.329.0.zip
   
   # Giải nén
   Add-Type -AssemblyName System.IO.Compression.FileSystem
   [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.329.0.zip", "$PWD")
   
   # Config (thay YOUR_TOKEN bằng token từ GitHub)
   .\config.cmd --url https://github.com/duowg29/KiemThu --token YOUR_TOKEN
   
   # Chạy runner
   .\run.cmd
   ```

4. **Cài như Windows Service (tùy chọn - để chạy tự động):**
   ```powershell
   .\svc.cmd install
   .\svc.cmd start
   ```

### Bước 3: Sửa Workflow File

1. **Mở file:** `.github/workflows/katalon-tests-simple.yml`

2. **Tìm dòng này (khoảng dòng 20):**
   ```yaml
   $KATALON_HOME = "$env:ProgramFiles\Katalon\Katalon Studio"
   ```

3. **Sửa đường dẫn cho đúng với máy của bạn:**
   - Nếu cài trong Program Files: giữ nguyên
   - Nếu cài trong user directory: uncomment dòng Option 2
   - Nếu cài ở nơi khác: uncomment Option 3 và sửa đường dẫn

4. **Sửa test suite (nếu cần):**
   - Tìm dòng: `-testSuitePath="Test Suites/Functional/Account Management Testcases"`
   - Sửa thành test suite bạn muốn

5. **Lưu file**

### Bước 4: Commit và Push

```bash
git add .github/workflows/katalon-tests-simple.yml
git commit -m "Add self-hosted runner workflow"
git push
```

### Bước 5: Kiểm Tra

1. Vào tab **Actions** trên GitHub
2. Workflow sẽ chạy khi bạn push code
3. Bạn sẽ thấy runner của bạn (tên bạn đã đặt) trong danh sách

---

## 🔄 Tắt Workflow KRE (Tùy Chọn)

Nếu không muốn dùng KRE nữa, bạn có thể:

1. **Xóa file:** `.github/workflows/katalon-tests-kre.yml`
   ```bash
   git rm .github/workflows/katalon-tests-kre.yml
   git commit -m "Remove KRE workflow, use self-hosted runner instead"
   git push
   ```

2. **Hoặc đổi tên file** để disable (thêm `.disabled` vào tên):
   ```bash
   git mv .github/workflows/katalon-tests-kre.yml .github/workflows/katalon-tests-kre.yml.disabled
   ```

---

## 📋 Checklist

- [ ] Đã cài Katalon Studio trên máy Windows
- [ ] Đã ghi nhớ đường dẫn cài đặt
- [ ] Đã setup self-hosted runner
- [ ] Runner đang chạy (PowerShell window mở hoặc service running)
- [ ] Đã sửa đường dẫn Katalon trong workflow file
- [ ] Đã sửa test suite (nếu cần)
- [ ] Đã commit và push
- [ ] Đã kiểm tra workflow chạy trên GitHub

---

## 🆘 Troubleshooting

### Lỗi: "Katalon Studio not found"

**Giải pháp:**
- Kiểm tra đường dẫn trong workflow file
- Đảm bảo Katalon Studio đã được cài đặt
- Thử đường dẫn tuyệt đối: `C:\Program Files\Katalon\Katalon Studio`

### Lỗi: "Runner is offline"

**Giải pháp:**
- Kiểm tra runner có đang chạy không
- Mở PowerShell và chạy `.\run.cmd` trong thư mục runner
- Hoặc kiểm tra service: `.\svc.cmd status`

### Lỗi: "Tests failed"

**Giải pháp:**
- Kiểm tra logs trong GitHub Actions
- Đảm bảo test suite path đúng
- Kiểm tra Chrome/ChromeDriver có sẵn trên máy runner

---

## 📚 Tài Liệu Tham Khảo

- Self-hosted Runners: https://docs.github.com/en/actions/hosting-your-own-runners
- Katalon Studio: https://docs.katalon.com/katalon-studio/docs/console-mode-execution.html

---

**Sau khi setup xong, workflow sẽ chạy tự động mỗi khi bạn push code! 🎉**

