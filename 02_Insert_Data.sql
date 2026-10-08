-- =====================================================================
-- BÀI TẬP: LUYỆN TẬP CÁC HÀM THÔNG DỤNG TRONG SQL
-- CƠ SỞ DỮ LIỆU: QuanLySinhVien
-- TẬP TIN: 02_Insert_Data.sql
-- =====================================================================

USE QuanLySinhVien;

-- 1. Chèn dữ liệu bảng Class
INSERT INTO Class (ClassID, ClassName, StartDate, Status)
VALUES 
    (1, 'A1', '2008-12-20', 1),
    (2, 'A2', '2008-12-22', 1),
    (3, 'B3', CURRENT_DATE, 0);

-- 2. Chèn dữ liệu bảng Student
INSERT INTO Student (StudentId, StudentName, Address, Phone, Status, ClassId)
VALUES 
    (1, 'Hung', 'Ha Noi', '0912113113', 1, 1),
    (2, 'Hoa', 'Hai phong', NULL, 1, 1),
    (3, 'Manh', 'HCM', '0123123123', 0, 2);

-- 3. Chèn dữ liệu bảng Subject
INSERT INTO Subject (SubId, SubName, Credit, Status)
VALUES 
    (1, 'CF', 5, 1),
    (2, 'C', 6, 1),
    (3, 'HDJ', 5, 1),
    (4, 'RDBMS', 10, 1);

-- 4. Chèn dữ liệu bảng Mark
INSERT INTO Mark (SubId, StudentId, Mark, ExamTimes)
VALUES 
    (1, 1, 8, 1),
    (1, 2, 10, 2),
    (2, 1, 12, 1);
