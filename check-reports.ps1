# Script kiem tra reports moi nhat

$reportsPath = "C:\Users\feu29\Katalon Studio\KiemThu\Reports"

Write-Host "Danh sach reports (moi nhat 5):" -ForegroundColor Cyan
Get-ChildItem -Path $reportsPath -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 5 | ForEach-Object {
    Write-Host "  $($_.Name) - $($_.LastWriteTime)" -ForegroundColor Yellow
}

$latestReport = Get-ChildItem -Path $reportsPath -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($latestReport) {
    Write-Host ""
    Write-Host "Report moi nhat: $($latestReport.Name)" -ForegroundColor Green
    Write-Host "Thoi gian: $($latestReport.LastWriteTime)"
    
    # Kiem tra runningMode
    $navReport = Join-Path $latestReport.FullName "UI\Navigation Testcases"
    if (Test-Path $navReport) {
        $navDirs = Get-ChildItem -Path $navReport -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($navDirs) {
            $execProps = Join-Path $navDirs.FullName "execution.properties"
            if (Test-Path $execProps) {
                $content = Get-Content $execProps -Raw
                if ($content -match '"runningMode":"([^"]+)"') {
                    $runningMode = $matches[1]
                    Write-Host ""
                    Write-Host "Running Mode: $runningMode" -ForegroundColor $(if ($runningMode -eq "console") { "Green" } else { "Yellow" })
                    if ($runningMode -ne "console") {
                        Write-Host "[WARNING] Katalon chay o GUI mode thay vi console mode!" -ForegroundColor Red
                    }
                }
            }
        }
    }
}
