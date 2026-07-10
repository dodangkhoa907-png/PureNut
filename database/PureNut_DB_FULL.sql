/* ╔══════════════════════════════════════════════════════════════════╗
   ║  PureNut Shop — BẢN DATABASE ĐẦY ĐỦ (ALL-IN-ONE)             ║
   ║  SQL Server · Tạo DB + Bảng + Index + Ràng buộc + Seed Data   ║
   ║  Gộp: schema.sql + upgrade_01 + upgrade_02 + tương lai        ║
   ║                                                                 ║
   ║  CÁCH CHẠY:                                                     ║
   ║    1. Mở SSMS, kết nối SQL Server                               ║
   ║    2. Chạy toàn bộ file này (F5)                                ║
   ║    3. Tài khoản admin/customer do app tự tạo lúc khởi động     ║
   ║       (BCrypt hash, xem AppContextListener.java)                ║
   ║                                                                 ║
   ║  File IDEMPOTENT: chạy lại nhiều lần không lỗi.                ║
   ╚══════════════════════════════════════════════════════════════════╝ */


/* ================================================================
   0. TẠO DATABASE (nếu chưa có)
   ================================================================ */
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'PureNut_DB')
  CREATE DATABASE PureNut_DB;
GO

USE PureNut_DB;
GO


/* ================================================================
   1. BẢNG CHÍNH — Users, Categories, Products
   ================================================================ */

-- ─── Users ───
IF OBJECT_ID('dbo.Users', 'U') IS NULL
CREATE TABLE Users (
  UserID       INT IDENTITY PRIMARY KEY,
  FullName     NVARCHAR(150)  NOT NULL,
  Email        NVARCHAR(150)  UNIQUE NOT NULL,
  Phone        NVARCHAR(20),
  PasswordHash NVARCHAR(255)  NOT NULL,
  Address      NVARCHAR(500)  NULL,
  Role         NVARCHAR(20)   DEFAULT 'CUSTOMER',     -- CUSTOMER | ADMIN
  CreatedAt    DATETIME       DEFAULT GETDATE()
);
GO

-- ─── Categories ───
IF OBJECT_ID('dbo.Categories', 'U') IS NULL
CREATE TABLE Categories (
  CategoryID INT IDENTITY PRIMARY KEY,
  Name       NVARCHAR(100) NOT NULL,
  Slug       NVARCHAR(100) UNIQUE NOT NULL
);
GO

-- ─── Products ───
IF OBJECT_ID('dbo.Products', 'U') IS NULL
CREATE TABLE Products (
  ProductID     INT IDENTITY PRIMARY KEY,
  Name          NVARCHAR(150)  NOT NULL,
  Slug          NVARCHAR(150)  UNIQUE NOT NULL,
  CategoryID    INT            FOREIGN KEY REFERENCES Categories(CategoryID),
  Description   NVARCHAR(MAX),
  Price         DECIMAL(10,2)  NOT NULL,
  ImageUrl      NVARCHAR(500),
  BgColorHex    NVARCHAR(10),
  VolumeMl      INT            DEFAULT 300,
  KcalPer100ml  INT,
  StockQuantity INT            DEFAULT 0,
  IsFeatured    BIT            DEFAULT 0,
  IsDeleted     BIT            DEFAULT 0,
  CreatedAt     DATETIME       DEFAULT GETDATE()
);
GO


/* ================================================================
   2. BẢNG GIỎ HÀNG & ĐƠN HÀNG
   ================================================================ */

-- ─── CartItems ───
IF OBJECT_ID('dbo.CartItems', 'U') IS NULL
CREATE TABLE CartItems (
  CartItemID INT IDENTITY PRIMARY KEY,
  UserID     INT       FOREIGN KEY REFERENCES Users(UserID),
  ProductID  INT       FOREIGN KEY REFERENCES Products(ProductID),
  Quantity   INT       NOT NULL DEFAULT 1,
  CreatedAt  DATETIME  DEFAULT GETDATE()
);
GO

