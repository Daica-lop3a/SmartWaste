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
/* =========================================================
   SmartWaste - MORE SAMPLE DATA
   Chạy file này SAU KHI đã chạy SmartWaste.sql
   Không tạo lại database, chỉ thêm dữ liệu mẫu.
   ========================================================= */
GO

/* =========================================================
   1. THÊM USERS
   ========================================================= */
INSERT INTO tblUsers
(userID, fullName, email, phoneNumber, roleID, password, status)
VALUES
('mgr2', N'Nguyễn Minh Quản Lý', 'manager2@smartwaste.com', '0906666666', 'MGR', '123456', 1),
('mgr3', N'Lê Hoàng Quản Lý', 'manager3@smartwaste.com', '0907777777', 'MGR', '123456', 1),
('staff3', N'Nguyễn Văn Thu Gom', 'staff3@smartwaste.com', '0908888888', 'STF', '123456', 1),
('staff4', N'Trần Văn Thu Gom', 'staff4@smartwaste.com', '0909999999', 'STF', '123456', 1),
('staff5', N'Phạm Minh Thu Gom', 'staff5@smartwaste.com', '0911111111', 'STF', '123456', 1),
('staff6', N'Đỗ Quốc Vận Chuyển', 'staff6@smartwaste.com', '0912222222', 'STF', '123456', 1),
('staff7', N'Võ Thành Vận Chuyển', 'staff7@smartwaste.com', '0913333333', 'STF', '123456', 1),
('tec2', N'Nguyễn Hoàng Kỹ Thuật', 'tech2@smartwaste.com', '0914444444', 'TEC', '123456', 1),
('tec3', N'Trần Minh Kỹ Thuật', 'tech3@smartwaste.com', '0915555555', 'TEC', '123456', 1),
('tec4', N'Phạm Quốc Kỹ Thuật', 'tech4@smartwaste.com', '0916666666', 'TEC', '123456', 1);
GO

/* =========================================================
   2. THÊM AREAS
   ========================================================= */
INSERT INTO tblAreas (areaID, areaName, description)
VALUES
('area3', N'Khu vực Quận 1 - Nguyễn Huệ', N'Phố đi bộ và khu vực trung tâm thành phố'),
('area4', N'Khu vực Quận 3 - Võ Văn Tần', N'Khu dân cư và tuyến đường thương mại'),
('area5', N'Khu vực Bình Thạnh - Landmark', N'Khu vực văn phòng, thương mại và dân cư'),
('area6', N'Khu vực Phú Nhuận - Phan Đình Phùng', N'Khu dân cư đông đúc'),
('area7', N'Khu vực Tân Bình - Cộng Hòa', N'Khu vực thương mại và giao thông cao'),
('area8', N'Khu vực Quận 7 - Phú Mỹ Hưng', N'Khu đô thị và khu dân cư hiện đại');
GO

/* =========================================================
   3. THÊM 30 WASTE BINS
   ========================================================= */
INSERT INTO tblWasteBins
(binID, binCode, location, capacity, currentFill, status, areaID)
VALUES
('bin4','BIN-Q1-003',N'Đường Đồng Khởi',240,32.0,'Active','area1'),
('bin5','BIN-Q1-004',N'Đường Lê Thánh Tôn',240,67.0,'Active','area1'),
('bin6','BIN-Q1-005',N'Đường Nguyễn Huệ - Cổng Bắc',500,81.0,'Active','area3'),
('bin7','BIN-Q1-006',N'Đường Nguyễn Huệ - Cổng Nam',500,94.0,'Full','area3'),

('bin8','BIN-Q3-002',N'Đường Nguyễn Thị Minh Khai',240,28.0,'Active','area2'),
('bin9','BIN-Q3-003',N'Đường Điện Biên Phủ',240,73.0,'Active','area2'),
('bin10','BIN-Q3-004',N'Đường Võ Văn Tần',500,58.0,'Active','area4'),
('bin11','BIN-Q3-005',N'Đường Nam Kỳ Khởi Nghĩa',500,91.0,'Full','area4'),

('bin12','BIN-BT-001',N'Gần Landmark 81',500,76.0,'Active','area5'),
('bin13','BIN-BT-002',N'Đường Nguyễn Hữu Cảnh',500,44.0,'Active','area5'),
('bin14','BIN-BT-003',N'Đường Xô Viết Nghệ Tĩnh',240,86.0,'Active','area5'),
('bin15','BIN-BT-004',N'Đường Phan Văn Hân',240,97.0,'Full','area5'),

('bin16','BIN-PN-001',N'Đường Phan Đình Phùng',240,35.0,'Active','area6'),
('bin17','BIN-PN-002',N'Đường Phan Xích Long',500,69.0,'Active','area6'),
('bin18','BIN-PN-003',N'Đường Nguyễn Văn Trỗi',500,83.0,'Active','area6'),
('bin19','BIN-PN-004',N'Đường Hoa Lan',240,22.0,'Active','area6'),

