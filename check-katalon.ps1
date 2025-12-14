# Script kiem tra Katalon Studio configuration
# Chay script nay de kiem tra tat ca duong dan, thu muc va cu phap

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "KIEM TRA KATALON STUDIO CONFIGURATION" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Kiem tra Katalon version va duong dan
Write-Host "1. Kiem tra Katalon version va duong dan:" -ForegroundColor Yellow
$katalonHome = "$env:USERPROFILE\.katalon\packages\KSE-10.4.2"
Write-Host "KATALON_HOME: $katalonHome"

if (Test-Path $katalonHome) {
    Write-Host "[OK] Katalon folder ton tai" -ForegroundColor Green
    
    $katalonc = Join-Path $katalonHome "katalonc.exe"
    $katalon = Join-Path $katalonHome "katalon.exe"
    
    if (Test-Path $katalonc) {
        Write-Host "[OK] katalonc.exe ton tai: $katalonc" -ForegroundColor Green
        $versionInfo = (Get-Item $katalonc).VersionInfo
        Write-Host "Version: $($versionInfo.FileVersion)" -ForegroundColor Cyan
        Write-Host "Product Version: $($versionInfo.ProductVersion)" -ForegroundColor Cyan
    }
    elseif (Test-Path $katalon) {
        Write-Host "[WARNING] katalonc.exe khong ton tai, co katalon.exe: $katalon" -ForegroundColor Yellow
        $versionInfo = (Get-Item $katalon).VersionInfo
        Write-Host "Version: $($versionInfo.FileVersion)" -ForegroundColor Cyan
    }
    else {
        Write-Host "[ERROR] Khong tim thay katalonc.exe hoac katalon.exe" -ForegroundColor Red
    }
}
else {
    Write-Host "[ERROR] Katalon folder khong ton tai" -ForegroundColor Red
    Write-Host "Tim kiem Katalon trong toan bo may..." -ForegroundColor Yellow
    $found = Get-ChildItem -Path "C:\" -Filter "katalonc.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        Write-Host "Tim thay: $($found.FullName)" -ForegroundColor Green
    }
    else {
        Write-Host "Khong tim thay katalonc.exe" -ForegroundColor Red
    }
}

Write-Host ""

# 2. Kiem tra Project path
Write-Host "2. Kiem tra Project path:" -ForegroundColor Yellow
$projectPath = "C:\Users\feu29\Katalon Studio\KiemThu"
Write-Host "Project Path: $projectPath"

if (Test-Path $projectPath) {
    Write-Host "[OK] Project folder ton tai" -ForegroundColor Green
    
    $prjFiles = Get-ChildItem -Path $projectPath -Filter "*.prj" -ErrorAction SilentlyContinue
    if ($prjFiles -and $prjFiles.Count -gt 0) {
        Write-Host "[OK] Tim thay project file: $($prjFiles[0].Name)" -ForegroundColor Green
    }
    else {
        Write-Host "[WARNING] Khong tim thay file .prj" -ForegroundColor Yellow
    }
}
else {
    Write-Host "[ERROR] Project folder khong ton tai" -ForegroundColor Red
}

Write-Host ""

# 3. Kiem tra Test Suite
Write-Host "3. Kiem tra Test Suite:" -ForegroundColor Yellow
$testSuitePath = Join-Path $projectPath "Test Suites\UI\Navigation Testcases"
$testSuiteWithExt = "$testSuitePath.ts"
Write-Host "Test Suite Path (khong co .ts): $testSuitePath"
Write-Host "Test Suite Path (co .ts): $testSuiteWithExt"

