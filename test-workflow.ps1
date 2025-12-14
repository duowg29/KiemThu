# Script test workflow configuration
# Simulate what GitHub Actions runner sẽ làm

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TEST WORKFLOW CONFIGURATION" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Simulate GitHub Actions environment
$env:GITHUB_WORKSPACE = "C:\Users\feu29\Katalon Studio\KiemThu"
$PWD = $env:GITHUB_WORKSPACE

# Đường dẫn Katalon
$KATALON_HOME = "$env:USERPROFILE\.katalon\packages\KSE-10.4.2"

if (-not (Test-Path "$KATALON_HOME\katalon.exe")) {
    Write-Host "Katalon not found at $KATALON_HOME" -ForegroundColor Red
    exit 1
}

# Ưu tiên dùng katalonc.exe (console-only, không mở GUI)
$katalonExe = "$KATALON_HOME\katalonc.exe"
if (-not (Test-Path $katalonExe)) {
    Write-Host "katalonc.exe not found, using katalon.exe instead" -ForegroundColor Yellow
    $katalonExe = "$KATALON_HOME\katalon.exe"
} else {
    Write-Host "Using katalonc.exe (console-only mode)" -ForegroundColor Green
}

# Test suite và paths
$testSuitePath = "Test Suites/UI/Navigation Testcases"
$projectPath = $PWD -replace '\\', '/'
$reportFolder = "$PWD\Reports" -replace '\\', '/'
$baseUrl = "http://localhost/CAMNEST/"

# Validate project path
if (-not (Test-Path $projectPath)) {
    Write-Host "ERROR: Project path does not exist: $projectPath" -ForegroundColor Red
    exit 1
}

# Tìm test suite file
$testSuiteFullPath = Join-Path $projectPath $testSuitePath
$testSuiteWithExt = "$testSuiteFullPath.ts"

if (Test-Path $testSuiteWithExt) {
    $testSuiteFullPath = $testSuiteWithExt
    Write-Host "Found test suite with .ts extension: $testSuiteFullPath" -ForegroundColor Green
} elseif (Test-Path $testSuiteFullPath) {
    Write-Host "Found test suite without extension: $testSuiteFullPath" -ForegroundColor Green
} else {
    Write-Host "ERROR: Test suite path does not exist: $testSuiteFullPath" -ForegroundColor Red
    exit 1
}

# Format test suite path cho Katalon (relative path, không có extension .ts)
$testSuitePathFormatted = $testSuitePath -replace '\\', '/'
if ($testSuitePathFormatted.EndsWith('.ts')) {
    $testSuitePathFormatted = $testSuitePathFormatted.Substring(0, $testSuitePathFormatted.Length - 3)
}

# Tạo thư mục Reports
if (-not (Test-Path "Reports")) {
    New-Item -ItemType Directory -Path "Reports" -Force | Out-Null
}

Write-Host "=========================================="
Write-Host "Running Katalon tests..."
Write-Host "Project: $projectPath"
Write-Host "Test Suite (for Katalon): $testSuitePathFormatted"
Write-Host "Test Suite File Path: $testSuiteFullPath"
Write-Host "Katalon Executable: $katalonExe"
Write-Host "Report Folder: $reportFolder"
Write-Host "Base URL: $baseUrl"
Write-Host "=========================================="

# Set environment variables
$env:JAVA_OPTS = '-Djava.awt.headless=true -Dorg.eclipse.swt.browser.DefaultType=none -Dkatalon.webview.enabled=false -Dorg.eclipse.swt.browser.chromium.enabled=false -Declipse.e4.inject.javax.disabled=true'
$env:KATALON_OPTS = '-noSplash -consoleLog'

Write-Host "Environment variables set:"
Write-Host "JAVA_OPTS: $env:JAVA_OPTS"
Write-Host "KATALON_OPTS: $env:KATALON_OPTS"
Write-Host ""

# Xây dựng lệnh Katalon
$katalonArgs = @(
    '-runMode=console'
    '-console'
    '-noSplash'
    '-consoleLog'
    '-data', '@noDefault'
    "-projectPath=$projectPath"
    "-testSuitePath=$testSuitePathFormatted"
    '-executionProfile=default'
    '-browserType=Chrome (headless)'
    "-g_baseUrl=$baseUrl"
    "-reportFolder=$reportFolder"
    '-retry=0'
)

