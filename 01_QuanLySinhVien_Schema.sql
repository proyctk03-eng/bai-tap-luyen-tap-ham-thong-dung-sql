-- =====================================================================
-- BÀI TẬP: LUYỆN TẬP CÁC HÀM THÔNG DỤNG TRONG SQL
-- CƠ SỞ DỮ LIỆU: QuanLySinhVien
-- TẬP TIN: 01_QuanLySinhVien_Schema.sql
-- =====================================================================

DROP DATABASE IF EXISTS QuanLySinhVien;
CREATE DATABASE QuanLySinhVien
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE QuanLySinhVien;

-- 1. Bảng Class (Lớp học)
CREATE TABLE Class (
    ClassID   INT AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(60) NOT NULL COMMENT 'Tên lớp học',
    StartDate DATETIME    NOT NULL COMMENT 'Ngày khai giảng',
    Status    BIT         DEFAULT 1 COMMENT 'Trạng thái hoạt động'
) ENGINE=InnoDB;

-- 2. Bảng Student (Học viên)
CREATE TABLE Student (
    StudentId   INT AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(30) NOT NULL COMMENT 'Họ và tên học viên',
    Address     VARCHAR(50) COMMENT 'Địa chỉ',
    Phone       VARCHAR(20) COMMENT 'Số điện thoại',
    Status      BIT         DEFAULT 1 COMMENT 'Trạng thái',
    ClassId     INT         NOT NULL COMMENT 'Mã lớp',
    CONSTRAINT fk_student_class FOREIGN KEY (ClassId) REFERENCES Class (ClassID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. Bảng Subject (Môn học)
CREATE TABLE Subject (
    SubId   INT AUTO_INCREMENT PRIMARY KEY,
    SubName VARCHAR(30) NOT NULL COMMENT 'Tên môn học',
    Credit  TINYINT     NOT NULL DEFAULT 1 COMMENT 'Số tín chỉ',
    Status  BIT         DEFAULT 1 COMMENT 'Trạng thái',
    CONSTRAINT chk_credit CHECK (Credit >= 1)
) ENGINE=InnoDB;

-- 4. Bảng Mark (Bảng điểm)
CREATE TABLE Mark (
    MarkId    INT AUTO_INCREMENT PRIMARY KEY,
    SubId     INT   NOT NULL COMMENT 'Mã môn học',
    StudentId INT   NOT NULL COMMENT 'Mã học viên',
    Mark      FLOAT DEFAULT 0 COMMENT 'Điểm số',
    ExamTimes TINYINT DEFAULT 1 COMMENT 'Số lần thi',
    CONSTRAINT fk_mark_subject FOREIGN KEY (SubId) REFERENCES Subject (SubId)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_mark_student FOREIGN KEY (StudentId) REFERENCES Student (StudentId)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT chk_mark_range CHECK (Mark BETWEEN 0 AND 20)
) ENGINE=InnoDB;

-- Tối ưu hóa chỉ mục cho các trường thường xuyên lọc và gom nhóm
CREATE INDEX idx_student_class ON Student (ClassId);
CREATE INDEX idx_mark_student ON Mark (StudentId);
CREATE INDEX idx_mark_sub ON Mark (SubId);
CREATE INDEX idx_subject_credit ON Subject (Credit);
