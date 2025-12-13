# Hướng Dẫn Cấu Hình Schedule (Chạy Theo Lịch) cho GitHub Actions

## 📅 Tổng Quan

GitHub Actions cho phép chạy workflow tự động theo lịch định sẵn sử dụng **cron syntax**. Bạn có thể cấu hình để chạy tests mỗi ngày, mỗi giờ, hoặc bất kỳ lịch nào bạn muốn.

---

## ⏰ Cú Pháp Cron

Format: `minute hour day-of-month month day-of-week`

```
┌───────────── phút (0 - 59)
│ ┌───────────── giờ (0 - 23)
│ │ ┌───────────── ngày trong tháng (1 - 31)
│ │ │ ┌───────────── tháng (1 - 12)
│ │ │ │ ┌───────────── ngày trong tuần (0 - 6) (0 = Chủ nhật)
│ │ │ │ │
* * * * *
```

**Lưu ý:** GitHub Actions sử dụng **UTC timezone**, không phải giờ địa phương!

---

## 🌍 Chuyển Đổi Giờ UTC sang Giờ Việt Nam

Giờ Việt Nam = UTC + 7 giờ

**Ví dụ:**
- 2:00 AM UTC = 9:00 AM giờ Việt Nam
- 9:00 AM UTC = 4:00 PM giờ Việt Nam
- 0:00 AM UTC = 7:00 AM giờ Việt Nam

---

## 📝 Các Ví Dụ Schedule Phổ Biến

### 1. Chạy 1 Ngày 1 Lần

```yaml
schedule:
  - cron: '0 2 * * *'  # 2:00 AM UTC = 9:00 AM giờ Việt Nam
```

### 2. Chạy Mỗi Giờ

```yaml
schedule:
  - cron: '0 * * * *'  # Phút 0 của mỗi giờ
```

### 3. Chạy Mỗi 6 Giờ

```yaml
schedule:
  - cron: '0 */6 * * *'  # 0:00, 6:00, 12:00, 18:00 UTC
```

### 4. Chạy Mỗi 12 Giờ

```yaml
schedule:
  - cron: '0 */12 * * *'  # 0:00 và 12:00 UTC
```

### 5. Chạy Chỉ Vào Ngày Làm Việc (Thứ 2 - Thứ 6)

```yaml
schedule:
  - cron: '0 9 * * 1-5'  # 9:00 AM UTC (4:00 PM giờ Việt Nam) từ thứ 2 đến thứ 6
```

### 6. Chạy Vào Cuối Tuần (Thứ 7 và Chủ Nhật)

```yaml
schedule:
  - cron: '0 10 * * 0,6'  # 10:00 AM UTC (5:00 PM giờ Việt Nam) thứ 7 và chủ nhật
```

### 7. Chạy Vào Ngày Cụ Thể Trong Tháng

```yaml
schedule:
  - cron: '0 0 1 * *'  # 0:00 UTC ngày 1 mỗi tháng (7:00 AM giờ Việt Nam)
```

### 8. Chạy Vào Giờ Cụ Thể Mỗi Ngày

```yaml
schedule:
  - cron: '30 14 * * *'  # 2:30 PM UTC (9:30 PM giờ Việt Nam) mỗi ngày
```

---

## 🔧 Cách Cấu Hình

### Bước 1: Mở File Workflow

Mở file `.github/workflows/katalon-tests-kre.yml` (hoặc `katalon-tests.yml`)

### Bước 2: Thêm Schedule Trigger

Tìm phần `on:` và thêm `schedule:`:

```yaml
on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]
  workflow_dispatch:
  schedule:
    - cron: '0 2 * * *'  # Chạy mỗi ngày lúc 2:00 AM UTC
```

### Bước 3: Tính Toán Giờ UTC

Nếu bạn muốn chạy vào **9:00 AM giờ Việt Nam**:
- Giờ Việt Nam: 9:00 AM
- Trừ 7 giờ: 9:00 - 7:00 = 2:00 AM UTC
- Cron: `'0 2 * * *'`

**Công thức:** `Giờ UTC = Giờ Việt Nam - 7`

### Bước 4: Commit và Push

```bash
git add .github/workflows/katalon-tests-kre.yml
git commit -m "Add scheduled daily test runs"
git push
```

---

## ⚠️ Lưu Ý Quan Trọng

### 1. GitHub Actions có thể bị delay

- GitHub không đảm bảo chạy đúng giờ chính xác
- Có thể delay vài phút, đặc biệt vào giờ cao điểm
- Không nên dựa vào schedule cho các tác vụ time-sensitive

### 2. Repository phải có activity

- Repository phải có ít nhất 1 commit trong 60 ngày qua
- Nếu repository không hoạt động, scheduled workflows sẽ bị tạm dừng

### 3. Giới hạn

- **Public repos:** Không giới hạn
- **Private repos:** Có giới hạn minutes/month (tùy plan)

