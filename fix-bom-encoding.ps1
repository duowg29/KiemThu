# Script de xoa BOM (Byte Order Mark) khoi tat ca file .groovy
# BOM gay ra loi compilation trong Katalon

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Removing BOM from all Groovy files" -ForegroundColor Cyan
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
        # Doc file voi UTF8 encoding (co the co BOM)
        $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
        
        # Kiem tra xem co BOM khong (3 bytes: EF BB BF)
        $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
        $hasBOM = ($bytes.Length -ge 3) -and ($bytes[0] -eq 0xEF) -and ($bytes[1] -eq 0xBB) -and ($bytes[2] -eq 0xBF)
        
        if ($hasBOM) {
            # Xoa BOM: bo qua 3 bytes dau tien
            $contentWithoutBOM = $content
            # Neu content bat dau voi BOM character (U+FEFF), xoa no
            if ($content.Length -gt 0 -and [char]::ConvertFromUtf32(0xFEFF) -eq $content[0]) {
                $contentWithoutBOM = $content.Substring(1)
            }
            
            # Ghi lai file KHONG CO BOM (UTF-8 without BOM)
            # Dung UTF8Encoding voi encoderShouldEmitUTF8Identifier = false
            $utf8NoBom = New-Object System.Text.UTF8Encoding $false
            [System.IO.File]::WriteAllText($file.FullName, $contentWithoutBOM, $utf8NoBom)
            
            $fixedCount++
            Write-Host "  [FIX] Removed BOM from file" -ForegroundColor Green
        } else {
            # Dam bao file khong co BOM bang cach ghi lai voi UTF8Encoding(false)
            $utf8NoBom = New-Object System.Text.UTF8Encoding $false
            [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
            
            $skippedCount++
            Write-Host "  [OK] No BOM found, ensured UTF-8 without BOM" -ForegroundColor Gray
        }
        
    } catch {
        Write-Host "  [ERROR] $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
}

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Fixed (removed BOM): $fixedCount file(s)" -ForegroundColor Green
Write-Host "  Ensured (no BOM): $skippedCount file(s)" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Cyan

