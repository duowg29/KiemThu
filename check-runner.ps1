# Script kiểm tra Actions Runner - Xem runner đang checkout code ở đâu
# Chạy script này trong thư mục actions-runner

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "KIỂM TRA ACTIONS RUNNER" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Kiểm tra thư mục hiện tại
Write-Host "1. THÔNG TIN THƯ MỤC HIỆN TẠI:" -ForegroundColor Yellow
Write-Host "   Current Directory: $PWD" -ForegroundColor White
Write-Host ""

# 2. Kiểm tra file .runner (cấu hình runner)
Write-Host "2. CẤU HÌNH RUNNER:" -ForegroundColor Yellow
$runnerConfig = Join-Path $PWD ".runner"
if (Test-Path $runnerConfig) {
    Write-Host "   ✓ File .runner tồn tại: $runnerConfig" -ForegroundColor Green
    $configContent = Get-Content $runnerConfig -Raw
    Write-Host "   Nội dung cấu hình:" -ForegroundColor White
    $configContent | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
} else {
    Write-Host "   ✗ File .runner KHÔNG tồn tại!" -ForegroundColor Red
    Write-Host "   Đường dẫn kiểm tra: $runnerConfig" -ForegroundColor Red
}
Write-Host ""

# 3. Kiểm tra thư mục _work (workspace)
Write-Host "3. WORKSPACE (_work):" -ForegroundColor Yellow
$workDir = Join-Path $PWD "_work"
if (Test-Path $workDir) {
    Write-Host "   ✓ Thư mục _work tồn tại: $workDir" -ForegroundColor Green
    
    # Liệt kê các thư mục trong _work
    $workDirs = Get-ChildItem -Path $workDir -Directory -ErrorAction SilentlyContinue
    if ($workDirs) {
        Write-Host "   Các thư mục trong _work:" -ForegroundColor White
        $workDirs | ForEach-Object {
            Write-Host "     - $($_.Name) ($($_.FullName))" -ForegroundColor Gray
            
            # Kiểm tra xem có project KiemThu không
            $projectPath = Join-Path $_.FullName "KiemThu"
            if (Test-Path $projectPath) {
                Write-Host "       ✓ Tìm thấy project KiemThu tại: $projectPath" -ForegroundColor Green
                
                # Kiểm tra file CAMNEST.prj
                $prjFile = Join-Path $projectPath "CAMNEST.prj"
                if (Test-Path $prjFile) {
                    Write-Host "       ✓ File CAMNEST.prj tồn tại" -ForegroundColor Green
                    
                    # Đọc projectFileLocation từ file
                    $prjContent = Get-Content $prjFile -Raw
                    if ($prjContent -match '<projectFileLocation>(.*?)</projectFileLocation>') {
                        $projectLocation = $matches[1]
                        Write-Host "       Project Location trong file: $projectLocation" -ForegroundColor Cyan
                    }
                } else {
                    Write-Host "       ✗ File CAMNEST.prj KHÔNG tồn tại" -ForegroundColor Red
                }
                
                # Kiểm tra file .git
                $gitDir = Join-Path $projectPath ".git"
                if (Test-Path $gitDir) {
                    Write-Host "       ✓ Đây là Git repository" -ForegroundColor Green
                    
                    # Kiểm tra remote URL
                    $gitConfig = Join-Path $gitDir "config"
                    if (Test-Path $gitConfig) {
                        $gitConfigContent = Get-Content $gitConfig -Raw
                        if ($gitConfigContent -match 'url\s*=\s*(.*)') {
                            $remoteUrl = $matches[1]
                            Write-Host "       Remote URL: $remoteUrl" -ForegroundColor Cyan
                        }
                    }
                }
            } else {
                Write-Host "       ✗ KHÔNG tìm thấy project KiemThu" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "   ⚠ Thư mục _work trống (chưa có workflow nào chạy)" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ✗ Thư mục _work KHÔNG tồn tại!" -ForegroundColor Red
    Write-Host "   Đường dẫn kiểm tra: $workDir" -ForegroundColor Red
}
Write-Host ""

# 4. Kiểm tra đường dẫn project mới
Write-Host "4. KIỂM TRA ĐƯỜNG DẪN PROJECT MỚI:" -ForegroundColor Yellow
$newProjectPath = "C:\Users\feu29\Katalon Studio\KiemThu"
if (Test-Path $newProjectPath) {
    Write-Host "   ✓ Đường dẫn project mới tồn tại: $newProjectPath" -ForegroundColor Green
    
    # Kiểm tra file CAMNEST.prj
    $prjFile = Join-Path $newProjectPath "CAMNEST.prj"
    if (Test-Path $prjFile) {
        Write-Host "   ✓ File CAMNEST.prj tồn tại" -ForegroundColor Green
        
        # Đọc projectFileLocation
        $prjContent = Get-Content $prjFile -Raw
        if ($prjContent -match '<projectFileLocation>(.*?)</projectFileLocation>') {
            $projectLocation = $matches[1]
            Write-Host "   Project Location: $projectLocation" -ForegroundColor Cyan
        }
    }
} else {
    Write-Host "   ✗ Đường dẫn project mới KHÔNG tồn tại: $newProjectPath" -ForegroundColor Red
}
Write-Host ""

# 5. Kiểm tra runner có đang chạy không
Write-Host "5. TRẠNG THÁI RUNNER:" -ForegroundColor Yellow
$runnerProcess = Get-Process -Name "Runner.Listener" -ErrorAction SilentlyContinue
if ($runnerProcess) {
    Write-Host "   ✓ Runner đang chạy (PID: $($runnerProcess.Id))" -ForegroundColor Green
} else {
    Write-Host "   ✗ Runner KHÔNG đang chạy!" -ForegroundColor Red
    Write-Host "   Hãy chạy: .\run.cmd" -ForegroundColor Yellow
}
Write-Host ""

# 6. Kiểm tra file diag (logs) nếu có
Write-Host "6. LOGS RUNNER:" -ForegroundColor Yellow
$diagFiles = Get-ChildItem -Path $PWD -Filter "*.log" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 3
if ($diagFiles) {
    Write-Host "   Các file log gần nhất:" -ForegroundColor White
    $diagFiles | ForEach-Object {
        Write-Host "     - $($_.Name) (Cập nhật: $($_.LastWriteTime))" -ForegroundColor Gray
    }
} else {
    Write-Host "   ⚠ Không tìm thấy file log" -ForegroundColor Yellow
}
Write-Host ""

# 7. Thông tin về GitHub Actions
Write-Host "7. THÔNG TIN GITHUB:" -ForegroundColor Yellow
Write-Host "   Repository: https://github.com/duowg29/KiemThu" -ForegroundColor Cyan
Write-Host "   Actions: https://github.com/duowg29/KiemThu/actions" -ForegroundColor Cyan
Write-Host "   Runners: https://github.com/duowg29/KiemThu/settings/actions/runners" -ForegroundColor Cyan
Write-Host ""

# 8. Kết luận và gợi ý
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "KẾT LUẬN:" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

if (Test-Path $workDir) {
    $hasProject = Get-ChildItem -Path $workDir -Recurse -Directory -Filter "KiemThu" -ErrorAction SilentlyContinue
    if ($hasProject) {
        Write-Host "✓ Runner đã checkout project vào workspace" -ForegroundColor Green
        Write-Host "  Đường dẫn: $($hasProject[0].FullName)" -ForegroundColor White
    } else {
        Write-Host "⚠ Runner chưa checkout project (có thể chưa có workflow nào chạy)" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠ Thư mục workspace chưa được tạo" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "GỢI Ý:" -ForegroundColor Yellow
Write-Host "1. Đảm bảo runner đang chạy: .\run.cmd" -ForegroundColor White
Write-Host "2. Kiểm tra runner online trên GitHub: https://github.com/duowg29/KiemThu/settings/actions/runners" -ForegroundColor White
Write-Host "3. Trigger workflow thủ công từ GitHub Actions" -ForegroundColor White
Write-Host "4. Xem logs trong GitHub Actions để biết runner có nhận job không" -ForegroundColor White
Write-Host ""