('bin20','BIN-TB-001',N'Đường Cộng Hòa',500,79.0,'Active','area7'),
('bin21','BIN-TB-002',N'Đường Hoàng Văn Thụ',500,52.0,'Active','area7'),
('bin22','BIN-TB-003',N'Đường Trường Sơn',500,93.0,'Full','area7'),
('bin23','BIN-TB-004',N'Đường Bạch Đằng',240,61.0,'Active','area7'),

('bin24','BIN-Q7-001',N'Đường Nguyễn Văn Linh - Khu A',500,47.0,'Active','area8'),
('bin25','BIN-Q7-002',N'Đường Nguyễn Văn Linh - Khu B',500,88.0,'Active','area8'),
('bin26','BIN-Q7-003',N'Khu đô thị Phú Mỹ Hưng',500,96.0,'Full','area8'),
('bin27','BIN-Q7-004',N'Đường Hà Huy Tập',240,38.0,'Active','area8'),

('bin28','BIN-Q1-007',N'Đường Pasteur',240,72.0,'Active','area1'),
('bin29','BIN-Q1-008',N'Đường Hai Bà Trưng',240,84.0,'Active','area1'),
('bin30','BIN-Q3-006',N'Đường Trần Quốc Thảo',500,66.0,'Active','area4'),
('bin31','BIN-BT-005',N'Đường Đinh Bộ Lĩnh',500,89.0,'Active','area5'),
('bin32','BIN-PN-005',N'Đường Trần Huy Liệu',240,31.0,'Active','area6'),
('bin33','BIN-TB-005',N'Đường Âu Cơ',500,92.0,'Full','area7');
GO

/* =========================================================
   4. THÊM COLLECTION REQUESTS
   ========================================================= */
INSERT INTO tblCollectionRequests
(requestID, binID, staffID, status, priority, createdDate, notes)
VALUES
('req3','bin7','staff3','Pending','Emergency','2026-10-03 06:10:00',N'Thùng đạt trên 90%, cần thu gom ngay'),
('req4','bin11','staff4','In_Progress','High','2026-10-03 05:45:00',N'Đang trên tuyến thu gom'),
('req5','bin15','staff5','Completed','High','2026-10-02 18:30:00',N'Đã hoàn tất thu gom'),
('req6','bin22','staff6','Pending','Emergency','2026-10-03 06:30:00',N'Có nguy cơ tràn rác'),
('req7','bin26','staff7','In_Progress','Emergency','2026-10-03 06:00:00',N'Đang xử lý thùng đầy'),
('req8','bin33','staff3','Pending','High','2026-10-03 06:40:00',N'Thùng gần đầy'),
('req9','bin6','staff4','Completed','High','2026-10-02 17:20:00',N'Đã thu gom'),
('req10','bin18','staff5','Completed','Normal','2026-10-02 15:10:00',N'Đã thu gom theo lịch'),
('req11','bin20','staff6','In_Progress','High','2026-10-03 05:30:00',N'Đang thu gom'),
('req12','bin25','staff7','Pending','High','2026-10-03 06:50:00',N'Chờ nhân viên xác nhận'),
('req13','bin29','staff3','Completed','Normal','2026-10-01 16:20:00',N'Hoàn thành'),
('req14','bin31','staff4','Pending','High','2026-10-03 06:55:00',N'Cần thu gom trong ca sáng'),
('req15','bin3','staff5','Completed','Emergency','2026-10-01 12:10:00',N'Đã xử lý tình trạng tràn'),
('req16','bin14','staff6','Completed','High','2026-10-02 10:20:00',N'Đã hoàn tất'),
('req17','bin21','staff7','Pending','Normal','2026-10-03 07:00:00',N'Chờ lập tuyến'),
('req18','bin28','staff3','In_Progress','High','2026-10-03 06:25:00',N'Đang trên đường'),
('req19','bin10','staff4','Completed','Normal','2026-10-02 09:30:00',N'Hoàn tất'),
('req20','bin12','staff5','Pending','High','2026-10-03 06:15:00',N'Mức rác tăng nhanh'),
('req21','bin17','staff6','Completed','Normal','2026-10-02 14:30:00',N'Đã thu gom'),
('req22','bin30','staff7','In_Progress','High','2026-10-03 06:45:00',N'Đang xử lý');
GO

/* =========================================================
   5. THÊM ALERTS
   ========================================================= */
