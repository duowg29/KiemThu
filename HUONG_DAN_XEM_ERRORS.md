# HƯỚNG DẪN XEM ERRORS

**Ngày:** 14/12/2025

## 🔍 CÁCH XEM ERRORS TRONG GITHUB ACTIONS

### Cách 1: Xem trong Log (Khuyến nghị)

1. **Vào GitHub Actions:**
   - https://github.com/duowg29/KiemThu/actions
   - Chọn workflow run mới nhất (có thể là "update #66" hoặc mới hơn)

2. **Mở step "Run Katalon Tests":**
   - Click vào step "Run Katalon Tests"
   - Scroll xuống trong log

3. **Tìm phần "ERRORS FOUND":**
   - Tìm dòng có `========================================`
   - Tìm `ERRORS FOUND (X lines):`
   - Các dòng error sẽ hiển thị với prefix `[ERROR]` hoặc `ERROR:`

4. **Hoặc tìm "=== ALL ERRORS CAPTURED ===":**
   - Ở cuối log, sau khi process exit
   - Sẽ có section hiển thị tất cả errors

### Cách 2: Tìm trong Log bằng Search

1. Trong GitHub Actions log, dùng Ctrl+F (hoặc Cmd+F trên Mac)
2. Tìm từ khóa:
   - `ERROR:`
   - `ERRORS FOUND`
   - `ERRORS CAPTURED`
   - `Error lines:`

### Cách 3: Xem Raw Log

1. Trong GitHub Actions, click vào "..." menu
2. Chọn "View raw logs"
3. Tìm các dòng có `[ERROR]` hoặc `ERROR:`

## 📋 CÁC LOẠI LỖI THƯỜNG GẶP

### 1. Lỗi từ Katalon Studio
- **Dấu hiệu:** Có chứa "Katalon", "katalon", "com.kms.katalon"
- **Ví dụ:**
  - `com.kms.katalon.core.main.TestCaseMain: ERROR: ...`
  - `Katalon Studio: Failed to ...`
  - `Test suite execution failed`

### 2. Lỗi từ Java/JVM
- **Dấu hiệu:** Có chứa "java", "Exception", "Error"
- **Ví dụ:**
  - `java.lang.Exception: ...`
  - `OutOfMemoryError`
  - `ClassNotFoundException`

### 3. Lỗi từ Browser/Chrome
- **Dấu hiệu:** Có chứa "chrome", "chromedriver", "browser"
- **Ví dụ:**
  - `ChromeDriver error: ...`
  - `Browser not found`
  - `Chrome headless failed`

### 4. Lỗi từ Project/Test Suite
- **Dấu hiệu:** Có chứa "test suite", "test case", "project"
- **Ví dụ:**
  - `Test suite not found`
  - `Test case failed`
  - `Project path invalid`

## 🔧 ĐÃ SỬA TRONG WORKFLOW

Workflow đã được cập nhật để:
1. **Hiển thị errors ngay khi có** trong status updates
2. **Hiển thị errors ngay sau khi process exit**
3. **Hiển thị tất cả errors** ở cuối với format rõ ràng

## ✅ SAU KHI XEM ERRORS

Sau khi xem được errors, hãy:
1. Copy nội dung errors
2. Cho tôi biết nội dung errors
3. Tôi sẽ phân tích và sửa tiếp

---

**Lưu ý:** Errors có thể đến từ:
- Katalon Studio (nếu có lỗi trong test cases, configuration)
- Java/JVM (nếu có lỗi runtime)
- Browser/Chrome (nếu có vấn đề với browser)
- Project setup (nếu có vấn đề với project path, test suite)
