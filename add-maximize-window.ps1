# Script để thêm WebUI.maximizeWindow() vào tất cả test suites
# Script này sẽ:
# 1. Kích hoạt @SetupTestCase (đổi skipped = true thành skipped = false)
# 2. Thêm WebUI.maximizeWindow() vào method setupTestCase()

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Adding WebUI.maximizeWindow() to all test suites" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Tìm tất cả file .groovy trong Test Suites
$testSuiteFiles = Get-ChildItem -Path "Test Suites" -Recurse -Filter "*.groovy" -ErrorAction SilentlyContinue

if (-not $testSuiteFiles) {
    Write-Host "ERROR: No .groovy test suite files found in Test Suites folder" -ForegroundColor Red
    exit 1
}

Write-Host "Found $($testSuiteFiles.Count) test suite file(s)" -ForegroundColor Green
Write-Host ""

$updatedCount = 0
$skippedCount = 0

foreach ($file in $testSuiteFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Yellow
    
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        
        # Kiểm tra xem đã có WebUI.maximizeWindow() chưa
        if ($content -match 'WebUI\.maximizeWindow\(\)') {
            Write-Host "  Already has WebUI.maximizeWindow() - skipping" -ForegroundColor Gray
            $skippedCount++
            continue
        }
        
        $originalContent = $content
        $modified = $false
        
        # 1. Kích hoạt @SetupTestCase: đổi skipped = true thành skipped = false
        if ($content -match '@SetupTestCase\(skipped\s*=\s*true\)') {
            $content = $content -replace '@SetupTestCase\(skipped\s*=\s*true\)', '@SetupTestCase(skipped = false)'
            $modified = $true
            Write-Host "  Activated @SetupTestCase" -ForegroundColor Green
        }
        
        # 2. Thêm WebUI.maximizeWindow() vào method setupTestCase()
        # Tìm method setupTestCase() và thêm code vào
        if ($content -match 'def setupTestCase\(\)\s*\{[^}]*// Put your code here\.') {
            # Thay thế comment bằng code maximize window
            $content = $content -replace '(def setupTestCase\(\)\s*\{[^\r\n]*\r?\n\s*)// Put your code here\.', "`$1`tWebUI.maximizeWindow()`r`n"
            $modified = $true
            Write-Host "  Added WebUI.maximizeWindow() to setupTestCase()" -ForegroundColor Green
        } elseif ($content -match 'def setupTestCase\(\)\s*\{') {
            # Nếu method đã có code khác, thêm vào đầu method
            $content = $content -replace '(def setupTestCase\(\)\s*\{)', "`$1`r`n`tWebUI.maximizeWindow()`r`n"
            $modified = $true
            Write-Host "  Added WebUI.maximizeWindow() to setupTestCase()" -ForegroundColor Green
        }
        
        if ($modified) {
            # Lưu file với UTF-8 encoding
            $utf8NoBom = New-Object System.Text.UTF8Encoding $false
            [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
            Write-Host "  Updated successfully" -ForegroundColor Green
            $updatedCount++
        } else {
            Write-Host "  No changes needed (may already be configured)" -ForegroundColor Gray
            $skippedCount++
        }
        
    } catch {
        Write-Host "  ERROR: Failed to process file" -ForegroundColor Red
        Write-Host "    Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
}

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Updated: $updatedCount file(s)" -ForegroundColor Green
Write-Host "  Skipped: $skippedCount file(s)" -ForegroundColor Yellow
Write-Host "  Total: $($testSuiteFiles.Count) file(s)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

if ($updatedCount -gt 0) {
    Write-Host ""
    Write-Host "SUCCESS: WebUI.maximizeWindow() has been added to $updatedCount test suite(s)" -ForegroundColor Green
    Write-Host "The maximize window command will run before each test case in these suites." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "INFO: No files were updated. All test suites may already have WebUI.maximizeWindow()" -ForegroundColor Yellow
}

