# Script kiem tra trang thai workflow sau khi push

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "KIEM TRA WORKFLOW STATUS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Kiem tra reports moi nhat
$reportsPath = "C:\Users\feu29\Katalon Studio\KiemThu\Reports"
Write-Host "1. Kiem tra reports moi nhat:" -ForegroundColor Yellow

if (Test-Path $reportsPath) {
    $latestReport = Get-ChildItem -Path $reportsPath -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($latestReport) {
        $timeDiff = (Get-Date) - $latestReport.LastWriteTime
        Write-Host "Report moi nhat: $($latestReport.Name)" -ForegroundColor Green
        Write-Host "Thoi gian: $($latestReport.LastWriteTime)"
        Write-Host "Cach day: $([int]$timeDiff.TotalMinutes) phut" -ForegroundColor $(if ($timeDiff.TotalMinutes -lt 10) { "Green" } else { "Yellow" })
        
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
                        if ($runningMode -eq "console") {
                            Write-Host "[SUCCESS] Katalon chay o console mode!" -ForegroundColor Green
                        } else {
                            Write-Host "[WARNING] Katalon van chay o GUI mode" -ForegroundColor Yellow
                        }
                    }
                }
            }
        }
    } else {
        Write-Host "[INFO] Chua co report nao" -ForegroundColor Gray
    }
} else {
    Write-Host "[INFO] Reports folder chua duoc tao" -ForegroundColor Gray
}

Write-Host ""
Write-Host "2. Kiem tra E:\actions-runner workspace:" -ForegroundColor Yellow
$runnerPath = "E:\actions-runner\_work\KiemThu\KiemThu"
if (Test-Path $runnerPath) {
    Write-Host "[OK] Runner workspace ton tai" -ForegroundColor Green
    $prjFile = Get-ChildItem -Path $runnerPath -Filter "*.prj" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($prjFile) {
        Write-Host "Project file: $($prjFile.Name)" -ForegroundColor Green
    }
} else {
    Write-Host "[INFO] Runner workspace chua co project (se duoc checkout khi workflow chay)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "HUONG DAN:" -ForegroundColor Cyan
Write-Host "1. Vao GitHub Actions de xem log chi tiet:" -ForegroundColor Yellow
Write-Host "   https://github.com/duowg29/KiemThu/actions" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Neu workflow chua chay xong, cho them 1-2 phut" -ForegroundColor Yellow
Write-Host ""
Write-Host "3. Neu co loi, se tiep tuc sua va push" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
