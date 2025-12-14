# FIX: Katalon Vẫn Mở GUI

**Ngày:** 14/12/2025

## ⚠️ VẤN ĐỀ

Katalon vẫn mở GUI thay vì chạy ở console mode, dù đã có:
- `-runMode=console`
- `-console`
- `-noSplash`
- `-consoleLog`
- `-data=<workspace-path>`
- `CreateNoWindow = $true`

## 🔧 GIẢI PHÁP ĐÃ ÁP DỤNG

### 1. Kill GUI Processes Trước Khi Chạy
```powershell
# Kill tất cả process Katalon GUI đang chạy
Get-Process | Where-Object { 
  $_.ProcessName -like '*katalon*' -and 
  $_.MainWindowTitle -ne '' -and
  $_.Path -notlike '*katalonc.exe*'
} | ForEach-Object {
  Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
}
```

### 2. Chỉ Dùng katalonc.exe (KHÔNG BAO GIỜ dùng katalon.exe)
```powershell
# Nếu không tìm thấy katalonc.exe, exit với lỗi
if (-not (Test-Path $katalonExe)) {
  Write-Host "ERROR: katalonc.exe not found" -ForegroundColor Red
  Write-Host "katalonc.exe is required for console mode. katalon.exe will open GUI." -ForegroundColor Red
  exit 1
}
```

### 3. Thêm WindowStyle Hidden
```powershell
$processInfo.CreateNoWindow = $true
$processInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
```

### 4. Thêm Environment Variable
```powershell
$processInfo.EnvironmentVariables['KATALON_NO_GUI'] = 'true'
```

### 5. Monitor và Kill GUI Nếu Mở Ra
```powershell
# Monitor và kill GUI processes nếu chúng mở ra trong khi chạy
$guiMonitorJob = Start-Job -ScriptBlock {
  # Monitor và kill GUI processes mỗi 5 giây
}
```

## 📋 CẤU HÌNH CUỐI CÙNG

### Arguments:
```
-data=<temp-workspace>
-runMode=console
-console
-noSplash
-consoleLog
-projectPath=<path>
-testSuitePath=<path>
-executionProfile=default
-browserType=Chrome (headless)
-g_baseUrl=<url>
-reportFolder=<path>
-retry=0
```

### Process Settings:
- `CreateNoWindow = $true`
- `WindowStyle = Hidden`
- `UseShellExecute = $false`
- `RedirectStandardOutput = $true`
- `RedirectStandardError = $true`

### Environment Variables:
- `JAVA_OPTS`: Headless settings
- `KATALON_OPTS`: `-noSplash -consoleLog`
- `KATALON_NO_GUI`: `true`

## ✅ KẾT QUẢ MONG ĐỢI

- ✅ Không còn GUI mở ra
- ✅ Katalon chạy hoàn toàn ở console mode
- ✅ Tests chạy và tạo reports
- ✅ `runningMode` = "console"

---

**Trạng thái:** ✅ Đã sửa và push lên GitHub