-- ─── Orders ───
IF OBJECT_ID('dbo.Orders', 'U') IS NULL
CREATE TABLE Orders (
  OrderID       INT IDENTITY PRIMARY KEY,
  UserID        INT            FOREIGN KEY REFERENCES Users(UserID),
  FullName      NVARCHAR(150)  NOT NULL,
  Phone         NVARCHAR(20)   NOT NULL,
  Address       NVARCHAR(500)  NOT NULL,
  TotalAmount   DECIMAL(12,2)  NOT NULL,
  PaymentMethod NVARCHAR(50),                          -- COD | BANK_TRANSFER
  Status        NVARCHAR(30)   DEFAULT 'PENDING',      -- PENDING | CONFIRMED | SHIPPING | DONE | CANCELLED | PENDING_CANCEL
  CouponCode    NVARCHAR(30),
  CreatedAt     DATETIME       DEFAULT GETDATE(),
  CancelReason  NVARCHAR(500),
  CancelledAt   DATETIME
);
GO

-- ─── OrderItems ───
IF OBJECT_ID('dbo.OrderItems', 'U') IS NULL
CREATE TABLE OrderItems (
  OrderItemID     INT IDENTITY PRIMARY KEY,
  OrderID         INT           FOREIGN KEY REFERENCES Orders(OrderID),
  ProductID       INT           FOREIGN KEY REFERENCES Products(ProductID),
  Quantity        INT           NOT NULL,
  PriceAtPurchase DECIMAL(10,2) NOT NULL
);
GO


/* ================================================================
   3. BẢNG ĐÁNH GIÁ & ĐẠI LÝ
   ================================================================ */

-- ─── Reviews ───
IF OBJECT_ID('dbo.Reviews', 'U') IS NULL
CREATE TABLE Reviews (
  ReviewID  INT IDENTITY PRIMARY KEY,
  ProductID INT       FOREIGN KEY REFERENCES Products(ProductID),
  UserID    INT       FOREIGN KEY REFERENCES Users(UserID),
  Rating    INT       CHECK (Rating BETWEEN 1 AND 5),
  Comment   NVARCHAR(MAX),
  CreatedAt DATETIME  DEFAULT GETDATE()
);
GO

-- ─── DealerLeads (form "Trở thành đại lý") ───
IF OBJECT_ID('dbo.DealerLeads', 'U') IS NULL
CREATE TABLE DealerLeads (
  LeadID    INT IDENTITY PRIMARY KEY,
  FullName  NVARCHAR(150) NOT NULL,
  Phone     NVARCHAR(20)  NOT NULL,
  Email     NVARCHAR(150),
  City      NVARCHAR(150),
  Status    NVARCHAR(30)  DEFAULT 'PENDING',            -- PENDING | CONTACTED | CLOSED
  CreatedAt DATETIME      DEFAULT GETDATE()
);
GO


/* ================================================================
   4. BẢNG BẢO MẬT & AUDIT
   ================================================================ */

-- ─── PasswordResetTokens (token-link cũ, giữ tương thích) ───
IF OBJECT_ID('dbo.PasswordResetTokens', 'U') IS NULL
CREATE TABLE PasswordResetTokens (
  TokenID    INT IDENTITY PRIMARY KEY,
  UserID     INT           NOT NULL FOREIGN KEY REFERENCES Users(UserID),
  Token      NVARCHAR(80)  UNIQUE NOT NULL,
  ExpiresAt  DATETIME      NOT NULL,
  UsedAt     DATETIME      NULL,
  CreatedAt  DATETIME      DEFAULT GETDATE()
);
GO

-- ─── AuditLogs (nhật ký hành động Admin) ───
IF OBJECT_ID('dbo.AuditLogs', 'U') IS NULL
CREATE TABLE AuditLogs (
  LogID     INT IDENTITY PRIMARY KEY,
  UserID    INT           NULL FOREIGN KEY REFERENCES Users(UserID),
  Action    NVARCHAR(100) NOT NULL,                     -- LOGIN | UPDATE_PRODUCT | CHANGE_ORDER_STATUS...
  Target    NVARCHAR(200),
  Detail    NVARCHAR(MAX),
  IpAddress NVARCHAR(60),
  CreatedAt DATETIME      DEFAULT GETDATE()
);
GO


/* ================================================================
   5. BẢNG TÀI KHOẢN MỞ RỘNG
   ================================================================ */

