# Script kiem tra logs va reports

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "KIEM TRA LOGS VA REPORTS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$reportsPath = "C:\Users\feu29\Katalon Studio\KiemThu\Reports"

# Tim report moi nhat
$latestReport = Get-ChildItem -Path $reportsPath -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($latestReport) {
    Write-Host "Report moi nhat: $($latestReport.Name)" -ForegroundColor Green
    Write-Host "Thoi gian: $($latestReport.LastWriteTime)"
    Write-Host ""
    
    # Tim Navigation Testcases report
    $navReport = Join-Path $latestReport.FullName "UI\Navigation Testcases"
    if (Test-Path $navReport) {
        $navDirs = Get-ChildItem -Path $navReport -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($navDirs) {
            Write-Host "Navigation Testcases report: $($navDirs.Name)" -ForegroundColor Cyan
            Write-Host "Path: $($navDirs.FullName)"
            Write-Host ""
            
            # Kiem tra execution log
            $execLog = Join-Path $navDirs.FullName "execution0.log"
            if (Test-Path $execLog) {
                Write-Host "[OK] Tim thay execution log" -ForegroundColor Green
                Write-Host "20 dong cuoi cua log:" -ForegroundColor Yellow
                Write-Host "----------------------------------------"
                Get-Content $execLog -Tail 20 -ErrorAction SilentlyContinue | ForEach-Object {
                    Write-Host $_
                }
                Write-Host "----------------------------------------"
            }
            else {
                Write-Host "[WARNING] Khong tim thay execution0.log" -ForegroundColor Yellow
            }
            
            # Kiem tra execution properties
            $execProps = Join-Path $navDirs.FullName "execution.properties"
            if (Test-Path $execProps) {
                Write-Host ""
                Write-Host "[OK] Tim thay execution.properties" -ForegroundColor Green
                Write-Host "Noi dung:" -ForegroundColor Yellow
                Get-Content $execProps -ErrorAction SilentlyContinue | ForEach-Object {
                    Write-Host "  $_"
                }
            }
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
