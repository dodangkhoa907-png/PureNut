/* ================================================================
   MIGRATION SHIPPER V2 — Hủy role MANAGER, module Shipper chuyên sâu
   Chạy 1 lần trên PureNut_DB (SSMS). An toàn chạy lại (idempotent).

   Kiến trúc trạng thái (QUYẾT ĐỊNH THIẾT KẾ):
   - Orders.Status        = vòng đời đơn hàng phía KHÁCH/ADMIN
                            (PENDING → CONFIRMED → SHIPPING → DONE / CANCELLED / PENDING_CANCEL)
   - Orders.DeliveryStatus = state machine GIAO HÀNG của SHIPPER
                            (ASSIGNED → PICKING_UP → DELIVERING → COMPLETED / FAILED)
   Hai cột đồng bộ: gán shipper ⇒ Status='SHIPPING' + DeliveryStatus='ASSIGNED';
   DeliveryStatus='COMPLETED' ⇒ Status='DONE'.
   Tách 2 vòng đời để KHÔNG phá vỡ checkout/admin/cancel-flow hiện có.
   ================================================================ */

/* ---------- 1. HỦY ROLE MANAGER ---------- */
-- Hạ cấp toàn bộ Manager hiện có thành Shipper (giữ tài khoản, giữ lịch sử chat/notes vì FK trỏ Users)
UPDATE Users SET Role = 'SHIPPER' WHERE Role = 'MANAGER';
GO

/* ---------- 2. BẢNG SHIPPERS — hồ sơ giao hàng + IP nội bộ ---------- */
IF OBJECT_ID('dbo.Shippers', 'U') IS NULL
CREATE TABLE Shippers (
  ShipperID    INT          NOT NULL PRIMARY KEY,          -- = Users.UserID (role SHIPPER)
  FullName     NVARCHAR(150) NOT NULL,
  Phone        VARCHAR(20)   NULL,
  VehiclePlate NVARCHAR(20)  NULL,                          -- biển số xe
  Status       VARCHAR(10)   NOT NULL DEFAULT 'ACTIVE'      -- ACTIVE | OFFLINE
               CHECK (Status IN ('ACTIVE','OFFLINE')),
  Allowed_IP   VARCHAR(200)  NULL,                          -- IP nội bộ được cấp, CSV: '192.168.1.50,192.168.1.51'
  CreatedAt    DATETIME      NOT NULL DEFAULT DATEADD(HOUR, 7, GETUTCDATE()),
  CONSTRAINT FK_Shippers_Users FOREIGN KEY (ShipperID) REFERENCES Users(UserID)
);
GO

-- Seed hồ sơ cho các user SHIPPER hiện có (Allowed_IP để NULL = chưa khóa IP, admin cấp sau)
INSERT INTO Shippers (ShipperID, FullName, Phone)
SELECT u.UserID, u.FullName, u.Phone
FROM Users u
WHERE u.Role = 'SHIPPER'
  AND NOT EXISTS (SELECT 1 FROM Shippers s WHERE s.ShipperID = u.UserID);
GO

/* ---------- 3. ALTER ORDERS — tọa độ, ảnh bằng chứng, delivery state ---------- */
IF COL_LENGTH('dbo.Orders', 'Latitude') IS NULL
    ALTER TABLE Orders ADD Latitude DECIMAL(9,6) NULL;
GO
IF COL_LENGTH('dbo.Orders', 'Longitude') IS NULL
    ALTER TABLE Orders ADD Longitude DECIMAL(9,6) NULL;
GO
IF COL_LENGTH('dbo.Orders', 'ProofImage') IS NULL
    ALTER TABLE Orders ADD ProofImage NVARCHAR(300) NULL;
GO
IF COL_LENGTH('dbo.Orders', 'DeliveryStatus') IS NULL
    ALTER TABLE Orders ADD DeliveryStatus VARCHAR(15) NULL
        CONSTRAINT CK_Orders_DeliveryStatus
        CHECK (DeliveryStatus IN ('ASSIGNED','PICKING_UP','DELIVERING','COMPLETED','FAILED'));
GO

-- ShipperID đã có từ migration_staff_roles.sql; đảm bảo tồn tại nếu DB mới
IF COL_LENGTH('dbo.Orders', 'ShipperID') IS NULL
    ALTER TABLE Orders ADD ShipperID INT NULL FOREIGN KEY REFERENCES Users(UserID);
GO

-- Backfill: đơn SHIPPING đang có shipper ⇒ coi như DELIVERING; đơn DONE có shipper ⇒ COMPLETED
UPDATE Orders SET DeliveryStatus = 'DELIVERING'
WHERE Status = 'SHIPPING' AND ShipperID IS NOT NULL AND DeliveryStatus IS NULL;
UPDATE Orders SET DeliveryStatus = 'COMPLETED'
WHERE Status = 'DONE' AND ShipperID IS NOT NULL AND DeliveryStatus IS NULL;
GO

/* ---------- 4. INDEXES cho scale ---------- */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Orders_Shipper_Delivery')
    CREATE INDEX IX_Orders_Shipper_Delivery ON Orders(ShipperID, DeliveryStatus) INCLUDE (Status, CreatedAt);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Shippers_Status')
    CREATE INDEX IX_Shippers_Status ON Shippers(Status);
GO

/* ---------- 5. KIỂM TRA SAU MIGRATION ---------- */
SELECT 'Users con role MANAGER (phai = 0)' AS CheckName, COUNT(*) AS Cnt FROM Users WHERE Role = 'MANAGER'
UNION ALL
SELECT 'Ho so Shippers', COUNT(*) FROM Shippers
UNION ALL
SELECT 'Orders co DeliveryStatus', COUNT(*) FROM Orders WHERE DeliveryStatus IS NOT NULL;
GO