INSERT INTO tblAlerts
(alertID, binID, alertType, message, createdDate, isResolved)
VALUES
('alt3','bin7','Overflow',N'BIN-Q1-006 đạt 94%, nguy cơ tràn.', '2026-10-03 06:05:00',0),
('alt4','bin11','Overflow',N'BIN-Q3-005 đạt 91%, cần thu gom.', '2026-10-03 05:40:00',0),
('alt5','bin15','Overflow',N'BIN-BT-004 đạt 97%, đã phát sinh cảnh báo tràn.', '2026-10-02 18:20:00',1),
('alt6','bin22','Overflow',N'BIN-TB-003 đạt 93%, cần xử lý khẩn cấp.', '2026-10-03 06:25:00',0),
('alt7','bin26','Overflow',N'BIN-Q7-003 đạt 96%, nguy cơ tràn cao.', '2026-10-03 05:55:00',0),
('alt8','bin33','Overflow',N'BIN-TB-005 đạt 92%, cần thu gom.', '2026-10-03 06:35:00',0),
('alt9','bin29','Overflow',N'BIN-Q1-008 đạt 84%, đang tăng nhanh.', '2026-10-03 04:30:00',1),
('alt10','bin31','Overflow',N'BIN-BT-005 đạt 89%, gần đầy.', '2026-10-03 06:50:00',0),
('alt11','bin18','High_Temp',N'Nhiệt độ khu vực thùng cao hơn mức theo dõi.', '2026-10-02 13:00:00',1),
('alt12','bin12','Low_Battery',N'Pin thiết bị IoT đang ở mức thấp.', '2026-10-02 11:20:00',0),
('alt13','bin20','Overflow',N'BIN-TB-001 đạt 79% và tăng nhanh.', '2026-10-03 05:15:00',0),
('alt14','bin25','Overflow',N'BIN-Q7-002 đạt 88%, gần ngưỡng thu gom.', '2026-10-03 06:40:00',0),
('alt15','bin14','High_Temp',N'Nhiệt độ thiết bị cao bất thường.', '2026-10-02 09:10:00',1),
('alt16','bin6','Overflow',N'BIN-Q1-005 đạt 81%.', '2026-10-02 16:50:00',1),
('alt17','bin17','Low_Battery',N'Pin cảm biến cần được kiểm tra.', '2026-10-02 14:00:00',1),
('alt18','bin30','Overflow',N'BIN-Q3-006 đạt 66% nhưng tốc độ tăng cao.', '2026-10-03 06:30:00',0),
('alt19','bin9','High_Temp',N'Phát hiện nhiệt độ thiết bị cao.', '2026-10-01 15:30:00',1),
('alt20','bin21','Low_Battery',N'Pin cảm biến dưới mức cảnh báo.', '2026-10-03 05:00:00',0),
('alt21','bin28','Overflow',N'BIN-Q1-007 đạt 72%, cần theo dõi.', '2026-10-03 05:50:00',0),
('alt22','bin10','Overflow',N'BIN-Q3-004 đạt 58%, tốc độ tăng cao.', '2026-10-02 08:30:00',1);
GO

/* =========================================================
   6. THÊM MAINTENANCE
   ========================================================= */
INSERT INTO tblMaintenance
(maintenanceID, binID, technicianID, maintenanceType, status,
 scheduledDate, completedDate, description)
VALUES
('mnt3','bin7','tec2','Sensor_Check','In_Progress',
 '2026-10-03 08:00:00',NULL,N'Kiểm tra cảm biến mức rác'),
('mnt4','bin12','tec3','Replacement','Pending',
 '2026-10-03 10:00:00',NULL,N'Thay pin thiết bị IoT'),
('mnt5','bin15','tec4','Repair','Completed',
 '2026-10-02 09:00:00','2026-10-02 11:00:00',N'Sửa thiết bị cảm biến'),
('mnt6','bin22','tec2','Sensor_Check','Pending',
 '2026-10-03 13:00:00',NULL,N'Kiểm tra cảm biến'),
('mnt7','bin26','tec3','Inspection','In_Progress',
 '2026-10-03 07:30:00',NULL,N'Kiểm tra tổng thể thùng'),
('mnt8','bin33','tec4','Repair','Pending',
 '2026-10-03 14:00:00',NULL,N'Kiểm tra module IoT'),
('mnt9','bin18','tec2','Inspection','Completed',
 '2026-10-01 09:00:00','2026-10-01 10:30:00',N'Kiểm tra định kỳ'),
('mnt10','bin14','tec3','Sensor_Check','Completed',
 '2026-10-02 08:00:00','2026-10-02 09:30:00',N'Kiểm tra cảm biến nhiệt độ'),
('mnt11','bin20','tec4','Replacement','Pending',
 '2026-10-04 09:00:00',NULL,N'Dự kiến thay pin'),
('mnt12','bin25','tec2','Inspection','Pending',
 '2026-10-04 10:00:00',NULL,N'Kiểm tra định kỳ'),
