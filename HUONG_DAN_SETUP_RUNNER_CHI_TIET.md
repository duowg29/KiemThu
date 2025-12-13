# Hướng Dẫn Chi Tiết Setup Self-Hosted Runner

## 📍 Câu Hỏi: Chạy Lệnh Ở Đâu?

**Trả lời:** Bạn có thể chạy ở **BẤT KỲ ĐÂU**, không nhất thiết phải ổ C!

### ✅ Có Thể Chạy Ở:
- ✅ Ổ C: `C:\actions-runner`
- ✅ Ổ E: `E:\actions-runner` ⭐ (Khuyến nghị nếu ổ E có nhiều dung lượng)
- ✅ Ổ D: `D:\actions-runner`
- ✅ Bất kỳ ổ nào khác
- ✅ Thư mục bất kỳ: `E:\MyProjects\actions-runner`

---

## 🚀 Các Bước Chi Tiết

### Bước 1: Mở PowerShell hoặc Command Prompt

**Cách 1: PowerShell (Khuyến nghị)**
1. Nhấn `Windows + X`
2. Chọn **"Windows PowerShell"** hoặc **"Terminal"**
3. Hoặc tìm "PowerShell" trong Start Menu

**Cách 2: Command Prompt**
1. Nhấn `Windows + R`
2. Gõ `cmd` và nhấn Enter

### Bước 2: Chọn Ổ Đĩa và Tạo Thư Mục

**Ví dụ: Dùng ổ E**

```powershell
# Chuyển sang ổ E
E:

# Tạo thư mục actions-runner
mkdir actions-runner

# Vào thư mục vừa tạo
cd actions-runner
```

**Hoặc dùng đường dẫn đầy đủ:**

```powershell
# Tạo thư mục trực tiếp
mkdir E:\actions-runner

# Vào thư mục
cd E:\actions-runner
```

### Bước 3: Download Runner

**Lấy lệnh download từ GitHub:**

1. Vào: https://github.com/duowg29/KiemThu/settings/actions/runners/new
2. Chọn **"x64"** (Windows 64-bit)
3. Copy lệnh download (sẽ có dạng như):
   ```powershell
   Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.329.0/actions-runner-win-x64-2.329.0.zip -OutFile actions-runner-win-x64-2.329.0.zip
   ```

