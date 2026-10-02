/* =========================================================
   SmartWaste Management System - Database Script
   Chạy toàn bộ file này trong SQL Server Management Studio
   ========================================================= */

USE master;
GO

-- Xóa database cũ nếu đã tồn tại để chạy lại từ đầu không bị lỗi
IF DB_ID('SmartWasteDB') IS NOT NULL
BEGIN
    ALTER DATABASE SmartWasteDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SmartWasteDB;
END
GO

CREATE DATABASE SmartWasteDB;
GO

USE SmartWasteDB;
GO

-- 1. Bảng Vai trò / Phân quyền
CREATE TABLE tblRoles (
    roleID      VARCHAR(10)   PRIMARY KEY NOT NULL,
    roleName    NVARCHAR(50)  NOT NULL,
    description NVARCHAR(255) NULL
);
GO

-- 2. Bảng Người dùng / Tài khoản
CREATE TABLE tblUsers (
    userID      VARCHAR(50)   PRIMARY KEY NOT NULL,
    fullName    NVARCHAR(100) NOT NULL,
    email       VARCHAR(100)  NOT NULL UNIQUE,
    phoneNumber VARCHAR(15)   NOT NULL,
    roleID      VARCHAR(10)   NOT NULL,
    password    VARCHAR(50)   NOT NULL,
    status      BIT           DEFAULT 1,
    CONSTRAINT FK_Users_Role FOREIGN KEY (roleID)
        REFERENCES tblRoles(roleID),
    CONSTRAINT CK_Users_Role CHECK (roleID IN ('ADM', 'MGR', 'STF', 'TEC'))
);
GO

-- 3. Bảng Khu vực quản lý (Area)
CREATE TABLE tblAreas (
    areaID      VARCHAR(50)   PRIMARY KEY NOT NULL,
    areaName    NVARCHAR(100) NOT NULL,
    description NVARCHAR(500) NULL
);
GO

-- 4. Bảng Thùng rác thông minh (WasteBin)
CREATE TABLE tblWasteBins (
    binID          VARCHAR(50)    PRIMARY KEY NOT NULL,
    binCode        VARCHAR(50)    NOT NULL UNIQUE,
    location       NVARCHAR(255)  NOT NULL,
    capacity       FLOAT          NOT NULL, -- Dung tích (lít)
    currentFill    FLOAT          DEFAULT 0, -- Mức rác hiện tại (%)
    status         NVARCHAR(20)   NOT NULL,  -- Active, Maintenance, Full
    areaID         VARCHAR(50)    NOT NULL,
    CONSTRAINT FK_Bins_Area FOREIGN KEY (areaID)
        REFERENCES tblAreas(areaID),
    CONSTRAINT CK_Bins_Status CHECK (status IN ('Active', 'Maintenance', 'Full')),
    CONSTRAINT CK_Bins_Fill   CHECK (currentFill BETWEEN 0 AND 100)
);
GO

-- 5. Bảng Yêu cầu thu gom rác (CollectionRequest)
CREATE TABLE tblCollectionRequests (
    requestID   VARCHAR(50)    PRIMARY KEY NOT NULL,
    binID       VARCHAR(50)    NOT NULL,
    staffID     VARCHAR(50)    NULL,
    status      NVARCHAR(20)   NOT NULL, -- Pending, In_Progress, Completed
    priority    NVARCHAR(20)   NOT NULL, -- Normal, High, Emergency
    createdDate DATETIME       DEFAULT GETDATE(),
    notes       NVARCHAR(500)  NULL,
    CONSTRAINT FK_Req_Bin   FOREIGN KEY (binID)
        REFERENCES tblWasteBins(binID),
    CONSTRAINT FK_Req_Staff FOREIGN KEY (staffID)
        REFERENCES tblUsers(userID),
    CONSTRAINT CK_Req_Status   CHECK (status IN ('Pending', 'In_Progress', 'Completed')),
    CONSTRAINT CK_Req_Priority CHECK (priority IN ('Normal', 'High', 'Emergency'))
);
GO

-- 6. Bảng Cảnh báo thùng rác (Alerts)
CREATE TABLE tblAlerts (
    alertID     VARCHAR(50)    PRIMARY KEY NOT NULL,
    binID       VARCHAR(50)    NOT NULL,
    alertType   NVARCHAR(50)   NOT NULL, -- Overflow, Low_Battery, High_Temp
    message     NVARCHAR(500)  NOT NULL,
    createdDate DATETIME       DEFAULT GETDATE(),
    isResolved  BIT            DEFAULT 0,
    CONSTRAINT FK_Alerts_Bin FOREIGN KEY (binID)
        REFERENCES tblWasteBins(binID)
);
--7 bảng maintenance
GO
CREATE TABLE tblMaintenance (
    maintenanceID  VARCHAR(50)   PRIMARY KEY NOT NULL,
    binID           VARCHAR(50)   NOT NULL,
    technicianID    VARCHAR(50)   NOT NULL,
    maintenanceType NVARCHAR(50)  NOT NULL,
    status          NVARCHAR(20)  NOT NULL,
    scheduledDate   DATETIME      NULL,
    completedDate   DATETIME      NULL,
    description     NVARCHAR(500) NULL,

    CONSTRAINT FK_Maintenance_Bin
        FOREIGN KEY (binID)
        REFERENCES tblWasteBins(binID),

    CONSTRAINT FK_Maintenance_Technician
        FOREIGN KEY (technicianID)
        REFERENCES tblUsers(userID),

    CONSTRAINT CK_Maintenance_Status
        CHECK (status IN (
            'Pending',
            'In_Progress',
            'Completed',
            'Cancelled'
        )),

    CONSTRAINT CK_Maintenance_Type
        CHECK (maintenanceType IN (
            'Repair',
            'Inspection',
            'Replacement',
            'Sensor_Check'
        ))
);
GO
-- Bảng Binreading
CREATE TABLE tblBinReadings (
    readingID INT IDENTITY(1,1) PRIMARY KEY,
    binID VARCHAR(50) NOT NULL,
    fillPercent INT NOT NULL,
    measuredAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_BinReadings_Bin
        FOREIGN KEY (binID) REFERENCES tblWasteBins(binID),

    CONSTRAINT CK_BinReadings_Fill
        CHECK (fillPercent >= 0 AND fillPercent <= 100)
);
GO