-- ─── UserAddresses (địa chỉ giao hàng) ───
IF OBJECT_ID('dbo.UserAddresses', 'U') IS NULL
CREATE TABLE UserAddresses (
  AddressID     INT IDENTITY(1,1) PRIMARY KEY,
  UserID        INT            NOT NULL FOREIGN KEY REFERENCES Users(UserID),
  Label         NVARCHAR(50)   NOT NULL DEFAULT N'Nhà riêng',
  RecipientName NVARCHAR(100),
  Phone         VARCHAR(15),
  Province      NVARCHAR(100),
  District      NVARCHAR(100),
  Ward          NVARCHAR(100),
  Street        NVARCHAR(500)  NOT NULL,
  IsDefault     BIT            DEFAULT 0,
  CreatedAt     DATETIME2      DEFAULT GETDATE()
);
GO


/* ================================================================
   6. BẢNG TƯƠNG LAI (chuẩn bị sẵn cho các tính năng sắp tới)
   ================================================================ */

-- ─── Coupons (mã giảm giá — đang có UI ô nhập voucher ở giỏ hàng) ───
IF OBJECT_ID('dbo.Coupons', 'U') IS NULL
CREATE TABLE Coupons (
  CouponID      INT IDENTITY PRIMARY KEY,
  Code          NVARCHAR(30)   UNIQUE NOT NULL,         -- VD: PURENUT10, FREESHIP
  Description   NVARCHAR(200),
  DiscountType  NVARCHAR(20)   NOT NULL DEFAULT 'PERCENT', -- PERCENT | FIXED
  DiscountValue DECIMAL(10,2)  NOT NULL,                -- 10 = 10% hoặc 10.000đ
  MinOrderAmount DECIMAL(12,2) DEFAULT 0,               -- Đơn tối thiểu để áp dụng
  MaxDiscount   DECIMAL(12,2)  NULL,                    -- Giảm tối đa (cho PERCENT)
  UsageLimit    INT            DEFAULT NULL,             -- NULL = không giới hạn
  UsedCount     INT            DEFAULT 0,
  StartDate     DATETIME       DEFAULT GETDATE(),
  EndDate       DATETIME       NULL,                    -- NULL = không hết hạn
  IsActive      BIT            DEFAULT 1,
  CreatedAt     DATETIME       DEFAULT GETDATE()
);
GO

-- ─── Wishlists (danh sách yêu thích) ───
IF OBJECT_ID('dbo.Wishlists', 'U') IS NULL
CREATE TABLE Wishlists (
  WishlistID INT IDENTITY PRIMARY KEY,
  UserID     INT      NOT NULL FOREIGN KEY REFERENCES Users(UserID),
  ProductID  INT      NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
  CreatedAt  DATETIME DEFAULT GETDATE(),
  CONSTRAINT UQ_Wishlist_User_Product UNIQUE (UserID, ProductID)
);
GO

-- ─── TasteProfiles (hồ sơ khẩu vị — hiện đang localStorage) ───
IF OBJECT_ID('dbo.TasteProfiles', 'U') IS NULL
CREATE TABLE TasteProfiles (
  ProfileID     INT IDENTITY PRIMARY KEY,
  UserID        INT            NOT NULL UNIQUE FOREIGN KEY REFERENCES Users(UserID),
  Sweetness     NVARCHAR(10)   DEFAULT '50',             -- 0 | 25 | 50 | 100
  FavoriteNuts  NVARCHAR(500),                           -- JSON: ["hanh-nhan","oc-cho"]
  Allergies     NVARCHAR(500),                           -- JSON: ["dau-phong","me"]
  Goals         NVARCHAR(500),                           -- JSON: ["giam-can","tang-co"]
  UpdatedAt     DATETIME       DEFAULT GETDATE()
);
GO

-- ─── Subscriptions (giao sữa định kỳ — hiện đang mock data) ───
IF OBJECT_ID('dbo.Subscriptions', 'U') IS NULL
CREATE TABLE Subscriptions (
  SubscriptionID INT IDENTITY PRIMARY KEY,
  UserID         INT            NOT NULL FOREIGN KEY REFERENCES Users(UserID),
  ProductID      INT            NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
  Frequency      NVARCHAR(20)   DEFAULT 'WEEKLY',        -- WEEKLY | BIWEEKLY | MONTHLY
  Quantity       INT            DEFAULT 1,
  DiscountPct    INT            DEFAULT 10,               -- % giảm khi đăng ký định kỳ
  Status         NVARCHAR(20)   DEFAULT 'ACTIVE',         -- ACTIVE | PAUSED | CANCELLED
  NextDelivery   DATE,
  CreatedAt      DATETIME       DEFAULT GETDATE()
);
GO