### 4. Timezone

- Luôn dùng **UTC** trong cron
- Nhớ chuyển đổi sang giờ địa phương

---

## 📊 Ví Dụ Thực Tế

### Ví dụ 1: Chạy Tests Mỗi Sáng 9:00 AM Giờ Việt Nam

```yaml
schedule:
  - cron: '0 2 * * *'  # 2:00 AM UTC = 9:00 AM giờ Việt Nam
```

### Ví dụ 2: Chạy Tests Mỗi Tối 9:00 PM Giờ Việt Nam

```yaml
schedule:
  - cron: '0 14 * * *'  # 2:00 PM UTC = 9:00 PM giờ Việt Nam
```

### Ví dụ 3: Chạy Tests 2 Lần Mỗi Ngày (Sáng và Tối)

```yaml
schedule:
  - cron: '0 2 * * *'   # 9:00 AM giờ Việt Nam
  - cron: '0 14 * * *'   # 9:00 PM giờ Việt Nam
```

### Ví dụ 4: Chạy Tests Mỗi Giờ Trong Giờ Làm Việc

```yaml
schedule:
  - cron: '0 2 * * 1-5'   # 9:00 AM giờ Việt Nam, thứ 2-6
  - cron: '0 3 * * 1-5'   # 10:00 AM giờ Việt Nam, thứ 2-6
  - cron: '0 4 * * 1-5'   # 11:00 AM giờ Việt Nam, thứ 2-6
  - cron: '0 5 * * 1-5'   # 12:00 PM giờ Việt Nam, thứ 2-6
  - cron: '0 6 * * 1-5'   # 1:00 PM giờ Việt Nam, thứ 2-6
```

---

## 🛠️ Công Cụ Hỗ Trợ

### 1. Cron Expression Generator

Có nhiều website giúp tạo cron expression:
- https://crontab.guru/
- https://cronitor.io/cron-reference

### 2. Kiểm Tra Schedule

Sau khi push, vào tab **Actions** trên GitHub:
- Click vào workflow
- Xem phần "Scheduled runs" để kiểm tra lịch chạy tiếp theo

---

## 🔍 Debug Schedule

### Kiểm tra schedule có hoạt động không:

1. Vào tab **Actions** trên GitHub
2. Click vào workflow
3. Xem phần "Scheduled runs" - sẽ hiển thị lần chạy tiếp theo
4. Nếu không thấy, kiểm tra:
   - Cron syntax có đúng không
   - Repository có activity gần đây không
   - Workflow file có được commit chưa

### Test schedule nhanh:

Để test nhanh, dùng schedule chạy mỗi phút (chỉ để test):
```yaml
schedule:
  - cron: '* * * * *'  # Mỗi phút (NHỚ XÓA SAU KHI TEST!)
```

---

## 📋 Bảng Chuyển Đổi Giờ Phổ Biến

| Giờ Việt Nam | UTC | Cron Expression |
|--------------|-----|-----------------|
| 7:00 AM | 0:00 AM | `'0 0 * * *'` |
| 8:00 AM | 1:00 AM | `'0 1 * * *'` |
| 9:00 AM | 2:00 AM | `'0 2 * * *'` |
| 10:00 AM | 3:00 AM | `'0 3 * * *'` |
| 12:00 PM | 5:00 AM | `'0 5 * * *'` |
| 2:00 PM | 7:00 AM | `'0 7 * * *'` |
| 4:00 PM | 9:00 AM | `'0 9 * * *'` |
| 6:00 PM | 11:00 AM | `'0 11 * * *'` |
| 8:00 PM | 1:00 PM | `'0 13 * * *'` |
| 9:00 PM | 2:00 PM | `'0 14 * * *'` |
| 10:00 PM | 3:00 PM | `'0 15 * * *'` |
| 11:00 PM | 4:00 PM | `'0 16 * * *'` |

---

## ✅ Checklist

- [ ] Đã tính toán giờ UTC từ giờ Việt Nam
- [ ] Đã thêm `schedule:` vào phần `on:` trong workflow
- [ ] Đã test cron syntax (dùng crontab.guru)
- [ ] Đã commit và push workflow file
- [ ] Đã kiểm tra "Scheduled runs" trong GitHub Actions tab
- [ ] Đã đợi đến giờ schedule để xác nhận workflow chạy

---

## 🎯 Kết Luận

Với schedule, bạn có thể:
- ✅ Chạy tests tự động mỗi ngày
- ✅ Chạy tests vào giờ cụ thể
- ✅ Chạy tests theo lịch tùy chỉnh
- ✅ Kết hợp với push/PR triggers

**Lưu ý:** Schedule chỉ là một trigger, bạn vẫn có thể chạy thủ công bằng `workflow_dispatch` hoặc khi push code!

---

**Chúc bạn setup schedule thành công! 🚀**

