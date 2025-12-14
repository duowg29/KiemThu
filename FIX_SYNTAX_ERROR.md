# FIX: PowerShell Syntax Error

**Ngày:** 14/12/2025

## ⚠️ LỖI

Từ GitHub Actions log:
- **Line 689:** "Unexpected token '-ErrorAction' in expression or statement"
- **Line 693:** "Unexpected token 'SilentlyContinue' in expression or statement"
- **Exit code:** 1

## 🔍 NGUYÊN NHÂN

Lỗi xảy ra ở dòng này:
```powershell
$childProcesses = Get-Process | Where-Object { $_.Parent.Id -eq $process.Id -ErrorAction SilentlyContinue }
```

**Vấn đề:**
- `-ErrorAction SilentlyContinue` **KHÔNG THỂ** đặt bên trong script block của `Where-Object`
- `-ErrorAction` là parameter của cmdlet, không phải của expression trong script block

## 🔧 GIẢI PHÁP

### Trước (SAI):
```powershell
$childProcesses = Get-Process | Where-Object { $_.Parent.Id -eq $process.Id -ErrorAction SilentlyContinue }
```

### Sau (ĐÚNG):
```powershell
$allProcesses = Get-Process -ErrorAction SilentlyContinue
$childProcesses = $allProcesses | Where-Object {
    try {
        $_.Parent.Id -eq $process.Id
    } catch {
        $false  # Ignore errors when accessing Parent property
    }
}
```

## ✅ GIẢI THÍCH

1. **Đặt `-ErrorAction` ở cmdlet level:**
   - `Get-Process -ErrorAction SilentlyContinue` - Đúng ✅
   - Không đặt trong script block của `Where-Object`

2. **Xử lý lỗi trong script block bằng try-catch:**
   - Nếu `$_.Parent.Id` gây lỗi (process đã exit, không có parent, etc.)
   - Catch và return `$false` để bỏ qua process đó

## 📋 CÁC THAY ĐỔI

- ✅ Sửa syntax error trong child processes check
- ✅ Dùng try-catch để xử lý lỗi khi access Parent property
- ✅ Đặt `-ErrorAction` đúng vị trí (ở cmdlet level)

## ✅ KẾT QUẢ

- ✅ Không còn syntax error
- ✅ Workflow có thể chạy được
- ✅ Child processes check hoạt động đúng

---

**Trạng thái:** ✅ Đã sửa và push lên GitHub