-- =========================================================
-- INSERT DỮ LIỆU MẪU (DML)
-- =========================================================

-- Thêm Roles
INSERT INTO tblRoles (roleID, roleName, description) VALUES 
('ADM', N'Administrator', N'Quản trị viên toàn hệ thống'),
('MGR', N'Manager', N'Quản lý khu vực đô thị'),
('STF', N'Staff', N'Nhân viên vận hành thu gom rác'),
('TEC', N'Technician', N'Kỹ thuật viên bảo trì thiết bị IoT');
GO

-- Thêm Users (Mật khẩu mặc định: 123456)
INSERT INTO tblUsers (userID, fullName, email, phoneNumber, roleID, password, status) VALUES 
('admin1', N'Nguyễn Văn Quản Trị', 'admin@smartwaste.com', '0901111111', 'ADM', '123456', 1),
('mgr1',   N'Trần Thị Quản Lý',   'manager@smartwaste.com', '0902222222', 'MGR', '123456', 1),
('staff1', N'Lê Văn Thu Gom',     'staff1@smartwaste.com', '0903333333', 'STF', '123456', 1),
('staff2', N'Phạm Văn Vận Chuyển','staff2@smartwaste.com', '0904444444', 'STF', '123456', 1),
('tec1',   N'Hoàng Kỹ Thuật IoT',  'tech@smartwaste.com', '0905555555', 'TEC', '123456', 1);
GO

-- Thêm Areas (Khu vực)
INSERT INTO tblAreas (areaID, areaName, description) VALUES 
('area1', N'Khu vực Quận 1 - Bến Nghé', N'Khu vực trung tâm thương mại lớn'),
('area2', N'Khu vực Quận 3 - Hồ Con Rùa', N'Khu vực công cộng và trường học');
GO

-- Thêm WasteBins (Thùng rác thông minh)
INSERT INTO tblWasteBins (binID, binCode, location, capacity, currentFill, status, areaID) VALUES 
('bin1', 'BIN-Q1-001', N'Trước cổng Chợ Bến Thành', 240, 88.5, 'Full', 'area1'),
('bin2', 'BIN-Q1-002', N'Công viên Tao Đàn', 500, 45.0, 'Active', 'area1'),
('bin3', 'BIN-Q3-001', N'Vòng xoay Hồ Con Rùa', 240, 92.0, 'Full', 'area2');
GO

-- Thêm CollectionRequests (Yêu cầu thu gom)
INSERT INTO tblCollectionRequests (requestID, binID, staffID, status, priority, notes) VALUES 
('req1', 'bin1', 'staff1', 'Pending', 'High', N'Thùng rác đã đầy, cần thu gom trước giờ cao điểm'),
('req2', 'bin3', 'staff2', 'In_Progress', 'Emergency', N'Rác tràn miệng thùng, cần xử lý ngay lập tức');
GO

-- Thêm Alerts (Cảnh báo)
INSERT INTO tblAlerts (alertID, binID, alertType, message, isResolved) VALUES 
('alt1', 'bin1', 'Overflow', N'Thùng rác BIN-Q1-001 đạt 88.5% dung tích.', 0),
('alt2', 'bin3', 'Overflow', N'Thùng rác BIN-Q3-001 đạt 92% dung tích, có nguy cơ tràn.', 0);
-- thêm maintenace
GO
INSERT INTO tblMaintenance
(
    maintenanceID,
    binID,
    technicianID,
    maintenanceType,
    status,
    scheduledDate,
    completedDate,
    description
)
VALUES
(
    'mnt1',
    'bin1',
    'tec1',
    'Sensor_Check',
    'Pending',
    '2026-09-30 09:00:00',
    NULL,
    N'Kiểm tra cảm biến mức rác'
),
(
    'mnt2',
    'bin3',
    'tec1',
    'Repair',
    'In_Progress',
    '2026-09-29 14:00:00',
    NULL,
    N'Kiểm tra thiết bị IoT và cảm biến'
);
GO

-- =========================================================
-- XEM DỮ LIỆU CÁC BẢNG
-- =========================================================
SELECT * FROM tblRoles;
SELECT * FROM tblUsers;
SELECT * FROM tblAreas;
SELECT * FROM tblWasteBins;
SELECT * FROM tblCollectionRequests;
SELECT * FROM tblAlerts;
select * from tblMaintenance
GO
