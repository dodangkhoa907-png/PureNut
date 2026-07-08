-- =====================================================
-- PureNut — Upgrade 02: Account Features
-- Bảng địa chỉ giao hàng + cập nhật profile
-- Chạy sau upgrade_01_hardening.sql
-- =====================================================

-- Bảng địa chỉ giao hàng của khách
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'UserAddresses')
CREATE TABLE UserAddresses (
    AddressID   INT IDENTITY(1,1) PRIMARY KEY,
    UserID      INT NOT NULL REFERENCES Users(UserID),
    Label       NVARCHAR(50)  NOT NULL DEFAULT N'Nhà riêng',
    RecipientName NVARCHAR(100),
    Phone       VARCHAR(15),
    Province    NVARCHAR(100),
    District    NVARCHAR(100),
    Ward        NVARCHAR(100),
    Street      NVARCHAR(500) NOT NULL,
    IsDefault   BIT DEFAULT 0,
    CreatedAt   DATETIME2 DEFAULT GETDATE()
);
GO

-- Index tìm theo UserID
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_UserAddresses_UserID')
    CREATE INDEX IX_UserAddresses_UserID ON UserAddresses(UserID);
GO

-- Thêm cột Address vào Users nếu chưa có (dùng cho profile chính)
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Users') AND name = 'Address')
    ALTER TABLE Users ADD Address NVARCHAR(500) NULL;
GO

PRINT N'[Upgrade 02] Hoàn tất — UserAddresses table created.';
GO