-- ─── EcoReturns (chương trình trả chai — hiện đang mock data) ───
IF OBJECT_ID('dbo.EcoReturns', 'U') IS NULL
CREATE TABLE EcoReturns (
  ReturnID      INT IDENTITY PRIMARY KEY,
  UserID        INT           NOT NULL FOREIGN KEY REFERENCES Users(UserID),
  BottleCount   INT           NOT NULL DEFAULT 1,
  PointsEarned  INT           DEFAULT 0,                 -- 1 chai = X điểm
  Status        NVARCHAR(20)  DEFAULT 'PENDING',          -- PENDING | COLLECTED | CREDITED
  ScheduledDate DATE,
  CreatedAt     DATETIME      DEFAULT GETDATE()
);
GO

-- ─── ContactMessages (form liên hệ trang About) ───
IF OBJECT_ID('dbo.ContactMessages', 'U') IS NULL
CREATE TABLE ContactMessages (
  MessageID  INT IDENTITY PRIMARY KEY,
  FullName   NVARCHAR(150)  NOT NULL,
  Email      NVARCHAR(150)  NOT NULL,
  Phone      NVARCHAR(20),
  Subject    NVARCHAR(200),
  Body       NVARCHAR(MAX)  NOT NULL,
  IsRead     BIT            DEFAULT 0,
  CreatedAt  DATETIME       DEFAULT GETDATE()
);
GO


/* ================================================================
   7. INDEXES — Tăng tốc truy vấn
   ================================================================ */

-- Products
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Products_Category')
  CREATE INDEX IX_Products_Category ON Products(CategoryID, IsDeleted)
    INCLUDE (Name, Price, StockQuantity, IsFeatured);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Products_Featured')
  CREATE INDEX IX_Products_Featured ON Products(IsFeatured, IsDeleted);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Products_Slug')
  CREATE UNIQUE INDEX IX_Products_Slug ON Products(Slug) WHERE IsDeleted = 0;

-- Orders
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Orders_User')
  CREATE INDEX IX_Orders_User ON Orders(UserID, CreatedAt DESC);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Orders_Status')
  CREATE INDEX IX_Orders_Status ON Orders(Status, CreatedAt DESC);

-- CartItems
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_CartItems_User')
  CREATE INDEX IX_CartItems_User ON CartItems(UserID);

-- OrderItems
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_OrderItems_Order')
  CREATE INDEX IX_OrderItems_Order ON OrderItems(OrderID);

-- Reviews
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Reviews_Product')
  CREATE INDEX IX_Reviews_Product ON Reviews(ProductID, CreatedAt DESC);

-- DealerLeads
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DealerLeads_Status')
  CREATE INDEX IX_DealerLeads_Status ON DealerLeads(Status, CreatedAt DESC);

-- PasswordResetTokens
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_PwReset_Token')
  CREATE INDEX IX_PwReset_Token ON PasswordResetTokens(Token);

-- AuditLogs
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_AuditLogs_User')
  CREATE INDEX IX_AuditLogs_User ON AuditLogs(UserID, CreatedAt DESC);

-- UserAddresses
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_UserAddresses_UserID')
  CREATE INDEX IX_UserAddresses_UserID ON UserAddresses(UserID);

-- Wishlists
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Wishlists_User')
  CREATE INDEX IX_Wishlists_User ON Wishlists(UserID);

-- Subscriptions
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Subscriptions_User')
  CREATE INDEX IX_Subscriptions_User ON Subscriptions(UserID, Status);

-- Coupons
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Coupons_Code')
  CREATE UNIQUE INDEX IX_Coupons_Code ON Coupons(Code);
GO


/* ================================================================
   8. CHECK CONSTRAINTS — Ràng buộc toàn vẹn dữ liệu
   ================================================================ */
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
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Coupons_Value')
  ALTER TABLE Coupons WITH NOCHECK ADD CONSTRAINT CK_Coupons_Value CHECK (DiscountValue > 0);
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Subscriptions_Qty')
  ALTER TABLE Subscriptions WITH NOCHECK ADD CONSTRAINT CK_Subscriptions_Qty CHECK (Quantity > 0);
GO


/* ================================================================
   9. ADD COLUMNS — Thêm cột vào bảng cũ (nếu chưa có)
   ================================================================ */

-- Users.Address (dùng cho profile chính)
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Users') AND name = 'Address')
  ALTER TABLE Users ADD Address NVARCHAR(500) NULL;
GO


/* ================================================================
   10. SEED DATA — Categories & Products
   ================================================================ */

-- ─── Categories ───
IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'dau-nanh')
  INSERT INTO Categories (Name, Slug) VALUES (N'Dòng đậu nành', 'dau-nanh');
IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'dac-biet')
  INSERT INTO Categories (Name, Slug) VALUES (N'Dòng đặc biệt', 'dac-biet');
GO

-- ─── Products ───
DECLARE @dauNanh INT = (SELECT CategoryID FROM Categories WHERE Slug = 'dau-nanh');
DECLARE @dacBiet INT = (SELECT CategoryID FROM Categories WHERE Slug = 'dac-biet');

IF NOT EXISTS (SELECT 1 FROM Products WHERE Slug = 'dau-nanh-hanh-nhan')
INSERT INTO Products (Name, Slug, CategoryID, Description, Price, ImageUrl, BgColorHex, VolumeMl, KcalPer100ml, StockQuantity, IsFeatured)
VALUES (N'Đậu nành Hạnh Nhân', 'dau-nanh-hanh-nhan', @dauNanh,
        N'Đậu nành nguyên chất hòa quyện hạnh nhân rang, vị béo nhẹ tự nhiên, ít đường.',
        22000, '/resources/img/products/hanh-nhan.png', '#E7C9A0', 300, 56, 100, 0);

IF NOT EXISTS (SELECT 1 FROM Products WHERE Slug = 'dau-nanh-oc-cho')
INSERT INTO Products (Name, Slug, CategoryID, Description, Price, ImageUrl, BgColorHex, VolumeMl, KcalPer100ml, StockQuantity, IsFeatured)
VALUES (N'Đậu nành Óc Chó', 'dau-nanh-oc-cho', @dauNanh,
        N'Vị béo bùi đặc trưng của óc chó hòa cùng đậu nành nguyên chất, giàu Omega-3.',
        25000, '/resources/img/products/oc-cho.png', '#F3D98B', 300, 56, 100, 1);

IF NOT EXISTS (SELECT 1 FROM Products WHERE Slug = 'dau-nanh-sua-tuoi')
INSERT INTO Products (Name, Slug, CategoryID, Description, Price, ImageUrl, BgColorHex, VolumeMl, KcalPer100ml, StockQuantity, IsFeatured)
VALUES (N'Đậu nành Sữa Tươi', 'dau-nanh-sua-tuoi', @dauNanh,
        N'Đậu nành kết hợp vị sữa tươi thanh mát, dễ uống, ít đường.',
        20000, '/resources/img/products/sua-tuoi.png', '#BFE0F2', 300, 56, 100, 0);

IF NOT EXISTS (SELECT 1 FROM Products WHERE Slug = 'dau-nanh-me-den')
INSERT INTO Products (Name, Slug, CategoryID, Description, Price, ImageUrl, BgColorHex, VolumeMl, KcalPer100ml, StockQuantity, IsFeatured)
VALUES (N'Đậu nành Mè Đen', 'dau-nanh-me-den', @dauNanh,
        N'Mè đen rang thơm kết hợp đậu nành, giàu canxi và chất chống oxy hoá tự nhiên.',
        23000, '/resources/img/products/me-den.png', '#D8D3C6', 300, 58, 100, 1);

IF NOT EXISTS (SELECT 1 FROM Products WHERE Slug = 'sua-9-loai-hat')
INSERT INTO Products (Name, Slug, CategoryID, Description, Price, ImageUrl, BgColorHex, VolumeMl, KcalPer100ml, StockQuantity, IsFeatured)
VALUES (N'Sữa 9 Loại Hạt', 'sua-9-loai-hat', @dacBiet,
        N'Hoà quyện 9 loại hạt quý: hạnh nhân, óc chó, hạt sen, đậu đỏ... cho ly sữa tròn vị, không đường.',
        28000, '/resources/img/products/9-loai-hat.png', '#F0E2C0', 300, 54, 100, 1);

IF NOT EXISTS (SELECT 1 FROM Products WHERE Slug = 'sua-yen-mach')
INSERT INTO Products (Name, Slug, CategoryID, Description, Price, ImageUrl, BgColorHex, VolumeMl, KcalPer100ml, StockQuantity, IsFeatured)
VALUES (N'Sữa Yến Mạch', 'sua-yen-mach', @dacBiet,
        N'Yến mạch nguyên cám xay mịn, vị nguyên bản thanh nhẹ, giàu chất xơ.',
        21000, '/resources/img/products/yen-mach.png', '#EDE6D2', 300, 52, 100, 0);
