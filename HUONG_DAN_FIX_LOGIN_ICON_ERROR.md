# HƯỚNG DẪN SỬA LỖI ELEMENTNOTINTERACTABLEEXCEPTION CHO LOGIN ICON

## 🔍 VẤN ĐỀ

Khi chạy test trong headless mode (GitHub Actions), các test case cần click vào login icon (`//li[@id='login-icon']/a/i`) bị lỗi `ElementNotInteractableException`.

**Nguyên nhân:**
- Element chưa sẵn sàng khi test cố gắng click
- Element có thể bị che khuất hoặc không visible trong headless mode
- Thiếu wait, scroll, và fallback mechanism

**Test case thành công:** Navigation test cases (TUI17, TUI18, TUI19) vì chúng không cần click login icon.

**Test case thất bại:** TUI28, Login testcases, Product Management, Shopping Cart vì chúng cần click login icon.

## ✅ GIẢI PHÁP

Đã tạo Custom Keyword `WebUIExtendedKeywords.safeClickLoginIcon()` để xử lý click login icon an toàn với:
- ✅ Wait for element present
- ✅ Wait for element visible  
- ✅ Scroll to element
- ✅ Fallback JavaScript click nếu normal click fail

## 📝 CÁCH SỬ DỤNG

### Cách 1: Sử dụng Custom Keyword (Khuyến nghị)

Thay thế dòng:
```groovy
WebUI.click(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (138)'))
```

Bằng:
```groovy
import com.kms.katalon.keyword.WebUIExtendedKeywords as ExtendedKeywords

// ... ở đầu file, thêm import

ExtendedKeywords.safeClickLoginIcon(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (138)'))
```

### Cách 2: Sử dụng safeClick cho bất kỳ element nào

Nếu bạn muốn xử lý an toàn cho element khác:
```groovy
import com.kms.katalon.keyword.WebUIExtendedKeywords as ExtendedKeywords

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (138)'))
```

### Cách 3: Tự xử lý trong test case (giống Navigation test cases)

Nếu không muốn dùng Custom Keyword, bạn có thể copy pattern từ Navigation test cases:

```groovy
// Đợi page load hoàn toàn
WebUI.delay(2)

// Đợi element present (tồn tại trong DOM) trước
WebUI.waitForElementPresent(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (138)'), 20)

// Đợi element visible và scroll đến element
WebUI.waitForElementVisible(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (138)'), 20)
WebUI.scrollToElement(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (138)'), 10)

// Thử click bình thường, nếu fail thì dùng JavaScript click
try {
	WebUI.click(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (138)'))
} catch (Exception e) {
	// Fallback: Dùng JavaScript click nếu normal click fail
	println "Normal click failed, trying JavaScript click..."
	WebUI.executeJavaScript('arguments[0].click();', [WebUI.findWebElement(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (138)'))])
}
```

## 🔧 ĐÃ SỬA

✅ **TUI28** - Đã cập nhật để sử dụng `safeClickLoginIcon()`

## 📋 CẦN SỬA

Các test case sau cần được cập nhật tương tự (tìm trong `Scripts/`):

1. **UI Testing:**
   - TUI01, TUI02, TUI03, TUI04, TUI05, TUI06, TUI07, TUI08, TUI09
   - TUI15, TUI16, TUI21, TUI22, TUI23, TUI24, TUI25, TUI26, TUI27
   - TUI29, TUI30, TUI31, TUI32, TUI33, TUI34, TUI35, TUI36, TUI37, TUI38, TUI39
   - TUIC20

2. **Functional Testing:**
   - T01-01, T01-02, T01-03, T01-04
   - T02-01, T02-02, T02-03, T02-04, T02-05
   - T08-01
   - T11-01, T12-01, T13-01, T13-02
   - T14-01, T14-02, T15-01, T15-02
   - T16-01, T17-01
   - T18-01, T18-02, T18-03, T18-04, T18-05
   - T19-01, T19-02
   - T20-01, T20-02
   - T21-01, T22-01, T23-01, T23-02, T23-03
   - T24-01
   - T25-01, T25-02, T25-03, T25-04
   - T26-01, T26-02
   - T27-01, T27-02, T27-03, T27-04
   - T28-01, T28-02, T28-03
   - T29-01, T29-02
   - T30-01, T30-02
   - T31-01, T31-02, T31-03, T31-04, T31-05
   - T32-01, T32-02, T32-03, T32-04
   - T33-01, T33-02, T33-03
   - T34-01, T34-02, T34-03, T34-04
   - T35-01, T35-02, T35-03, T35-04
   - T36-01, T36-02, T36-03
   - T37-01, T37-02
   - T38-01, T38-02
   - T39-01, T39-02, T39-03, T39-04
   - T40-01, T40-02, T40-03, T40-04
   - T41-03
   - T42-01, T42-02, T42-03, T42-04, T42-05
   - T43-01, T43-02, T43-03, T43-04

## 🚀 SCRIPT TỰ ĐỘNG HÓA (Tùy chọn)

Bạn có thể tạo script PowerShell để tự động cập nhật tất cả các test case:

```powershell
# Tìm tất cả file .groovy có chứa "i_Contact_fas fa-user"
$files = Get-ChildItem -Path "Scripts" -Recurse -Filter "*.groovy" | 
    Select-String -Pattern "i_Contact_fas fa-user" | 
    Select-Object -ExpandProperty Path -Unique

foreach ($file in $files) {
    # Đọc file
    $content = Get-Content $file -Raw
    
    # Kiểm tra xem đã có import ExtendedKeywords chưa
    if ($content -notmatch "import com\.kms\.katalon\.keyword\.WebUIExtendedKeywords") {
        # Thêm import sau dòng import WebUI
        $content = $content -replace "(import com\.kms\.katalon\.core\.webui\.keyword\.WebUiBuiltInKeywords as WebUI)", "`$1`nimport com.kms.katalon.keyword.WebUIExtendedKeywords as ExtendedKeywords"
    }
    
    # Thay thế WebUI.click(...i_Contact_fas fa-user...) bằng ExtendedKeywords.safeClickLoginIcon(...)
    $content = $content -replace "WebUI\.click\(findTestObject\('Object Repository/Page_CamNest/i_Contact_fas fa-user[^']+'\)\)", "ExtendedKeywords.safeClickLoginIcon(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (138)'))"
    
    # Ghi lại file
    Set-Content -Path $file -Value $content -NoNewline
    Write-Host "Updated: $file"
}
```

**Lưu ý:** Script trên chỉ là ví dụ. Bạn cần điều chỉnh pattern matching cho đúng với tên object trong từng test case.

## ✅ KIỂM TRA

Sau khi sửa, chạy lại test để kiểm tra:
1. Test case TUI28 đã được sửa và có thể chạy thành công
2. Các test case khác cần được cập nhật tương tự
3. Kiểm tra trong GitHub Actions log để xem còn lỗi `ElementNotInteractableException` không

## 📚 THAM KHẢO

- Navigation test cases (TUI17, TUI18, TUI19) đã có pattern xử lý tương tự
- Custom Keyword: `Keywords/com/kms/katalon/keyword/WebUIExtendedKeywords.groovy`
- Test case mẫu đã sửa: `Scripts/UI Testing/TUI28/Script1765126673450.groovy`
