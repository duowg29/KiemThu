# Script tu dong sua tat ca test cases de su dung safeClick thay vi WebUI.click khong an toan
# Script nay se:
# 1. Them import ExtendedKeywords vao cac file chua co
# 2. Thay the WebUI.click() bang ExtendedKeywords.safeClick()
# 3. Dac biet xu ly login icon voi safeClickLoginIcon()

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SUA TAT CA TEST CASES DE SU DUNG SAFE CLICK" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Tim tat ca file .groovy trong thu muc Scripts (loai tru .backup)
$allFiles = Get-ChildItem -Path "Scripts" -Recurse -Filter "*.groovy" | 
    Where-Object { $_.Name -notlike "*.backup*" }

Write-Host "Tim thay $($allFiles.Count) file test case can kiem tra" -ForegroundColor Yellow
Write-Host ""

$totalUpdated = 0
$totalSkipped = 0
$errorCount = 0

foreach ($file in $allFiles) {
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        $wasModified = $false
        
        # Kiem tra xem file co chua WebUI.click khong
        if ($content -notmatch "WebUI\.click\(findTestObject") {
            # File khong co WebUI.click, bo qua
            continue
        }
        
        # 1. Them import ExtendedKeywords neu chua co
        if ($content -notmatch "import com\.kms\.katalon\.keyword\.WebUIExtendedKeywords") {
            # Tim vi tri de them import (sau dong import WebUI)
            if ($content -match "(import com\.kms\.katalon\.core\.webui\.keyword\.WebUiBuiltInKeywords as WebUI)") {
                $content = $content -replace "(import com\.kms\.katalon\.core\.webui\.keyword\.WebUiBuiltInKeywords as WebUI)", "`$1`nimport com.kms.katalon.keyword.WebUIExtendedKeywords as ExtendedKeywords"
                $wasModified = $true
            }
        }
        
        # 2. Xu ly login icon - thay the WebUI.click voi login icon bang safeClickLoginIcon
        # Pattern: WebUI.click(findTestObject('...i_Contact_fas fa-user...'))
        $loginIconPattern = "WebUI\.click\(findTestObject\('([^']*i_Contact_fas fa-user[^']*)'\)\)"
        if ($content -match $loginIconPattern) {
            $content = $content -replace $loginIconPattern, "ExtendedKeywords.safeClickLoginIcon(findTestObject('`$1'))"
            $wasModified = $true
        }
        
        # 3. Thay the cac WebUI.click() khac bang safeClick()
        # Luu y: Can thay the tu cuoi len dau de khong lam sai index khi thay nhieu lan
        # Tim tat ca matches va sap xep theo index giam dan
        $allMatches = [regex]::Matches($content, "WebUI\.click\(findTestObject\('([^']+)'\)(?:,\s*[^)]+)?\)")
        $matchesToReplace = @()
        
        foreach ($match in $allMatches) {
            $fullMatch = $match.Value
            
            # Bo qua neu da duoc thay the (co ExtendedKeywords)
            if ($fullMatch -match "ExtendedKeywords\.") {
                continue
            }
            
            # Bo qua neu la login icon (da xu ly o buoc 2)
            if ($fullMatch -match "i_Contact_fas fa-user") {
                continue
            }
            
            $matchesToReplace += @{
                Index = $match.Index
                Length = $match.Length
                Value = $fullMatch
            }
        }
        
        # Sap xep theo index giam dan de thay the tu cuoi len
        $matchesToReplace = $matchesToReplace | Sort-Object -Property Index -Descending
        
        # Thay the tu cuoi len
        foreach ($matchInfo in $matchesToReplace) {
            $fullMatch = $matchInfo.Value
            # Thay the WebUI.click bang ExtendedKeywords.safeClick
            $newClick = $fullMatch -replace "WebUI\.click\(", "ExtendedKeywords.safeClick("
            $content = $content.Substring(0, $matchInfo.Index) + $newClick + $content.Substring($matchInfo.Index + $matchInfo.Length)
            $wasModified = $true
        }
        
        # Ghi lai file neu co thay doi
        if ($wasModified) {
            # Dam bao encoding UTF-8
            $utf8NoBom = New-Object System.Text.UTF8Encoding $false
            [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
            $totalUpdated++
            Write-Host "Updated: $($file.FullName)" -ForegroundColor Green
        } else {
            $totalSkipped++
        }
        
    } catch {
        $errorCount++
        Write-Host "Error processing $($file.FullName): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "COMPLETED" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Updated: $totalUpdated files" -ForegroundColor Green
Write-Host "Skipped: $totalSkipped files" -ForegroundColor Yellow
Write-Host "Errors: $errorCount files" -ForegroundColor $(if ($errorCount -eq 0) { "Green" } else { "Red" })
Write-Host ""

if ($errorCount -eq 0) {
    Write-Host "All test cases have been updated successfully!" -ForegroundColor Green
    Write-Host "Please check and run tests to ensure everything works correctly." -ForegroundColor Yellow
} else {
    Write-Host "Some errors occurred. Please check the files with errors." -ForegroundColor Red
}
