-- =====================================================================
-- BÀI TẬP: LUYỆN TẬP CÁC HÀM THÔNG DỤNG TRONG SQL
-- CƠ SỞ DỮ LIỆU: QuanLySinhVien
-- TẬP TIN: 03_Exercise_Queries.sql
-- =====================================================================

USE QuanLySinhVien;

-- ---------------------------------------------------------------------
-- YÊU CẦU 1: Hiển thị tất cả các thông tin môn học (bảng Subject) có credit lớn nhất
-- ---------------------------------------------------------------------
-- Cách 1 (Khuyên dùng): Sử dụng Subquery kết hợp hàm MAX()
-- Ưu điểm: Hiển thị đầy đủ tất cả các môn nếu có nhiều môn cùng đạt credit cao nhất
SELECT 
    SubId AS 'Mã Môn',
    SubName AS 'Tên Môn Học',
    Credit AS 'Số Tín Chỉ',
    Status AS 'Trạng Thái'
FROM Subject
WHERE Credit = (SELECT MAX(Credit) FROM Subject);

-- Cách 2: Sử dụng toán tử so sánh tập hợp >= ALL
SELECT 
    SubId AS 'Mã Môn',
    SubName AS 'Tên Môn Học',
    Credit AS 'Số Tín Chỉ',
    Status AS 'Trạng Thái'
FROM Subject
WHERE Credit >= ALL (SELECT Credit FROM Subject);

-- ---------------------------------------------------------------------
-- YÊU CẦU 2: Hiển thị các thông tin môn học có điểm thi lớn nhất
-- ---------------------------------------------------------------------
-- Mục tiêu: Tìm môn học có điểm thi (Mark) cao nhất trong toàn bộ hệ thống
-- Cách 1 (Khuyên dùng): Kết nối Subject và Mark, lọc theo điểm thi lớn nhất
SELECT 
    S.SubId AS 'Mã Môn',
    S.SubName AS 'Tên Môn Học',
    S.Credit AS 'Số Tín Chỉ',
    M.Mark AS 'Điểm Thi Cao Nhất'
FROM Subject S
INNER JOIN Mark M ON S.SubId = M.SubId
WHERE M.Mark = (SELECT MAX(Mark) FROM Mark);

-- Cách 2: Sử dụng toán tử >= ALL với Subquery
SELECT 
    S.SubId AS 'Mã Môn',
    S.SubName AS 'Tên Môn Học',
    S.Credit AS 'Số Tín Chỉ',
    M.Mark AS 'Điểm Thi Cao Nhất'
FROM Subject S
INNER JOIN Mark M ON S.SubId = M.SubId
WHERE M.Mark >= ALL (SELECT Mark FROM Mark);

-- ---------------------------------------------------------------------
-- YÊU CẦU 3: Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên,
--            xếp hạng theo thứ tự điểm giảm dần
-- ---------------------------------------------------------------------
-- Mục tiêu: Gom nhóm theo từng sinh viên, tính AVG(Mark) và sắp xếp DESC
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

-- Mở rộng: Sử dụng LEFT JOIN để hiển thị cả những sinh viên chưa có điểm (hiển thị 0 hoặc Chưa có điểm)
SELECT 
    S.StudentId AS 'Mã Sinh Viên',
    S.StudentName AS 'Tên Sinh Viên',
    S.Address AS 'Địa Chỉ',
    COALESCE(ROUND(AVG(M.Mark), 2), 0) AS 'Điểm Trung Bình'
FROM Student S
LEFT JOIN Mark M ON S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName, S.Address
ORDER BY AVG(M.Mark) DESC;
