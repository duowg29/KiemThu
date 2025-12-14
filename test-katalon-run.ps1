# Script test chay Katalon de kiem tra output
# Script nay se chay Katalon va hien thi tat ca output

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TEST CHAY KATALON STUDIO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Cac duong dan
$katalonHome = "$env:USERPROFILE\.katalon\packages\KSE-10.4.2"
$katalonc = Join-Path $katalonHome "katalonc.exe"
$projectPath = "C:\Users\feu29\Katalon Studio\KiemThu"
$testSuitePath = "Test Suites/UI/Navigation Testcases"
$reportFolder = Join-Path $projectPath "Reports"
$baseUrl = "http://localhost/CAMNEST/"

# Kiem tra file ton tai
if (-not (Test-Path $katalonc)) {
    Write-Host "[ERROR] katalonc.exe khong ton tai: $katalonc" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $projectPath)) {
    Write-Host "[ERROR] Project path khong ton tai: $projectPath" -ForegroundColor Red
    exit 1
}

# Tao Reports folder neu chua co
if (-not (Test-Path $reportFolder)) {
    New-Item -ItemType Directory -Path $reportFolder -Force | Out-Null
    Write-Host "[INFO] Da tao Reports folder" -ForegroundColor Green
}

# Set environment variables
$env:JAVA_OPTS = "-Djava.awt.headless=true -Dorg.eclipse.swt.browser.DefaultType=none -Dkatalon.webview.enabled=false -Dorg.eclipse.swt.browser.chromium.enabled=false -Declipse.e4.inject.javax.disabled=true"
$env:KATALON_OPTS = "-noSplash -consoleLog"

Write-Host "Environment variables:" -ForegroundColor Yellow
Write-Host "JAVA_OPTS: $env:JAVA_OPTS"
Write-Host "KATALON_OPTS: $env:KATALON_OPTS"
Write-Host ""

# Xay dung lenh
$katalonArgs = @(
    "-runMode=console"
    "-console"
    "-noSplash"
    "-consoleLog"
    "-projectPath=$projectPath"
    "-testSuitePath=$testSuitePath"
    "-executionProfile=default"
    "-browserType=Chrome (headless)"
    "-g_baseUrl=$baseUrl"
    "-reportFolder=$reportFolder"
    "-retry=0"
)

Write-Host "Chuan bi chay Katalon..." -ForegroundColor Yellow
Write-Host "Executable: $katalonc"
Write-Host "Project: $projectPath"
Write-Host "Test Suite: $testSuitePath"
Write-Host "Report Folder: $reportFolder"
Write-Host "Base URL: $baseUrl"
Write-Host ""
Write-Host "Lenh day du:" -ForegroundColor Cyan
Write-Host "$katalonc $($katalonArgs -join ' ')"
Write-Host ""
Write-Host "Bat dau chay (co the mat nhieu thoi gian)..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Chuyen den thu muc project
Push-Location $projectPath

try {
    # Chay Katalon va capture output
    $startTime = Get-Date
    Write-Host "[$($startTime.ToString('HH:mm:ss'))] Starting Katalon process..." -ForegroundColor Green
    
    # Chay va capture output real-time
    $process = Start-Process -FilePath $katalonc -ArgumentList $katalonArgs -NoNewWindow -PassThru -RedirectStandardOutput "output.txt" -RedirectStandardError "error.txt" -WorkingDirectory $projectPath
    
    Write-Host "[$($startTime.ToString('HH:mm:ss'))] Process started (PID: $($process.Id))" -ForegroundColor Green
    Write-Host "Dang cho process hoan thanh..." -ForegroundColor Yellow
    Write-Host ""
    
    # Doi process hoan thanh (toi da 10 phut)
    $timeout = 600  # 10 phut
    $elapsed = 0
    while (-not $process.HasExited -and $elapsed -lt $timeout) {
        Start-Sleep -Seconds 5
        $elapsed += 5
        
        # Hien thi output real-time neu co
        if (Test-Path "output.txt") {
            $newOutput = Get-Content "output.txt" -Tail 5 -ErrorAction SilentlyContinue
            if ($newOutput) {
                $newOutput | ForEach-Object { Write-Host $_ }
            }
        }
        
        # Status update moi 30 giay
        if ($elapsed % 30 -eq 0) {
            $minutes = [int]($elapsed / 60)
            $seconds = $elapsed % 60
            Write-Host "[$((Get-Date).ToString('HH:mm:ss'))] Still running... (${minutes}m ${seconds}s)" -ForegroundColor Gray
        }
    }
    
    if (-not $process.HasExited) {
        Write-Host "[WARNING] Process chua hoan thanh sau $timeout giay. Dang kill process..." -ForegroundColor Yellow
        $process.Kill()
        $exitCode = 1
    }
    else {
        $exitCode = $process.ExitCode
        $endTime = Get-Date
        $duration = $endTime - $startTime
        Write-Host ""
        Write-Host "[$($endTime.ToString('HH:mm:ss'))] Process completed" -ForegroundColor Green
        Write-Host "Exit code: $exitCode"
        Write-Host "Duration: $([int]$duration.TotalMinutes)m $([int]$duration.TotalSeconds % 60)s"
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "OUTPUT:" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    
    # Hien thi output
    if (Test-Path "output.txt") {
        Write-Host "Standard Output:" -ForegroundColor Yellow
        $output = Get-Content "output.txt" -ErrorAction SilentlyContinue
        if ($output) {
            $output | ForEach-Object { Write-Host $_ }
        }
        else {
            Write-Host "(Khong co output)" -ForegroundColor Gray
        }
    }
    
    Write-Host ""
    
    # Hien thi errors
    if (Test-Path "error.txt") {
        Write-Host "Standard Error:" -ForegroundColor Yellow
        $errors = Get-Content "error.txt" -ErrorAction SilentlyContinue
        if ($errors) {
            $errors | ForEach-Object { Write-Host $_ -ForegroundColor Red }
        }
        else {
            Write-Host "(Khong co errors)" -ForegroundColor Gray
        }
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "KET THUC TEST" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Exit code: $exitCode" -ForegroundColor $(if ($exitCode -eq 0) { "Green" } else { "Red" })
    
    # Cleanup
    if (Test-Path "output.txt") { Remove-Item "output.txt" -ErrorAction SilentlyContinue }
    if (Test-Path "error.txt") { Remove-Item "error.txt" -ErrorAction SilentlyContinue }
}
catch {
    Write-Host ""
    Write-Host "[ERROR] Exception occurred:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Red
    $exitCode = 1
}
finally {
    Pop-Location
}

exit $exitCode
