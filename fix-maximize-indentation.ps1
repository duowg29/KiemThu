# Script de sua lai indentation cho WebUI.maximizeWindow()
# Loai bo tab characters va dam bao format dung

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Fixing indentation for maximizeWindow()" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Tim tat ca file .groovy trong Scripts (khong bao gom backup)
$testCaseFiles = Get-ChildItem -Path "Scripts" -Recurse -Filter "*.groovy" -ErrorAction SilentlyContinue | 
                 Where-Object { $_.Name -notlike "*.backup" }

if (-not $testCaseFiles) {
    Write-Host "ERROR: No .groovy test case files found" -ForegroundColor Red
    exit 1
}

Write-Host "Found $($testCaseFiles.Count) test case file(s)" -ForegroundColor Green
Write-Host ""

$fixedCount = 0
$skippedCount = 0

foreach ($file in $testCaseFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Yellow
    
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        $modified = $false
        
        # Tim va sua cac dong co tab truoc maximizeWindow()
        # Pattern: co tab hoac nhieu spaces truoc WebUI.maximizeWindow()
        if ($content -match '[\t]+WebUI\.maximizeWindow\(\)') {
            # Thay tab bang khong co indentation (chi co newline)
            $content = $content -replace '[\t]+WebUI\.maximizeWindow\(\)', "WebUI.maximizeWindow()"
            $modified = $true
            Write-Host "  [FIX] Removed tab before maximizeWindow()" -ForegroundColor Green
        }
        
        # Dam bao co newline truoc va sau maximizeWindow() (neu chua co)
        # Pattern: navigateToUrl... maximizeWindow() click...
        if ($content -match 'WebUI\.navigateToUrl\([^)]+\)\s+WebUI\.maximizeWindow\(\)\s+WebUI\.') {
            # Them newline truoc va sau maximizeWindow()
            $content = $content -replace '(WebUI\.navigateToUrl\([^)]+\))\s+(WebUI\.maximizeWindow\(\))\s+(WebUI\.)', "`$1`r`n`r`n`$2`r`n`r`n`$3"
            $modified = $true
            Write-Host "  [FIX] Added newlines around maximizeWindow()" -ForegroundColor Green
        }
        
        # Dam bao khong co tab trong toan bo file (thay bang spaces hoac xoa)
        if ($content -match '\t') {
            # Thay tat ca tab bang khong co gi (xoa tab)
            $content = $content -replace '\t', ''
            $modified = $true
            Write-Host "  [FIX] Removed all tab characters" -ForegroundColor Green
        }
        
        if ($modified) {
            # Ghi file moi
            [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
            $fixedCount++
            Write-Host "  [SUCCESS] Fixed successfully" -ForegroundColor Green
        } else {
            $skippedCount++
            Write-Host "  [SKIP] No changes needed" -ForegroundColor Gray
        }
        
    } catch {
        Write-Host "  [ERROR] $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
}

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Fixed: $fixedCount file(s)" -ForegroundColor Green
Write-Host "  Skipped: $skippedCount file(s)" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Cyan

