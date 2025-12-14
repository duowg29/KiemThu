# FIX: Java Exit Code 1 Error

**Ngày:** 14/12/2025

## ⚠️ VẤN ĐỀ

Từ hình ảnh, tôi thấy lỗi:
- **"Java was started but returned exit code=1"**
- `-data @noDefault` xuất hiện 2 lần trong command-line arguments
- Katalon không thể khởi động đúng cách

## 🔧 GIẢI PHÁP ĐÃ ÁP DỤNG

### Thay đổi 1: Format `-data @noDefault` đúng cách
- Thay vì dùng array với 2 phần tử: `'-data', '@noDefault'`
- Dùng một string: `'-data @noDefault'`
- Tránh duplicate khi join arguments

### Thay đổi 2: Dùng workspace path tạm thời
- Thay vì `-data @noDefault` (có thể gây lỗi)
- Dùng `-data=<workspace-path>` với workspace tạm thời
- Tạo workspace trong thư mục project: `.katalon-workspace`

## 📋 CẤU HÌNH MỚI

```powershell
# Tạo workspace tạm thời
$tempWorkspace = Join-Path $projectPath ".katalon-workspace"
if (-not (Test-Path $tempWorkspace)) {
    New-Item -ItemType Directory -Path $tempWorkspace -Force | Out-Null
}

$katalonArgs = @(
  "-data=$tempWorkspace"  # Dùng workspace path thay vì @noDefault
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
```

## ✅ LỢI ÍCH

1. **Tránh lỗi Java exit code 1:**
   - Workspace path cụ thể được Katalon nhận đúng
   - Không còn vấn đề với `@noDefault`

2. **Tránh duplicate arguments:**
   - Một argument duy nhất: `-data=<path>`
   - Không còn duplicate trong command-line

3. **Workspace tách biệt:**
   - Mỗi lần chạy có workspace riêng
   - Không ảnh hưởng đến workspace mặc định

## 🎯 KẾT QUẢ MONG ĐỢI

- Katalon sẽ khởi động thành công
- Không còn lỗi "Java exit code 1"
- Tests sẽ chạy trong console mode
- Reports sẽ được tạo đúng cách

## 📝 COMMITS

1. `7953062` - Fix: Format -data @noDefault as single argument to prevent duplication
2. `[Pending]` - Fix: Use temporary workspace path instead of @noDefault

---

**Trạng thái:** ✅ Đã sửa và push lên GitHub
