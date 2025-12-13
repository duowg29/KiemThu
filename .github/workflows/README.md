# GitHub Actions Workflows cho Katalon Studio

## Workflow: `katalon-tests.yml`

Workflow này sử dụng **Self-Hosted Runner** để chạy Katalon Studio tests.

### Yêu Cầu:
- ✅ Self-hosted runner đã được setup
- ✅ Katalon Studio đã cài đặt trên máy runner
- ✅ Đường dẫn Katalon đã được cấu hình trong workflow

### Quick Start

1. **Setup self-hosted runner:**
   - Xem hướng dẫn trong `HUONG_DAN_CHI_TIET_GITHUB_ACTIONS.md` (phần Cách 2)
   - Hoặc `HUONG_DAN_FIX_LOI_KRE.md`

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