Write-Host "Starting Katalon execution..."
Write-Host "Command: $katalonExe $($katalonArgs -join ' ')"
Write-Host ""

# Chuyển đến thư mục project
Push-Location $projectPath

try {
    Write-Host "Launching Katalon process from: $projectPath" -ForegroundColor Green
    Write-Host "Starting Katalon execution (headless mode - NO GUI)..." -ForegroundColor Yellow
    Write-Host ""
    
    # Dùng Start-Process với CreateNoWindow
    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = $katalonExe
    $processInfo.Arguments = $katalonArgs -join ' '
    $processInfo.UseShellExecute = $false
    $processInfo.RedirectStandardOutput = $true
    $processInfo.RedirectStandardError = $true
    $processInfo.CreateNoWindow = $true
    $processInfo.WorkingDirectory = $projectPath
    
    # Set environment variables
    $processInfo.EnvironmentVariables['JAVA_OPTS'] = $env:JAVA_OPTS
    $processInfo.EnvironmentVariables['KATALON_OPTS'] = $env:KATALON_OPTS
    
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $processInfo
    
    # Capture output
    $outputBuilder = New-Object System.Text.StringBuilder
    $errorBuilder = New-Object System.Text.StringBuilder
    
    $outputEvent = Register-ObjectEvent -InputObject $process -EventName OutputDataReceived -Action {
        if ($EventArgs.Data) {
            [void]$Event.MessageData.AppendLine($EventArgs.Data)
            Write-Host $EventArgs.Data -ForegroundColor Cyan
        }
    } -MessageData $outputBuilder
    
    $errorEvent = Register-ObjectEvent -InputObject $process -EventName ErrorDataReceived -Action {
        if ($EventArgs.Data) {
            [void]$Event.MessageData.AppendLine($EventArgs.Data)
            Write-Host $EventArgs.Data -ForegroundColor Red
        }
    } -MessageData $errorBuilder
    
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Starting process..." -ForegroundColor Green
    
    $process.Start() | Out-Null
    $process.BeginOutputReadLine()
    $process.BeginErrorReadLine()
    
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Process started (PID: $($process.Id))" -ForegroundColor Green
    Write-Host "Waiting for process to complete (max 5 minutes for test)..." -ForegroundColor Yellow
    Write-Host ""
    
    # Đợi process hoàn thành (timeout 5 phút cho test)
    $process.WaitForExit(300000)
    
    # Cleanup events
    Unregister-Event -SourceIdentifier $outputEvent.Name -ErrorAction SilentlyContinue
    Unregister-Event -SourceIdentifier $errorEvent.Name -ErrorAction SilentlyContinue
    
    if (-not $process.HasExited) {
        Write-Host "[WARNING] Process did not complete in 5 minutes. Killing..." -ForegroundColor Yellow
        $process.Kill()
        $exitCode = 1
    } else {
        $exitCode = $process.ExitCode
        Write-Host ""
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Process completed" -ForegroundColor Green
        Write-Host "Exit code: $exitCode" -ForegroundColor $(if ($exitCode -eq 0) { "Green" } else { "Red" })
    }
    
    # Kiểm tra report mới
    Start-Sleep -Seconds 2
    $reportsPath = Join-Path $projectPath "Reports"
    if (Test-Path $reportsPath) {
        $latestReport = Get-ChildItem -Path $reportsPath -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($latestReport -and $latestReport.LastWriteTime -gt (Get-Date).AddMinutes(-10)) {
            Write-Host ""
            Write-Host "[OK] New report created: $($latestReport.Name)" -ForegroundColor Green
            Write-Host "Time: $($latestReport.LastWriteTime)" -ForegroundColor Cyan
        }
    }
    
} catch {
    Write-Host ""
    Write-Host "[ERROR] Exception occurred:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    $exitCode = 1
} finally {
    Pop-Location
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TEST COMPLETED" -ForegroundColor Cyan
Write-Host "Exit code: $exitCode" -ForegroundColor $(if ($exitCode -eq 0) { "Green" } else { "Red" })
Write-Host "========================================" -ForegroundColor Cyan

exit $exitCode
