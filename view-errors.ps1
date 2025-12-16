# Script xem errors từ Katalon execution

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "XEM ERRORS TỪ KATALON" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Cách 1: Xem errors từ reports
$reportsPath = "C:\Users\feu29\Katalon Studio\KiemThu\Reports"
Write-Host "1. Kiem tra errors trong reports:" -ForegroundColor Yellow

if (Test-Path $reportsPath) {
    $latestReport = Get-ChildItem -Path $reportsPath -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($latestReport) {
        Write-Host "Report moi nhat: $($latestReport.Name)" -ForegroundColor Green
        Write-Host "Thoi gian: $($latestReport.LastWriteTime)"
        Write-Host ""
        
        # Tim execution log
        $navReport = Join-Path $latestReport.FullName "UI\Navigation Testcases"
        if (Test-Path $navReport) {
            $navDirs = Get-ChildItem -Path $navReport -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
            if ($navDirs) {
                $execLog = Join-Path $navDirs.FullName "execution0.log"
                if (Test-Path $execLog) {
                    Write-Host "[OK] Tim thay execution log" -ForegroundColor Green
                    Write-Host "Tim kiem errors trong log..." -ForegroundColor Yellow
                    Write-Host ""
                    
                    $logContent = Get-Content $execLog -ErrorAction SilentlyContinue
                    $errors = $logContent | Where-Object { 
                        $_ -match "ERROR|Error|Exception|Failed|FAIL" -or
                        $_ -match "java\.lang\." -or
                        $_ -match "com\.kms\.katalon" 
                    }
                    
                    if ($errors) {
                        Write-Host "========================================" -ForegroundColor Red
                        Write-Host "ERRORS FOUND IN LOG:" -ForegroundColor Red
                        Write-Host "========================================" -ForegroundColor Red
                        $errors | ForEach-Object {
                            Write-Host $_ -ForegroundColor Red
                        }
                        Write-Host "========================================" -ForegroundColor Red
                    } else {
                        Write-Host "[INFO] Khong tim thay errors trong log" -ForegroundColor Gray
                    }
                } else {
                    Write-Host "[WARNING] Khong tim thay execution0.log" -ForegroundColor Yellow
                }
            }
        }
    }
}

Write-Host ""
Write-Host "2. Huong dan xem errors trong GitHub Actions:" -ForegroundColor Yellow
Write-Host ""
Write-Host "Cach 1: Xem trong log" -ForegroundColor Cyan
Write-Host "  1. Vao: https://github.com/duowg29/KiemThu/actions" -ForegroundColor White
Write-Host "  2. Chon workflow run moi nhat" -ForegroundColor White
Write-Host "  3. Mo step 'Run Katalon Tests'" -ForegroundColor White
Write-Host "  4. Tim 'ERRORS FOUND' hoac 'ERRORS CAPTURED'" -ForegroundColor White
Write-Host ""
Write-Host "Cach 2: Tim bang Search (Ctrl+F)" -ForegroundColor Cyan
Write-Host "  - Tim: 'ERROR:', 'ERRORS FOUND', 'Error lines:'" -ForegroundColor White
Write-Host ""
Write-Host "Cach 3: Xem Raw Logs" -ForegroundColor Cyan
Write-Host "  - Click '...' menu -> 'View raw logs'" -ForegroundColor White
Write-Host "  - Tim cac dong co '[ERROR]' hoac 'ERROR:'" -ForegroundColor White
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan



