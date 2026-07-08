/* ============================================================
   PureNut — Nâng cấp #01: Index & toàn vẹn dữ liệu
   An toàn/idempotent: chỉ THÊM mới, không sửa/không xoá dữ liệu.
   Chạy sau schema.sql, trong SSMS (USE PureNut_DB).
   ============================================================ */
USE PureNut_DB;
GO

/* ---------- Index tăng tốc truy vấn thường dùng ---------- */
-- Lọc sản phẩm theo danh mục + ẩn sản phẩm đã xoá
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Products_Category')
  CREATE INDEX IX_Products_Category ON Products(CategoryID, IsDeleted) INCLUDE (Name, Price, StockQuantity, IsFeatured);

-- Trang chủ: sản phẩm nổi bật
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Products_Featured')
  CREATE INDEX IX_Products_Featured ON Products(IsFeatured, IsDeleted);

-- Đơn hàng theo user + trạng thái + thời gian (dashboard, lịch sử)
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Orders_User')
  CREATE INDEX IX_Orders_User ON Orders(UserID, CreatedAt DESC);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Orders_Status')
  CREATE INDEX IX_Orders_Status ON Orders(Status, CreatedAt DESC);

-- Giỏ hàng theo user
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_CartItems_User')
  CREATE INDEX IX_CartItems_User ON CartItems(UserID);

-- Chi tiết đơn theo đơn
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_OrderItems_Order')
  CREATE INDEX IX_OrderItems_Order ON OrderItems(OrderID);

-- Review theo sản phẩm
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Reviews_Product')
  CREATE INDEX IX_Reviews_Product ON Reviews(ProductID, CreatedAt DESC);

-- Lead đại lý theo trạng thái
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DealerLeads_Status')
  CREATE INDEX IX_DealerLeads_Status ON DealerLeads(Status, CreatedAt DESC);
GO

/* ---------- Ràng buộc toàn vẹn (chỉ thêm nếu chưa có) ---------- */
-- Không cho số lượng / giá âm
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Products_Price')
  ALTER TABLE Products WITH NOCHECK ADD CONSTRAINT CK_Products_Price CHECK (Price >= 0);
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Products_Stock')
  ALTER TABLE Products WITH NOCHECK ADD CONSTRAINT CK_Products_Stock CHECK (StockQuantity >= 0);
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_CartItems_Qty')
  ALTER TABLE CartItems WITH NOCHECK ADD CONSTRAINT CK_CartItems_Qty CHECK (Quantity > 0);
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_OrderItems_Qty')
  ALTER TABLE OrderItems WITH NOCHECK ADD CONSTRAINT CK_OrderItems_Qty CHECK (Quantity > 0);
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Orders_Total')
  ALTER TABLE Orders WITH NOCHECK ADD CONSTRAINT CK_Orders_Total CHECK (TotalAmount >= 0);
GO

/* ---------- Bảng token đặt lại mật khẩu (bền vững, thay in-memory) ---------- */
IF OBJECT_ID('dbo.PasswordResetTokens', 'U') IS NULL
CREATE TABLE PasswordResetTokens (
  TokenID    INT IDENTITY PRIMARY KEY,
  UserID     INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
  Token      NVARCHAR(80) UNIQUE NOT NULL,
  ExpiresAt  DATETIME NOT NULL,
  UsedAt     DATETIME NULL,
  CreatedAt  DATETIME DEFAULT GETDATE()
);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_PwReset_Token')
  CREATE INDEX IX_PwReset_Token ON PasswordResetTokens(Token);
GO

/* ---------- Bảng nhật ký hành động Admin (audit log) ---------- */
IF OBJECT_ID('dbo.AuditLogs', 'U') IS NULL
CREATE TABLE AuditLogs (
  LogID     INT IDENTITY PRIMARY KEY,
  UserID    INT NULL FOREIGN KEY REFERENCES Users(UserID),
  Action    NVARCHAR(100) NOT NULL,   -- LOGIN | UPDATE_PRODUCT | CHANGE_ORDER_STATUS...
  Target    NVARCHAR(200),            -- đối tượng tác động
  Detail    NVARCHAR(MAX),
  IpAddress NVARCHAR(60),
  CreatedAt DATETIME DEFAULT GETDATE()
);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_AuditLogs_User')
  CREATE INDEX IX_AuditLogs_User ON AuditLogs(UserID, CreatedAt DESC);
GO

PRINT N'Nâng cấp #01 (index + ràng buộc + reset tokens + audit log) hoàn tất.';
GO