('mnt13','bin29','tec3','Sensor_Check','Completed',
 '2026-10-01 14:00:00','2026-10-01 15:00:00',N'Kiểm tra cảm biến'),
('mnt14','bin31','tec4','Repair','In_Progress',
 '2026-10-03 07:00:00',NULL,N'Xử lý thiết bị IoT'),
('mnt15','bin3','tec2','Inspection','Completed',
 '2026-09-30 08:00:00','2026-09-30 09:00:00',N'Kiểm tra thùng'),
('mnt16','bin6','tec3','Sensor_Check','Completed',
 '2026-10-02 13:00:00','2026-10-02 14:00:00',N'Kiểm tra cảm biến'),
('mnt17','bin10','tec4','Inspection','Completed',
 '2026-10-01 10:00:00','2026-10-01 11:00:00',N'Kiểm tra thiết bị');
GO

/* =========================================================
   7. TẠO DỮ LIỆU CẢM BIẾN - BIN READINGS
   ---------------------------------------------------------
   30 bin mới x 20 lần đọc = 600 bản ghi.
   Mỗi bản ghi cách nhau 30 phút.
   Dữ liệu được tạo theo xu hướng tăng/giảm để dùng
   cho biểu đồ lịch sử và dự báo.
   ========================================================= */

DECLARE @binNo INT = 4;
DECLARE @i INT;
DECLARE @fill INT;
DECLARE @bin VARCHAR(50);

WHILE @binNo <= 33
BEGIN
    SET @i = 0;

    WHILE @i < 20
    BEGIN
        SET @bin = 'bin' + CAST(@binNo AS VARCHAR(10));

        /*
          Tạo dữ liệu có xu hướng:
          - mỗi lần đọc thay đổi một lượng nhỏ
          - không vượt quá 100
          - có một số bin tăng nhanh để tạo biểu đồ đẹp
        */
        SET @fill =
            CASE
                WHEN @binNo IN (7,11,15,22,26,33)
                    THEN 55 + ((@i * 3 + @binNo) % 46)
                WHEN @binNo IN (12,18,25,29,31)
                    THEN 35 + ((@i * 2 + @binNo) % 56)
                ELSE
                    20 + ((@i * 3 + @binNo * 2) % 61)
            END;

        INSERT INTO tblBinReadings
        (binID, fillPercent, measuredAt)
        VALUES
        (
            @bin,
            @fill,
            DATEADD(MINUTE, -30 * @i, GETDATE())
        );

        SET @i = @i + 1;
    END;

    SET @binNo = @binNo + 1;
END;
GO

/* =========================================================
   8. CẬP NHẬT currentFill THEO READING MỚI NHẤT
   ========================================================= */
UPDATE b
SET b.currentFill = r.fillPercent,
    b.status =
        CASE
            WHEN r.fillPercent >= 90 THEN 'Full'
            ELSE 'Active'
        END
FROM tblWasteBins b
INNER JOIN
(
    SELECT binID, fillPercent,
           ROW_NUMBER() OVER (PARTITION BY binID ORDER BY measuredAt DESC, readingID DESC) AS rn
    FROM tblBinReadings
) r
ON b.binID = r.binID
WHERE r.rn = 1;
GO

/* =========================================================
   9. THỐNG KÊ SAU KHI THÊM
   ========================================================= */
SELECT 'Roles' AS TableName, COUNT(*) AS TotalRows FROM tblRoles
UNION ALL
SELECT 'Users', COUNT(*) FROM tblUsers
UNION ALL
SELECT 'Areas', COUNT(*) FROM tblAreas
UNION ALL
SELECT 'WasteBins', COUNT(*) FROM tblWasteBins
UNION ALL
SELECT 'CollectionRequests', COUNT(*) FROM tblCollectionRequests
UNION ALL
SELECT 'Alerts', COUNT(*) FROM tblAlerts
UNION ALL
SELECT 'Maintenance', COUNT(*) FROM tblMaintenance
UNION ALL
SELECT 'BinReadings', COUNT(*) FROM tblBinReadings;
GO

/* =========================================================
   10. CÁC QUERY KIỂM TRA NHANH
   ========================================================= */

-- Thùng rác đang đầy / gần đầy
SELECT *
FROM tblWasteBins
WHERE currentFill >= 80
ORDER BY currentFill DESC;
GO

-- Alert chưa xử lý
SELECT *
FROM tblAlerts
WHERE isResolved = 0
ORDER BY createdDate DESC;
GO

-- Yêu cầu thu gom đang chờ / đang xử lý
SELECT *
FROM tblCollectionRequests
WHERE status IN ('Pending', 'In_Progress')
ORDER BY createdDate DESC;
GO

-- Lịch sử cảm biến
SELECT TOP 100 *
FROM tblBinReadings
ORDER BY measuredAt DESC;
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
