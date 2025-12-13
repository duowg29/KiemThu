# GitHub Actions Workflows cho Katalon Studio

## Có 2 workflow files:

### 1. `katalon-tests.yml` - Dùng Katalon Studio (Self-hosted runner)
- **Dùng khi:** Bạn có self-hosted runner với Katalon Studio đã cài sẵn
- **Cách dùng:** 
  1. Setup self-hosted runner (xem hướng dẫn trong `HUONG_DAN_GITHUB_ACTIONS.md`)
  2. Sửa đường dẫn `$KATALON_HOME` trong file workflow
  3. Đổi `runs-on: windows-latest` thành `runs-on: self-hosted`

### 2. `katalon-tests-kre.yml` - Dùng Katalon Runtime Engine (KRE)
- **Dùng khi:** Chạy trên GitHub-hosted runners (không cần máy riêng)
- **Cách dùng:** 
  1. Commit và push file này lên GitHub
  2. Workflow sẽ tự động tải KRE và chạy tests
  3. Không cần cấu hình thêm

## Quick Start

1. **Chọn workflow phù hợp:**
   - Nếu có self-hosted runner → dùng `katalon-tests.yml`
   - Nếu không → dùng `katalon-tests-kre.yml`

2. **Sửa test suite (nếu cần):**
   - Tìm dòng `-testSuitePath="Test Suites/Functional/Login Testcases"`
   - Thay đổi thành test suite bạn muốn chạy

3. **Commit và push:**
   ```bash
   git add .github/workflows/
   git commit -m "Add GitHub Actions CI/CD"
   git push
   ```

4. **Xem kết quả:**
   - Vào tab **Actions** trên GitHub
   - Click vào workflow run để xem logs và download reports

## Lưu Ý

- Workflow sẽ chạy tự động khi push code hoặc tạo PR
- Có thể chạy thủ công từ tab Actions → Run workflow
- Test reports được lưu 30 ngày trong Artifacts

Xem hướng dẫn chi tiết trong file `HUONG_DAN_GITHUB_ACTIONS.md` ở root directory.

