# SỬA LỖI DUPLICATE REPLACEMENTS

## 🔍 VẤN ĐỀ

Sau khi chạy script tự động `fix-all-testcases.ps1`, phát hiện 49 file bị lỗi do script đã thay thế nhiều lần trong cùng một dòng, tạo ra code bị lỗi compilation.

### Ví dụ lỗi:

**Code gốc:**
```groovy
WebUI.click(findTestObject('Object Repository/Page_CamNest - Camera/i_My nh k thut s Sony ZV-E10_far fa-cart-plus cart (6)'))
WebUI.click(findTestObject('Object Repository/Page_CamNest - Camera/i_Contact_fas fa-shopping-cart (7)'))
```

**Code bị lỗi (sau script đầu tiên):**
```groovy
ExtendedKeywords.safeClick(findTestObject('Object RepositExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest - Camera/i_My nh k thut s Sony ZV-E10_far fa-cart-plus cart (6)'))0_faExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest - Camera/i_Contact_fas fa-shopping-cart (7)'))ct_fas fa-shopping-cart (7)'))
```

## ✅ GIẢI PHÁP

Tạo script `fix-duplicate-replacements.ps1` để:
1. Tìm các file có pattern lỗi (chứa `ExtendedKeywords.safeClick` nhiều lần trong cùng một dòng)
2. Đọc file backup (.backup) để lấy code gốc
3. Áp dụng lại thay đổi ĐÚNG - thay thế từng dòng một, không thay thế nhiều lần trong cùng một dòng

## 📊 KẾT QUẢ

- ✅ **49 files đã được sửa** thành công
- ✅ Tất cả các file đã được kiểm tra và sửa lỗi compilation
- ✅ Code giờ đã đúng format và có thể compile

## 📋 DANH SÁCH FILE ĐÃ SỬA

### UI Testing (12 files):
- TUI07, TUI12, TUI15, TUI16
- TUI21, TUI22, TUI23, TUI25, TUI26, TUI27, TUI28
- TUI29, TUI30, TUI31, TUI34, TUI35, TUI37, TUI38

### Functional Testing (37 files):
- T03-01
- T06-01, T06-02
- T07-02
- T08-01
- T09-01
- T10-02
- T12-01
- T13-02
- T14-01, T14-02
- T15-01
- T28-01, T28-02, T28-03
- T30-01
- T31-02, T31-04
- T34-04
- T35-01, T35-02, T35-04
- T36-01, T36-03
- T39-02, T39-04
- T40-03
- T43-01, T43-02, T43-03, T43-04

## 🔧 CHI TIẾT SỬA ĐỔI

Script `fix-duplicate-replacements.ps1` thực hiện:
1. Tìm pattern lỗi: `ExtendedKeywords.safeClick.*ExtendedKeywords.safeClick`
2. Đọc file backup tương ứng
3. Áp dụng lại thay đổi đúng cách:
   - Thêm import `ExtendedKeywords`
   - Thay thế login icon bằng `safeClickLoginIcon`
   - Thay thế các `WebUI.click()` khác bằng `safeClick()` - **từng dòng một**

## ✅ KIỂM TRA

Sau khi sửa, tất cả các file đã:
- ✅ Không còn pattern lỗi duplicate replacements
- ✅ Code có thể compile thành công
- ✅ Format đúng, mỗi dòng chỉ có một lệnh click

## 📚 THAM KHẢO

- **Script sửa lỗi:** `fix-duplicate-replacements.ps1`
- **Script gốc:** `fix-all-testcases.ps1` (đã được cải thiện)
- **Files đã sửa:** 49 files trong thư mục `Scripts/`