GO

-- ─── Coupons mẫu ───
IF NOT EXISTS (SELECT 1 FROM Coupons WHERE Code = 'PURENUT10')
INSERT INTO Coupons (Code, Description, DiscountType, DiscountValue, MinOrderAmount, MaxDiscount)
VALUES ('PURENUT10', N'Giảm 10% cho đơn đầu tiên', 'PERCENT', 10, 50000, 30000);

IF NOT EXISTS (SELECT 1 FROM Coupons WHERE Code = 'FREESHIP')
INSERT INTO Coupons (Code, Description, DiscountType, DiscountValue, MinOrderAmount)
VALUES ('FREESHIP', N'Miễn phí vận chuyển', 'FIXED', 25000, 100000);

IF NOT EXISTS (SELECT 1 FROM Coupons WHERE Code = 'SUMMER25')
INSERT INTO Coupons (Code, Description, DiscountType, DiscountValue, MinOrderAmount, MaxDiscount, EndDate)
VALUES ('SUMMER25', N'Ưu đãi hè - Giảm 25%', 'PERCENT', 25, 80000, 50000, '2026-09-30');
GO


/* ================================================================
   11. KIỂM TRA KẾT QUẢ
   ================================================================ */
PRINT N'';
PRINT N'╔══════════════════════════════════════════════════╗';
PRINT N'║  PureNut_DB — Khởi tạo hoàn tất!               ║';
PRINT N'╚══════════════════════════════════════════════════╝';
PRINT N'';

SELECT 'TABLES' AS [Type], COUNT(*) AS [Count] FROM sys.tables WHERE type = 'U'
UNION ALL
SELECT 'INDEXES', COUNT(*) FROM sys.indexes WHERE name LIKE 'IX_%'
UNION ALL
SELECT 'CONSTRAINTS', COUNT(*) FROM sys.check_constraints
UNION ALL
SELECT 'CATEGORIES', COUNT(*) FROM Categories
UNION ALL
SELECT 'PRODUCTS', COUNT(*) FROM Products;
GO


/* ================================================================
   TỔNG KẾT CẤU TRÚC DATABASE
   ================================================================

   ┌─────────────────────────────────────────────────────────────┐
   │ BẢNG ĐANG DÙNG (có Model + DAO + Controller)               │
   ├─────────────────────────────────────────────────────────────┤
   │  Users            — Tài khoản (CUSTOMER / ADMIN)            │
   │  Categories       — Danh mục sản phẩm                      │
   │  Products         — Sản phẩm sữa hạt                       │
   │  CartItems        — Giỏ hàng                                │
   │  Orders           — Đơn hàng                                │
   │  OrderItems       — Chi tiết đơn hàng                       │
   │  DealerLeads      — Form đăng ký đại lý                    │
   │  AuditLogs        — Nhật ký hành động Admin                 │
   │  UserAddresses    — Địa chỉ giao hàng                      │
   ├─────────────────────────────────────────────────────────────┤
   │ BẢNG CÓ SCHEMA NHƯNG CHƯA DÙNG TRONG CODE                 │
   ├─────────────────────────────────────────────────────────────┤
   │  Reviews              — Đánh giá sản phẩm (chưa có DAO)    │
   │  PasswordResetTokens  — Token cũ (app dùng OTP session)     │
   ├─────────────────────────────────────────────────────────────┤
   │ BẢNG TƯƠNG LAI (sẵn sàng cho phát triển tiếp)              │
   ├─────────────────────────────────────────────────────────────┤
   │  Coupons          — Mã giảm giá (UI voucher đã có)          │
   │  Wishlists        — Danh sách yêu thích                     │
   │  TasteProfiles    — Hồ sơ khẩu vị (đang localStorage)      │
   │  Subscriptions    — Giao sữa định kỳ (đang mock data)      │
   │  EcoReturns       — Chương trình trả chai (đang mock data)  │
   │  ContactMessages  — Form liên hệ                            │
   └─────────────────────────────────────────────────────────────┘

   TÀI KHOẢN MẪU (do app tự tạo lúc khởi động):
     Admin:    khoaddty00210@gmail.com / Admin@123
     Customer: khachhang@gmail.com     / Customer@123

   ================================================================ */
