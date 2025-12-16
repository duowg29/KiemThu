# Script de them WebUI.maximizeWindow() vao tat ca test cases
# Script nay se tu dong them maximizeWindow() sau openBrowser va navigateToUrl

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Adding WebUI.maximizeWindow() to all test cases" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Tim tat ca file .groovy trong Scripts
$testCaseFiles = Get-ChildItem -Path "Scripts" -Recurse -Filter "*.groovy" -ErrorAction SilentlyContinue

if (-not $testCaseFiles) {
    Write-Host "ERROR: No .groovy test case files found in Scripts folder" -ForegroundColor Red
    exit 1
}

Write-Host "Found $($testCaseFiles.Count) test case file(s)" -ForegroundColor Green
Write-Host ""

$updatedCount = 0
$skippedCount = 0

foreach ($file in $testCaseFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Yellow
    
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        $modified = $false
        
        # 1. Them maximizeWindow() sau openBrowser neu chua co
        if ($content -match 'WebUI\.openBrowser\(''\)') {
            # Kiem tra xem da co maximizeWindow() ngay sau openBrowser chua
            $hasMaximizeAfterOpen = $content -match 'WebUI\.openBrowser\(''\)\s*\r?\n\s*WebUI\.maximizeWindow\(\)'
            if (-not $hasMaximizeAfterOpen) {
                # Them maximizeWindow() sau openBrowser
                $content = $content -replace '(WebUI\.openBrowser\(''\))\s*(\r?\n)', "`$1`$2`tWebUI.maximizeWindow()`$2"
                $modified = $true
                Write-Host "  [OK] Added maximizeWindow() after openBrowser()" -ForegroundColor Green
            } else {
                Write-Host "  [SKIP] Already has maximizeWindow() after openBrowser()" -ForegroundColor Gray
            }
        }
        
        # 2. Them maximizeWindow() sau navigateToUrl neu chua co
        if ($content -match 'WebUI\.navigateToUrl\(') {
            # Kiem tra xem da co maximizeWindow() ngay sau navigateToUrl chua
            $hasMaximizeAfterNavigate = $content -match 'WebUI\.navigateToUrl\([^)]+\)\s*\r?\n\s*WebUI\.maximizeWindow\(\)'
            if (-not $hasMaximizeAfterNavigate) {
                # Them maximizeWindow() sau navigateToUrl
                $content = $content -replace '(WebUI\.navigateToUrl\([^)]+\))\s*(\r?\n)', "`$1`$2`tWebUI.maximizeWindow()`$2"
                $modified = $true
                Write-Host "  [OK] Added maximizeWindow() after navigateToUrl()" -ForegroundColor Green
            } else {
                Write-Host "  [SKIP] Already has maximizeWindow() after navigateToUrl()" -ForegroundColor Gray
            }
        }
        
        if ($modified) {
            # Backup file goc
            $backupFile = $file.FullName + ".backup"
            Copy-Item $file.FullName -Destination $backupFile -Force
            Write-Host "  Created backup: $($file.Name).backup" -ForegroundColor Gray
            
            # Ghi file moi
            [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
            $updatedCount++
            Write-Host "  [SUCCESS] Updated successfully" -ForegroundColor Green
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
Write-Host "  Updated: $updatedCount file(s)" -ForegroundColor Green
Write-Host "  Skipped: $skippedCount file(s)" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Cyan
