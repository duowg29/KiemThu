# Hướng Dẫn Setup CI/CD với GitHub Actions cho Katalon Studio

## Tổng Quan

GitHub Actions là dịch vụ CI/CD tích hợp sẵn trong GitHub, miễn phí cho public repositories và có giới hạn cho private repos.

## Có 2 Cách Chạy Katalon trên GitHub Actions:

### Cách 1: Dùng Self-Hosted Runner (Khuyến nghị nếu bạn không muốn dùng KRE)

**Ưu điểm:**
- Có thể dùng Katalon Studio đầy đủ
- Không cần KRE
- Kiểm soát hoàn toàn môi trường

**Nhược điểm:**
- Cần máy Windows chạy 24/7 hoặc khi cần
- Cần cấu hình self-hosted runner

**Các bước:**

1. **Cài đặt Katalon Studio trên máy Windows của bạn**
   - Tải và cài Katalon Studio: https://www.katalon.com/download/
   - Ghi nhớ đường dẫn cài đặt (ví dụ: `C:\Program Files\Katalon\Katalon Studio`)

2. **Cài đặt GitHub Actions Runner**
   - Vào repository trên GitHub → Settings → Actions → Runners
   - Click "New self-hosted runner"
   - Chọn "Windows" và làm theo hướng dẫn
   - Download và chạy `config.cmd` với token từ GitHub

3. **Sửa file workflow** `.github/workflows/katalon-tests.yml`:
   ```yaml
   runs-on: self-hosted  # Thay vì windows-latest
   ```
   
   Và sửa đường dẫn Katalon:
   ```powershell
   $KATALON_HOME = "C:\Program Files\Katalon\Katalon Studio"
   # Hoặc nếu cài trong user directory:
   # $KATALON_HOME = "$env:USERPROFILE\.katalon\packages\KSE-10.4.2"
   ```

4. **Commit và push** file workflow lên GitHub

---

### Cách 2: Dùng Katalon Runtime Engine (KRE) - Khuyến nghị cho GitHub-hosted runners

**Ưu điểm:**
- Chạy trên GitHub-hosted runners (không cần máy riêng)
- Nhẹ hơn, nhanh hơn
- Không cần cấu hình thêm

**Nhược điểm:**
- Cần tải KRE mỗi lần chạy (hoặc cache)
- Một số tính năng có thể khác với Katalon Studio đầy đủ

**Các bước:**

1. **Sử dụng file workflow** `.github/workflows/katalon-tests-kre.yml`

2. **Sửa version KRE** nếu cần (dòng `$KRE_VERSION = "9.3.0"`)

3. **Commit và push** lên GitHub

4. **Kiểm tra Actions tab** trên GitHub để xem kết quả

---

## Cấu Hình Chi Tiết

### Thay Đổi Test Suite

Trong file workflow, tìm dòng:
```yaml
-testSuitePath="Test Suites/Functional/Login Testcases"
```

Thay đổi thành test suite bạn muốn chạy:
```yaml
-testSuitePath="Test Suites/UI Testing"
```

### Thay Đổi Browser

```yaml
-browserType="Chrome (headless)"  # Headless Chrome
-browserType="Firefox (headless)"  # Headless Firefox
-browserType="Chrome"  # Chrome có UI (không khuyến nghị trên CI)
```

### Thêm Environment Variables

Nếu cần biến môi trường:
```yaml
- name: Run Katalon Tests
  env:
    MY_CUSTOM_VAR: "value"
    ANOTHER_VAR: "another_value"
  run: |
    # ...
```

### Chạy Nhiều Test Suites

Thêm nhiều steps:
```yaml
- name: Run Login Tests
  run: |
    # ... chạy Login Testcases

- name: Run UI Tests
  run: |
    # ... chạy UI Testing
```

---

## Troubleshooting

### Lỗi: "Katalon Studio not found"
- Kiểm tra đường dẫn `$KATALON_HOME` trong workflow
- Đảm bảo Katalon Studio đã được cài đặt trên self-hosted runner

### Lỗi: "WebView server has been started"
- Các JVM options trong workflow đã được set để tắt WebView
- Nếu vẫn gặp, thêm thêm options:
  ```yaml
  JAVA_OPTS: '-Djava.awt.headless=true -Dorg.eclipse.swt.browser.DefaultType=none ...'
  ```

### Lỗi: "Chrome not found"
- GitHub-hosted runners có Chrome sẵn
- Nếu dùng self-hosted runner, cần cài Chrome hoặc ChromeDriver

### Lỗi: Timeout
- Tăng timeout trong workflow:
  ```yaml
  timeout-minutes: 60  # Thêm vào step
  ```

---

## Workflow Triggers

Workflow sẽ chạy khi:
- **Push** code lên branch `main` hoặc `master`
- **Pull Request** được tạo/update
- **Manual trigger** (workflow_dispatch) - vào Actions tab → chọn workflow → Run workflow

---

## Xem Kết Quả

1. Vào tab **Actions** trên GitHub repository
2. Click vào workflow run mới nhất
3. Xem logs và download artifacts (test reports)

---

## Lưu Ý

- **Secrets**: Nếu cần API keys, credentials, thêm vào Settings → Secrets → Actions
- **Artifacts**: Test reports được lưu 30 ngày (có thể thay đổi)
- **Cost**: GitHub Actions miễn phí cho public repos, có giới hạn cho private repos

---

## Tài Liệu Tham Khảo

- GitHub Actions Docs: https://docs.github.com/en/actions
- Katalon Runtime Engine: https://docs.katalon.com/katalon-runtime-engine/docs/overview.html
- Katalon Console Mode: https://docs.katalon.com/katalon-studio/docs/console-mode-execution.html

