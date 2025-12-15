# HƯỚNG DẪN CẤU HÌNH LICENSE CHO KRE

## ⚠️ VẤN ĐỀ

KRE (Katalon Runtime Engine) cần license activation để chạy. Nếu không có license, bạn sẽ gặp lỗi:
```
Activation failed: No Offline License or you have forgot to put in your -apiKey command for online activation.
```

## 🔑 CÁCH 1: SỬ DỤNG API KEY (Khuyến nghị cho CI/CD)

### Bước 1: Lấy API Key từ Katalon

1. Đăng nhập vào [Katalon TestOps](https://testops.katalon.io/)
2. Vào **Settings** → **API Keys**
3. Tạo API key mới hoặc copy API key hiện có

### Bước 2: Thêm API Key vào GitHub Secrets

1. Vào repository trên GitHub
2. Vào **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `KATALON_API_KEY`
5. Value: Paste API key của bạn
6. Click **Add secret**

### Bước 3: Uncomment dòng trong workflow

Mở file `.github/workflows/katalon-tests.yml` và uncomment dòng:
```yaml
KATALON_API_KEY: ${{ secrets.KATALON_API_KEY }}
```

Hiện tại dòng này đã được comment, bạn chỉ cần xóa dấu `#` ở đầu dòng.

---



## 📄 CÁCH 2: SỬ DỤNG OFFLINE LICENSE

### Bước 1: Lấy Offline License từ Katalon Studio

1. Mở **Katalon Studio** (GUI version)
2. Vào **Help** → **Manage License**
3. Chọn **Offline License**
4. Download license file

### Bước 2: Đặt License File vào Thư Mục

Đặt license file vào thư mục:
```
C:\Users\<TênUser>\.katalon\license\
```

**Ví dụ:**
```
C:\Users\feu29\.katalon\license\license.lic
```

### Bước 3: Kiểm Tra License

Workflow sẽ tự động kiểm tra license trong thư mục này khi chạy.

---

## ✅ KIỂM TRA LICENSE ĐÃ HOẠT ĐỘNG

Sau khi setup license, chạy workflow và kiểm tra log. Bạn sẽ thấy:
- ✅ "Using API key for license activation" (nếu dùng API key)
- ✅ "Found offline license files" (nếu dùng offline license)
- ✅ Không còn lỗi "Activation failed"

---

## 🔍 TROUBLESHOOTING

### Lỗi: "Activation failed"

**Nguyên nhân:**
- API key không đúng hoặc chưa được set
- Offline license không hợp lệ hoặc đã hết hạn
- License không đúng cho KRE (cần license cho Runtime Engine)

**Giải pháp:**
1. Kiểm tra API key trong GitHub Secrets
2. Kiểm tra license file có trong thư mục `C:\Users\<User>\.katalon\license\`
3. Đảm bảo license còn hiệu lực
4. Đảm bảo license là cho **Katalon Runtime Engine**, không phải Katalon Studio

### Lỗi: "BundleContext is no longer valid"

Đây là warning từ bundle `com.kms.katalon.ai` và thường không ảnh hưởng đến việc chạy tests. Nếu tests vẫn chạy thành công, bạn có thể bỏ qua warning này.

---

## 📝 LƯU Ý

- **API Key** là cách tốt nhất cho CI/CD vì không cần quản lý file
- **Offline License** cần được đặt trên máy runner và có thể cần cập nhật định kỳ
- License cho KRE khác với license cho Katalon Studio GUI
- Đảm bảo license còn hiệu lực trước khi chạy tests