4. **Paste vào PowerShell** và nhấn Enter
   - File sẽ được download vào thư mục hiện tại (ví dụ: `E:\actions-runner\`)

### Bước 4: Giải Nén File

```powershell
# Giải nén file zip
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.329.0.zip", "$PWD")
```

**Sau khi giải nén, bạn sẽ thấy các file:**
- `config.cmd`
- `run.cmd`
- `svc.cmd`
- Và các file khác

### Bước 5: Config Runner

1. **Lấy token từ GitHub:**
   - Vào: https://github.com/duowg29/KiemThu/settings/actions/runners/new
   - Copy token (dòng dài có chữ và số)

2. **Chạy lệnh config:**
   ```powershell
   .\config.cmd --url https://github.com/duowg29/KiemThu --token YOUR_TOKEN
   ```
   (Thay `YOUR_TOKEN` bằng token bạn đã copy)

3. **Trả lời các câu hỏi:**
   - **Enter the name of the runner:** Nhấn Enter (dùng tên mặc định) hoặc đặt tên (ví dụ: `my-windows-runner`)
   - **Enter the name of the work folder:** Nhấn Enter (dùng mặc định)
   - **Enter additional labels:** Nhấn Enter (không cần)
   - **Enter name of the runner as an environment variable:** Nhấn Enter

### Bước 6: Chạy Runner

```powershell
.\run.cmd
```

**Lưu ý:** Cửa sổ PowerShell này phải **MỞ** để runner hoạt động. Nếu đóng cửa sổ, runner sẽ ngừng.

---

## 📂 File Ở Đâu?

Sau khi setup xong, các file runner sẽ ở:

**Ví dụ nếu bạn chạy trên ổ E:**
```
E:\actions-runner\
├── actions-runner-win-x64-2.329.0.zip  (file zip đã download)
├── config.cmd                          (file config)
├── run.cmd                             (file chạy runner)
├── svc.cmd                             (file cài service)
├── bin/                                (thư mục chứa các file thực thi)
├── externals/                          (thư mục chứa dependencies)
└── ...                                 (các file khác)
```

**Để tìm lại thư mục:**
1. Mở File Explorer
2. Vào ổ E (hoặc ổ bạn đã chọn)
3. Tìm thư mục `actions-runner`

---

## 🔄 Chạy Runner Tự Động (Windows Service)

Để runner chạy tự động khi khởi động máy (không cần mở PowerShell):

1. **Dừng runner hiện tại** (nếu đang chạy):
   - Nhấn `Ctrl + C` trong cửa sổ PowerShell

2. **Cài đặt service:**
   ```powershell
   .\svc.cmd install
   ```

3. **Khởi động service:**
   ```powershell
   .\svc.cmd start
   ```

4. **Kiểm tra status:**
   ```powershell
   .\svc.cmd status
   ```

**Lợi ích:**
- ✅ Runner chạy tự động khi khởi động máy
- ✅ Không cần mở PowerShell
- ✅ Runner chạy ngầm

**Gỡ service (nếu cần):**
```powershell
.\svc.cmd stop
.\svc.cmd uninstall
```

---

## 📋 Ví Dụ Đầy Đủ (Dùng Ổ E)

```powershell
# Bước 1: Chuyển sang ổ E
E:

# Bước 2: Tạo thư mục
mkdir actions-runner
cd actions-runner

# Bước 3: Download (copy lệnh từ GitHub)
Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.329.0/actions-runner-win-x64-2.329.0.zip -OutFile actions-runner-win-x64-2.329.0.zip

# Bước 4: Giải nén
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.329.0.zip", "$PWD")

# Bước 5: Config (thay YOUR_TOKEN)
.\config.cmd --url https://github.com/duowg29/KiemThu --token YOUR_TOKEN

# Bước 6: Chạy
.\run.cmd
```

---

## ⚠️ Lưu Ý Quan Trọng

1. **Quyền Administrator:**
   - Không cần quyền admin để chạy runner
   - Nhưng nếu cài service, có thể cần quyền admin

2. **Dung lượng:**
   - Runner cần khoảng 200-500 MB dung lượng
   - Đảm bảo ổ bạn chọn có đủ dung lượng

3. **Firewall:**
   - Runner cần kết nối internet
   - Đảm bảo firewall không chặn

4. **Token:**
   - Token chỉ dùng được 1 lần và có thời hạn ngắn
   - Nếu hết hạn, tạo token mới từ GitHub

---

## 🆘 Troubleshooting

### Lỗi: "Cannot create directory"

**Giải pháp:**
- Kiểm tra quyền ghi trên ổ đĩa
- Thử ổ khác (ví dụ: ổ E thay vì ổ C)

### Lỗi: "Token expired"

**Giải pháp:**
- Tạo token mới từ GitHub
- Chạy lại lệnh config với token mới

### Lỗi: "Runner is offline"

**Giải pháp:**
- Đảm bảo `.\run.cmd` đang chạy
- Hoặc service đang chạy: `.\svc.cmd status`

---

## ✅ Checklist

- [ ] Đã chọn ổ đĩa (ví dụ: ổ E)
- [ ] Đã tạo thư mục `actions-runner`
- [ ] Đã download runner từ GitHub
- [ ] Đã giải nén file
- [ ] Đã config với token từ GitHub
- [ ] Đã chạy `.\run.cmd` hoặc cài service
- [ ] Runner hiển thị "online" trên GitHub

---

**Sau khi setup xong, runner sẽ sẵn sàng nhận jobs từ GitHub Actions! 🎉**

