# Script de wrap WebUI.maximizeWindow() trong try-catch de tranh loi trong headless mode

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Wrapping maximizeWindow() calls safely" -ForegroundColor Cyan
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

$updatedCount = 0
$skippedCount = 0

foreach ($file in $testCaseFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Yellow
    
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        $modified = $false
        
        # Tim cac dong co WebUI.maximizeWindow() khong nam trong try-catch
        # Pattern: WebUI.maximizeWindow() khong co try-catch xung quanh
        # Chi wrap neu chua co try-catch
        
        # Pattern 1: WebUI.maximizeWindow() tren mot dong rieng
        if ($content -match '(?<!try\s*\{[^}]*)\r?\n\s*WebUI\.maximizeWindow\(\)\s*\r?\n(?!\s*catch)') {
            # Wrap trong try-catch
            $content = $content -replace '(\r?\n)(\s*)(WebUI\.maximizeWindow\(\))(\s*\r?\n)', "`$1`$2try {`$1`$2`t`$3`$1`$2} catch (Exception e) {`$1`$2`t// Ignore in headless mode`$1`$2}`$4"
            $modified = $true
            Write-Host "  [FIX] Wrapped maximizeWindow() in try-catch" -ForegroundColor Green
        }
        
        # Pattern 2: WebUI.maximizeWindow() sau navigateToUrl hoac openBrowser (da co trong code)
        # Chi can wrap neu chua co try-catch
        if ($content -match 'WebUI\.(navigateToUrl|openBrowser)\([^)]+\)\s*\r?\n\s*WebUI\.maximizeWindow\(\)') {
            # Kiem tra xem da co try-catch chua
            if (-not ($content -match 'WebUI\.(navigateToUrl|openBrowser)\([^)]+\)\s*\r?\n\s*try\s*\{[^}]*WebUI\.maximizeWindow\(\)')) {
                # Wrap trong try-catch
                $content = $content -replace '(WebUI\.(navigateToUrl|openBrowser)\([^)]+\))\s*(\r?\n)\s*(WebUI\.maximizeWindow\(\))', "`$1`$3`$3`t`$3try {`$3`t`t`$4`$3`t} catch (Exception e) {`$3`t`t// Ignore in headless mode`$3`t}"
                $modified = $true
                Write-Host "  [FIX] Wrapped maximizeWindow() after browser action" -ForegroundColor Green
            }
        }
        
        if ($modified) {
            # Ghi file moi (khong co BOM)
            $utf8NoBom = New-Object System.Text.UTF8Encoding $false
            [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
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
Write-Host ""
Write-Host "NOTE: maximizeWindow() calls are now safely wrapped." -ForegroundColor Green
Write-Host "They will be ignored in headless mode without causing errors." -ForegroundColor Green