if (Test-Path $testSuiteWithExt) {
    Write-Host "[OK] Test suite file ton tai" -ForegroundColor Green
    $fileInfo = Get-Item $testSuiteWithExt
    Write-Host "File: $($fileInfo.Name)"
    Write-Host "Size: $($fileInfo.Length) bytes"
    Write-Host "Modified: $($fileInfo.LastWriteTime)"
}
elseif (Test-Path $testSuitePath) {
    Write-Host "[OK] Test suite ton tai (khong co extension)" -ForegroundColor Green
}
else {
    Write-Host "[ERROR] Test suite khong ton tai" -ForegroundColor Red
    Write-Host "Danh sach test suites co san:" -ForegroundColor Yellow
    $testSuitesDir = Join-Path $projectPath "Test Suites"
    if (Test-Path $testSuitesDir) {
        Get-ChildItem -Path $testSuitesDir -Recurse -Filter "*.ts" | ForEach-Object {
            $relativePath = $_.FullName.Replace($projectPath, "").TrimStart("\", "/")
            Write-Host "  - $relativePath"
        }
    }
}

Write-Host ""

# 4. Kiem tra cau truc thu muc
Write-Host "4. Kiem tra cau truc thu muc:" -ForegroundColor Yellow
$folders = @("Test Suites", "Object Repository", "Profiles", "Reports", "Keywords", "Data Files")
foreach ($folder in $folders) {
    $fullPath = Join-Path $projectPath $folder
    if (Test-Path $fullPath) {
        Write-Host "[OK] $folder" -ForegroundColor Green
    }
    else {
        Write-Host "[MISSING] $folder" -ForegroundColor Yellow
    }
}

Write-Host ""

# 5. Kiem tra Reports folder
Write-Host "5. Kiem tra Reports folder:" -ForegroundColor Yellow
$reportsPath = Join-Path $projectPath "Reports"
if (Test-Path $reportsPath) {
    Write-Host "[OK] Reports folder ton tai" -ForegroundColor Green
    $reportFiles = Get-ChildItem -Path $reportsPath -Recurse -File -ErrorAction SilentlyContinue
    Write-Host "So luong report files: $($reportFiles.Count)"
    if ($reportFiles.Count -gt 0) {
        Write-Host "Cac report files gan day:" -ForegroundColor Cyan
        $reportFiles | Sort-Object LastWriteTime -Descending | Select-Object -First 5 | ForEach-Object {
            Write-Host "  - $($_.Name) ($($_.LastWriteTime))"
        }
    }
}
else {
    Write-Host "[INFO] Reports folder chua duoc tao (se duoc tao khi chay test)" -ForegroundColor Gray
}

Write-Host ""

# 6. Kiem tra Profiles
Write-Host "6. Kiem tra Profiles:" -ForegroundColor Yellow
$profilesPath = Join-Path $projectPath "Profiles"
if (Test-Path $profilesPath) {
    Write-Host "[OK] Profiles folder ton tai" -ForegroundColor Green
    $profiles = Get-ChildItem -Path $profilesPath -Filter "*.glbl" -ErrorAction SilentlyContinue
    Write-Host "So luong profiles: $($profiles.Count)"
    $profiles | ForEach-Object {
        Write-Host "  - $($_.Name)"
    }
    
    $defaultProfile = Join-Path $profilesPath "default.glbl"
    if (Test-Path $defaultProfile) {
        Write-Host "[OK] default.glbl ton tai" -ForegroundColor Green
        $content = Get-Content $defaultProfile -Raw
        if ($content -match "g_baseUrl") {
            Write-Host "Tim thay g_baseUrl trong profile" -ForegroundColor Cyan
        }
    }
    else {
        Write-Host "[WARNING] default.glbl khong ton tai" -ForegroundColor Yellow
    }
}
else {
    Write-Host "[ERROR] Profiles folder khong ton tai" -ForegroundColor Red
}

Write-Host ""

# 7. Kiem tra Java
Write-Host "7. Kiem tra Java:" -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    if ($javaVersion) {
        Write-Host "Java: $javaVersion" -ForegroundColor Green
    }
}
catch {
    Write-Host "[WARNING] Java khong tim thay trong PATH" -ForegroundColor Yellow
}

Write-Host ""

# 8. Kiem tra Chrome
Write-Host "8. Kiem tra Chrome:" -ForegroundColor Yellow
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$chromePath86 = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

if (Test-Path $chromePath) {
    $chromeVersion = (Get-Item $chromePath).VersionInfo.FileVersion
    Write-Host "[OK] Chrome ton tai: $chromePath" -ForegroundColor Green
    Write-Host "Version: $chromeVersion" -ForegroundColor Cyan
}
elseif (Test-Path $chromePath86) {
    $chromeVersion = (Get-Item $chromePath86).VersionInfo.FileVersion
    Write-Host "[OK] Chrome ton tai: $chromePath86" -ForegroundColor Green
    Write-Host "Version: $chromeVersion" -ForegroundColor Cyan
}
else {
    Write-Host "[WARNING] Chrome khong tim thay" -ForegroundColor Yellow
}

Write-Host ""

# 9. Kiem tra cu phap lenh Katalon
Write-Host "9. Kiem tra cu phap lenh Katalon:" -ForegroundColor Yellow
$katalonc = Join-Path $katalonHome "katalonc.exe"
$testSuitePathForKatalon = "Test Suites/UI/Navigation Testcases"
$reportFolder = Join-Path $projectPath "Reports"

Write-Host "Lenh se chay:" -ForegroundColor Cyan
Write-Host "Executable: $katalonc"
Write-Host "Project: $projectPath"
Write-Host "Test Suite: $testSuitePathForKatalon"
Write-Host "Report Folder: $reportFolder"
Write-Host ""
Write-Host "Cac tham so:" -ForegroundColor Cyan
Write-Host "  -runMode=console"
Write-Host "  -console"
Write-Host "  -noSplash"
Write-Host "  -consoleLog"
Write-Host "  -projectPath=$projectPath"
Write-Host "  -testSuitePath=$testSuitePathForKatalon"
Write-Host "  -executionProfile=default"
Write-Host "  -browserType=Chrome (headless)"
Write-Host "  -g_baseUrl=http://localhost/CAMNEST/"
Write-Host "  -reportFolder=$reportFolder"
Write-Host "  -retry=0"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "KET THUC KIEM TRA" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
