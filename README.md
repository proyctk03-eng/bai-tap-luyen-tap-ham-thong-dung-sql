# Bài Tập: Luyện Tập Các Hàm Thông Dụng Trong SQL (QuanLySinhVien)

Dự án thực hành và giải quyết các bài toán truy vấn nâng cao sử dụng các hàm tổng hợp (`MAX`, `AVG`, `ROUND`, `COALESCE`) kết hợp `GROUP BY`, Subquery và `ORDER BY` trên cơ sở dữ liệu **QuanLySinhVien** (MySQL).

---

## 1. Sơ Đồ Thực Thể Quan Hệ (ERD)

```mermaid
erDiagram
    CLASS ||--o{ STUDENT : "1 lớp học có nhiều học viên"
    STUDENT ||--o{ MARK : "1 học viên có nhiều điểm thi"
    SUBJECT ||--o{ MARK : "1 môn học có nhiều điểm thi"

    CLASS {
        int ClassID PK "Mã lớp"
        varchar ClassName "Tên lớp"
        datetime StartDate "Ngày khai giảng"
        bit Status "Trạng thái"
    }

    STUDENT {
        int StudentId PK "Mã học viên"
        varchar StudentName "Họ tên học viên"
        varchar Address "Địa chỉ"
        varchar Phone "Số điện thoại"
        bit Status "Trạng thái"
        int ClassId FK "Mã lớp"
    }

    SUBJECT {
        int SubId PK "Mã môn học"
        varchar SubName "Tên môn"
        tinyint Credit "Số tín chỉ"
        bit Status "Trạng thái"
    }

    MARK {
        int MarkId PK "Mã điểm"
        int SubId FK "Mã môn học"
        int StudentId FK "Mã học viên"
        float Mark "Điểm số"
        tinyint ExamTimes "Số lần thi"
    }
```

---

## 2. Giải Quyết Các Yêu Cầu Truy Vấn

### Yêu Cầu 1: Hiển thị tất cả các thông tin môn học (bảng Subject) có credit lớn nhất
Sử dụng truy vấn con (Subquery) với hàm `MAX(Credit)` để đảm bảo hiển thị đủ các môn nếu có nhiều môn đồng giải nhất:
```sql
SELECT SubId, SubName, Credit, Status
FROM Subject
WHERE Credit = (SELECT MAX(Credit) FROM Subject);
```
**Bảng kết quả mẫu:**
| SubId | SubName | Credit | Status |
| :-: | :--- | :-: | :-: |
| **4** | **RDBMS** | **10** | 1 |

*(Môn RDBMS có Credit = 10, cao nhất trong tất cả các môn: CF = 5, C = 6, HDJ = 5).*

---

### Yêu Cầu 2: Hiển thị các thông tin môn học có điểm thi lớn nhất
Kết nối bảng `Subject` và `Mark` qua khóa ngoại `SubId`, lọc các môn có điểm thi bằng điểm thi cao nhất trong toàn bộ hệ thống:
```sql
SELECT 
    S.SubId AS 'Mã Môn',
    S.SubName AS 'Tên Môn Học',
    S.Credit AS 'Số Tín Chỉ',
    M.Mark AS 'Điểm Thi Cao Nhất'
FROM Subject S
INNER JOIN Mark M ON S.SubId = M.SubId
WHERE M.Mark = (SELECT MAX(Mark) FROM Mark);
```
**Bảng kết quả mẫu:**
| Mã Môn | Tên Môn Học | Số Tín Chỉ | Điểm Thi Cao Nhất |
| :-: | :--- | :-: | :-: |
| **2** | **C** | **6** | **12** |

*(Trong bảng Mark, điểm số cao nhất là 12 thuộc về môn C thi bởi sinh viên Hùng).*

---

### Yêu Cầu 3: Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần
Kết nối bảng `Student` và `Mark`, gom nhóm theo sinh viên, tính điểm trung bình bằng `AVG(Mark)` và sắp xếp theo thứ tự giảm dần (`DESC`):
```sql
SELECT 
    S.StudentId AS 'Mã Sinh Viên',
    S.StudentName AS 'Tên Sinh Viên',
    S.Address AS 'Địa Chỉ',
    S.Phone AS 'Số Điện Thoại',
    ROUND(AVG(M.Mark), 2) AS 'Điểm Trung Bình'
FROM Student S
INNER JOIN Mark M ON S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName, S.Address, S.Phone
ORDER BY AVG(M.Mark) DESC;
```
**Bảng kết quả mẫu:**
| Mã Sinh Viên | Tên Sinh Viên | Địa Chỉ | Số Điện Thoại | Điểm Trung Bình |
| :-: | :--- | :--- | :--- | :-: |
| **1** | Hung | Ha Noi | 0912113113 | **10.00** |
| **2** | Hoa | Hai phong | NULL | **10.00** |

*(Học viên Hùng có 2 điểm: 8 và 12 $\rightarrow$ ĐTB: 10.00; Học viên Hoa có điểm: 10 $\rightarrow$ ĐTB: 10.00).*

---

## 3. Phân Tích Kỹ Thuật

1. **Tại sao nên dùng Subquery `WHERE col = (SELECT MAX(col)...)` thay vì `ORDER BY col DESC LIMIT 1`?**
   - Nếu trong CSDL có **2 môn học cùng có Credit = 10**, cách dùng `LIMIT 1` sẽ chỉ lấy ra 1 môn duy nhất và bỏ sót môn còn lại (sai sót dữ liệu).
   - Sử dụng Subquery với `MAX()` hoặc toán tử `>= ALL` đảm bảo tính toàn vẹn và trả về đầy đủ tất cả các bản ghi đồng giải nhất.
2. **Sử dụng `ROUND(AVG(Mark), 2)`:**
   - Hàm `AVG()` trả về số thực dấu phẩy động có thể có nhiều chữ số thập phân vô hạn tuần hoàn. Sử dụng `ROUND(..., 2)` giúp số liệu tài chính/học vụ hiển thị chuyên nghiệp và chính xác đến 2 chữ số thập phân.

---

## 4. Danh Mục Mã Nguồn

```
bai_tap_luyen_tap_ham_thong_dung_sql/
├── 01_QuanLySinhVien_Schema.sql          # Lược đồ tạo CSDL và 4 bảng
├── 02_Insert_Data.sql                    # Dữ liệu nạp mẫu
├── 03_Exercise_Queries.sql               # Đầy đủ 3 câu truy vấn của bài tập
└── README.md                             # Báo cáo và giải trình kỹ thuật
```
