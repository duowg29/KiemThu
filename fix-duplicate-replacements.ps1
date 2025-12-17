# Script sửa lỗi do duplicate replacements trong các file đã được cập nhật
# Script này sẽ tìm và sửa các pattern bị lỗi do script trước đã thay thế nhiều lần

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SUA LOI DUPLICATE REPLACEMENTS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Tim tat ca file .groovy co chua pattern loi (co ExtendedKeywords.safeClick nhieu lan trong cung mot dong)
$allFiles = Get-ChildItem -Path "Scripts" -Recurse -Filter "*.groovy" | 
    Where-Object { $_.Name -notlike "*.backup*" }

Write-Host "Tim thay $($allFiles.Count) file can kiem tra" -ForegroundColor Yellow
Write-Host ""

$totalFixed = 0
$totalChecked = 0

foreach ($file in $allFiles) {
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        $wasModified = $false
        
        # Kiem tra xem co pattern loi khong (co ExtendedKeywords.safeClick nhieu lan trong cung mot dong)
        if ($content -match "ExtendedKeywords\.safeClick.*ExtendedKeywords\.safeClick") {
            Write-Host "Tim thay loi trong: $($file.FullName)" -ForegroundColor Yellow
            
            # Doc file backup neu co
            $backupFile = $file.FullName + ".backup"
            if (Test-Path $backupFile) {
                Write-Host "  Doc file backup..." -ForegroundColor Gray
                $backupContent = Get-Content $backupFile -Raw -Encoding UTF8
                
                # Thay the toan bo noi dung bang backup, sau do ap dung lai thay doi DUNG
                $content = $backupContent
                
                # 1. Them import ExtendedKeywords neu chua co
                if ($content -notmatch "import com\.kms\.katalon\.keyword\.WebUIExtendedKeywords") {
                    if ($content -match "(import com\.kms\.katalon\.core\.webui\.keyword\.WebUiBuiltInKeywords as WebUI)") {
                        $content = $content -replace "(import com\.kms\.katalon\.core\.webui\.keyword\.WebUiBuiltInKeywords as WebUI)", "`$1`nimport com.kms.katalon.keyword.WebUIExtendedKeywords as ExtendedKeywords"
                        $wasModified = $true
                    }
                }
                
                # 2. Xu ly login icon - thay the WebUI.click voi login icon bang safeClickLoginIcon
                $loginIconPattern = "WebUI\.click\(findTestObject\('([^']*i_Contact_fas fa-user[^']*)'\)\)"
                if ($content -match $loginIconPattern) {
                    $content = $content -replace $loginIconPattern, "ExtendedKeywords.safeClickLoginIcon(findTestObject('`$1'))"
                    $wasModified = $true
                }
                
                # 3. Thay the cac WebUI.click() khac bang safeClick() - TUNG DONG MOT
                # Tim tat ca cac dong co WebUI.click(findTestObject va thay the tung dong
                $lines = $content -split "`n"
                $newLines = @()
                
                foreach ($line in $lines) {
                    $newLine = $line
                    
                    # Bo qua neu da co ExtendedKeywords
                    if ($line -match "ExtendedKeywords\.") {
                        $newLines += $newLine
                        continue
                    }
                    
                    # Thay the WebUI.click(findTestObject(...)) bang ExtendedKeywords.safeClick(findTestObject(...))
                    if ($line -match "WebUI\.click\(findTestObject\('([^']+)'\)(?:,\s*[^)]+)?\)") {
                        # Chi thay the mot lan trong dong nay
                        $newLine = $line -replace "WebUI\.click\(findTestObject\('([^']+)'\)(?:,\s*[^)]+)?\)", "ExtendedKeywords.safeClick(findTestObject('`$1'))"
                        $wasModified = $true
                    }
                    
                    $newLines += $newLine
                }
                
                $content = $newLines -join "`n"
                
                if ($wasModified) {
                    # Ghi lai file
                    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
                    [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
                    $totalFixed++
                    Write-Host "  Fixed: $($file.FullName)" -ForegroundColor Green
                }
            } else {
                Write-Host "  WARNING: Khong tim thay file backup, khong the sua!" -ForegroundColor Red
            }
        }
        
        $totalChecked++
    } catch {
        Write-Host "Error processing $($file.FullName): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "COMPLETED" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Checked: $totalChecked files" -ForegroundColor Cyan
Write-Host "Fixed: $totalFixed files" -ForegroundColor Green
Write-Host ""
