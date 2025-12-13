# Hướng Dẫn Deploy Tên Miền Trên Cổng 80 Với Ngrok

## Mục Lục
1. [Cài Đặt Ngrok](#1-cài-đặt-ngrok)
2. [Cấu Hình Domain Tùy Chỉnh](#2-cấu-hình-domain-tùy-chỉnh)
3. [Deploy Trên Cổng 80](#3-deploy-trên-cổng-80)
4. [Quản Lý Ngrok Tunnel](#4-quản-lý-ngrok-tunnel)
5. [Troubleshooting](#5-troubleshooting)

---

## 1. Cài Đặt Ngrok

### 1.1. Tải Ngrok
1. Truy cập: https://ngrok.com/download
2. Tải bản Windows (64-bit)
3. Giải nén vào thư mục (ví dụ: `C:\ngrok` hoặc `E:\ngrok`)

### 1.2. Đăng Ký Tài Khoản
1. Truy cập: https://dashboard.ngrok.com/signup
2. Đăng ký tài khoản miễn phí
3. Xác thực email

### 1.3. Lấy Authtoken
1. Đăng nhập: https://dashboard.ngrok.com/get-started/your-authtoken
2. Copy authtoken (dạng: `2abc123def456ghi789jkl012mno345pq_6r7s8t9u0v1w2x3y4z5`)

### 1.4. Cấu Hình Authtoken
Mở PowerShell hoặc Command Prompt và chạy:

```powershell
# Thay [YOUR_AUTHTOKEN] bằng authtoken của bạn
ngrok config add-authtoken [YOUR_AUTHTOKEN]
```

**Ví dụ:**
```powershell
ngrok config add-authtoken 2abc123def456ghi789jkl012mno345pq_6r7s8t9u0v1w2x3y4z5
```

---

## 2. Cấu Hình Domain Tùy Chỉnh

### 2.1. Domain Miễn Phí (Ngrok Free Plan)
- Ngrok cung cấp domain miễn phí dạng: `xxxxx.ngrok-free.app`
- Domain này **thay đổi mỗi lần restart** (trừ khi dùng reserved domain)

### 2.2. Domain Cố Định (Ngrok Paid Plan - Khuyến Nghị)
1. Đăng nhập: https://dashboard.ngrok.com/domains
2. Mua domain hoặc dùng domain có sẵn
3. Reserved domain sẽ có dạng: `your-domain.ngrok-free.app` hoặc custom domain

### 2.3. Sử Dụng Domain Có Sẵn
Nếu bạn đã có domain từ lần trước:
- Domain sẽ được lưu trong tài khoản ngrok
- Có thể dùng lại domain đó

---

## 3. Deploy Trên Cổng 80

### 3.1. Kiểm Tra Ứng Dụng Đang Chạy
Đảm bảo ứng dụng của bạn đang chạy trên **localhost:80** (hoặc port khác)

**Lưu ý:** Trên Windows, port 80 thường cần quyền Administrator.

### 3.2. Chạy Ngrok Với Domain Tùy Chỉnh

#### Cách 1: Dùng Domain Cố Định (Khuyến Nghị)
```powershell
# Thay [YOUR_DOMAIN] bằng domain của bạn
ngrok http 80 --domain=[YOUR_DOMAIN]
```

**Ví dụ:**
```powershell
ngrok http 80 --domain=upward-cunning-anteater.ngrok-free.app
```

#### Cách 2: Dùng Domain Random (Miễn Phí)
```powershell
ngrok http 80
```
- Sẽ tạo domain random mỗi lần chạy
- Domain sẽ hiển thị trong output

#### Cách 3: Dùng Config File (Nhiều Tunnels)
1. Tạo file `ngrok.yml` tại: `C:\Users\[TênUser]\.ngrok2\ngrok.yml`

**Nội dung file:**
```yaml
version: "2"
authtoken: [YOUR_AUTHTOKEN]
tunnels:
  webapp:
    proto: http
    addr: 80
    domain: [YOUR_DOMAIN]
```

2. Chạy:
```powershell
ngrok start webapp
```

Hoặc chạy tất cả tunnels:
```powershell
ngrok start --all
```

### 3.3. Kiểm Tra Kết Quả
Sau khi chạy ngrok, bạn sẽ thấy output như:

```
ngrok                                                                              
                                                                                   
Session Status                online                                               
Account                       [Your Email] (Plan: Free)                           
Version                       3.x.x                                                
Region                        United States (us)                                   
Latency                       -                                                    
Web Interface                 http://127.0.0.1:4040                                
Forwarding                    https://your-domain.ngrok-free.app -> http://localhost:80
                                                                                   
Connections                   ttl     opn     rt1     rt5     p50     p90          
                              0       0       0.00    0.00    0.00    0.00        
```

**URL công khai:** `https://your-domain.ngrok-free.app`

---

## 4. Quản Lý Ngrok Tunnel

### 4.1. Xem Web Interface
Truy cập: http://127.0.0.1:4040
- Xem requests đến tunnel
- Inspect HTTP requests/responses
- Xem metrics

### 4.2. Dừng Ngrok
- Nhấn `Ctrl + C` trong terminal đang chạy ngrok
- Hoặc đóng cửa sổ terminal

### 4.3. Chạy Ngrok Ở Background (Windows Service)
#### Cách 1: Dùng Task Scheduler
1. Mở Task Scheduler
2. Create Basic Task
3. Trigger: When computer starts
4. Action: Start a program
   - Program: `C:\ngrok\ngrok.exe`
   - Arguments: `http 80 --domain=[YOUR_DOMAIN]`
5. Save

#### Cách 2: Dùng NSSM (Non-Sucking Service Manager)
1. Tải NSSM: https://nssm.cc/download
2. Cài đặt và chạy:
```powershell
nssm install NgrokService "C:\ngrok\ngrok.exe" "http 80 --domain=[YOUR_DOMAIN]"
nssm start NgrokService
```

### 4.4. Kiểm Tra Trạng Thái
```powershell
# Xem tunnels đang chạy
ngrok api tunnels list

# Xem thông tin tunnel cụ thể
ngrok api tunnels [TUNNEL_ID]
```

---

## 5. Troubleshooting

### 5.1. Lỗi: "port 80 is already in use"
**Nguyên nhân:** Port 80 đã được sử dụng bởi service khác (IIS, Apache, etc.)

**Giải pháp:**
1. Tắt service đang dùng port 80:
```powershell
# Tìm process đang dùng port 80
netstat -ano | findstr :80

# Tắt process (thay [PID] bằng Process ID)
taskkill /PID [PID] /F
```

2. Hoặc dùng port khác và forward:
```powershell
# Chạy app trên port 8080, forward qua ngrok
ngrok http 8080 --domain=[YOUR_DOMAIN]
```

### 5.2. Lỗi: "domain is already in use"
**Nguyên nhân:** Domain đang được dùng bởi tunnel khác

**Giải pháp:**
1. Tắt tất cả ngrok tunnels:
```powershell
# Tìm và kill process ngrok
taskkill /IM ngrok.exe /F
```

2. Chờ vài giây rồi chạy lại

### 5.3. Lỗi: "authtoken is invalid"
**Nguyên nhân:** Authtoken sai hoặc đã hết hạn

**Giải pháp:**
1. Lấy authtoken mới: https://dashboard.ngrok.com/get-started/your-authtoken
2. Cấu hình lại:
```powershell
ngrok config add-authtoken [NEW_AUTHTOKEN]
```

### 5.4. Lỗi: "ERR_NGROK_108" hoặc "tunnel not found"
**Nguyên nhân:** Domain không tồn tại hoặc không thuộc tài khoản

**Giải pháp:**
1. Kiểm tra domain trong dashboard: https://dashboard.ngrok.com/domains
2. Đảm bảo domain đúng format
3. Nếu dùng free plan, có thể cần reserved domain

### 5.5. Website Không Truy Cập Được
**Kiểm tra:**
1. Ứng dụng có đang chạy trên localhost:80 không?
2. Ngrok tunnel có đang chạy không? (kiểm tra http://127.0.0.1:4040)
3. Domain có đúng không?
4. Firewall có chặn không?

**Test local trước:**
```powershell
# Test ứng dụng trên localhost
curl http://localhost:80
# hoặc mở browser: http://localhost:80
```

### 5.6. Domain Thay Đổi Mỗi Lần Restart
**Nguyên nhân:** Dùng domain random (free plan)

**Giải pháp:**
1. Reserved domain (cần upgrade plan hoặc dùng free reserved domain nếu có)
2. Hoặc dùng config file với domain cố định

---

## 6. Best Practices

### 6.1. Bảo Mật
- **KHÔNG** expose production database qua ngrok
- Dùng HTTPS (ngrok tự động cung cấp)
- Giới hạn IP truy cập nếu có thể
- Dùng authentication cho ứng dụng

### 6.2. Performance
- Ngrok free plan có giới hạn bandwidth
- Dùng cho development/testing, không dùng production
- Production nên deploy lên server có IP public

### 6.3. Monitoring
- Theo dõi web interface: http://127.0.0.1:4040
- Kiểm tra logs trong dashboard: https://dashboard.ngrok.com/status
- Set up alerts nếu tunnel down

### 6.4. Backup Plan
- Lưu lại domain và authtoken
- Document cấu hình ngrok
- Có plan B nếu ngrok không hoạt động

---

## 7. Ví Dụ Thực Tế

### 7.1. Deploy Web App ASP.NET trên Port 80
```powershell
# 1. Chạy web app (giả sử đang chạy trên localhost:80)
# 2. Chạy ngrok
ngrok http 80 --domain=myapp.ngrok-free.app
```

### 7.2. Deploy API trên Port 80
```powershell
# 1. Chạy API server
# 2. Chạy ngrok
ngrok http 80 --domain=myapi.ngrok-free.app
```

### 7.3. Deploy Multiple Services
Tạo file `ngrok.yml`:
```yaml
version: "2"
authtoken: [YOUR_AUTHTOKEN]
tunnels:
  webapp:
    proto: http
    addr: 80
    domain: webapp.ngrok-free.app
  api:
    proto: http
    addr: 3000
    domain: api.ngrok-free.app
```

Chạy:
```powershell
ngrok start --all
```

---

## 8. Tài Liệu Tham Khảo

- Ngrok Documentation: https://ngrok.com/docs
- Ngrok Dashboard: https://dashboard.ngrok.com
- Ngrok API: https://ngrok.com/docs/api

---

## 9. Lưu Ý Quan Trọng

1. **Port 80 cần quyền Administrator** trên Windows
2. **Domain free plan có thể thay đổi** nếu không reserved
3. **Ngrok free plan có giới hạn** về bandwidth và connections
4. **Không dùng ngrok cho production** - chỉ dùng cho development/testing
5. **Giữ ngrok chạy** - nếu tắt, domain sẽ không hoạt động

---

## 10. Quick Start

```powershell
# 1. Cài đặt authtoken (chỉ cần làm 1 lần)
ngrok config add-authtoken [YOUR_AUTHTOKEN]

# 2. Chạy ngrok cho port 80
ngrok http 80 --domain=[YOUR_DOMAIN]

# 3. Kiểm tra tại: https://[YOUR_DOMAIN]
# 4. Xem web interface: http://127.0.0.1:4040
```

---

**Chúc bạn deploy thành công! 🚀**

