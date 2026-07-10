/* ============================================================
   PureNut Shop — SQL Server schema + seed data
   Chạy trong SSMS, kết nối server 14.225.217.109
   ------------------------------------------------------------
   THỨ TỰ:
     1. CREATE DATABASE PureNut_DB;   (chạy 1 lần, riêng)
     2. USE PureNut_DB;
     3. Chạy toàn bộ file này (tạo bảng + seed Categories/Products)
   Tài khoản mẫu (admin/customer) KHÔNG seed ở đây — được app tạo
   lúc khởi động bằng BCrypt (xem DataSeeder.java).
   File idempotent: chạy lại nhiều lần không lỗi.
   ============================================================ */

USE PureNut_DB;
GO

/* ---------------- Users ---------------- */
IF OBJECT_ID('dbo.Users', 'U') IS NULL
CREATE TABLE Users (
  UserID       INT IDENTITY PRIMARY KEY,
  FullName     NVARCHAR(150) NOT NULL,
  Email        NVARCHAR(150) UNIQUE NOT NULL,
  Phone        NVARCHAR(20),
  PasswordHash NVARCHAR(255) NOT NULL,
  Role         NVARCHAR(20) DEFAULT 'CUSTOMER',   -- CUSTOMER | ADMIN
  CreatedAt    DATETIME DEFAULT GETDATE()
);
GO

/* ---------------- Categories ---------------- */
IF OBJECT_ID('dbo.Categories', 'U') IS NULL
CREATE TABLE Categories (
  CategoryID INT IDENTITY PRIMARY KEY,
  Name       NVARCHAR(100) NOT NULL,
  Slug       NVARCHAR(100) UNIQUE NOT NULL
);
GO

/* ---------------- Products ---------------- */
IF OBJECT_ID('dbo.Products', 'U') IS NULL
CREATE TABLE Products (
  ProductID     INT IDENTITY PRIMARY KEY,
  Name          NVARCHAR(150) NOT NULL,
  Slug          NVARCHAR(150) UNIQUE NOT NULL,
  CategoryID    INT FOREIGN KEY REFERENCES Categories(CategoryID),
  Description   NVARCHAR(MAX),
  Price         DECIMAL(10,2) NOT NULL,
  ImageUrl      NVARCHAR(500),
  BgColorHex    NVARCHAR(10),
  VolumeMl      INT DEFAULT 300,
  KcalPer100ml  INT,
  StockQuantity INT DEFAULT 0,
  IsFeatured    BIT DEFAULT 0,
  IsDeleted     BIT DEFAULT 0,
  CreatedAt     DATETIME DEFAULT GETDATE()
);
GO

/* ---------------- CartItems ---------------- */
IF OBJECT_ID('dbo.CartItems', 'U') IS NULL
CREATE TABLE CartItems (
  CartItemID INT IDENTITY PRIMARY KEY,
  UserID     INT FOREIGN KEY REFERENCES Users(UserID),
  ProductID  INT FOREIGN KEY REFERENCES Products(ProductID),
  Quantity   INT NOT NULL DEFAULT 1,
  CreatedAt  DATETIME DEFAULT GETDATE()
);
GO

/* ---------------- Orders ---------------- */
IF OBJECT_ID('dbo.Orders', 'U') IS NULL
CREATE TABLE Orders (
  OrderID       INT IDENTITY PRIMARY KEY,
  UserID        INT FOREIGN KEY REFERENCES Users(UserID),
  FullName      NVARCHAR(150) NOT NULL,
  Phone         NVARCHAR(20) NOT NULL,
  Address       NVARCHAR(500) NOT NULL,
  TotalAmount   DECIMAL(12,2) NOT NULL,
  PaymentMethod NVARCHAR(50),                      -- COD | BANK_TRANSFER
  Status        NVARCHAR(30) DEFAULT 'PENDING',    -- PENDING|CONFIRMED|SHIPPING|DONE|CANCELLED|PENDING_CANCEL
  CouponCode    NVARCHAR(30),
  CreatedAt     DATETIME DEFAULT GETDATE(),
  CancelReason  NVARCHAR(500),
  CancelledAt   DATETIME
);
GO

/* ---------------- OrderItems ---------------- */
IF OBJECT_ID('dbo.OrderItems', 'U') IS NULL
CREATE TABLE OrderItems (
  OrderItemID     INT IDENTITY PRIMARY KEY,
  OrderID         INT FOREIGN KEY REFERENCES Orders(OrderID),
  ProductID       INT FOREIGN KEY REFERENCES Products(ProductID),
  Quantity        INT NOT NULL,
  PriceAtPurchase DECIMAL(10,2) NOT NULL
);
GO

/* ---------------- Reviews ---------------- */
IF OBJECT_ID('dbo.Reviews', 'U') IS NULL
CREATE TABLE Reviews (
  ReviewID  INT IDENTITY PRIMARY KEY,
  ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
  UserID    INT FOREIGN KEY REFERENCES Users(UserID),
  Rating    INT CHECK (Rating BETWEEN 1 AND 5),
  Comment   NVARCHAR(MAX),
  CreatedAt DATETIME DEFAULT GETDATE()
);
GO

/* ---------------- DealerLeads (form "Trở thành đại lý") ---------------- */
IF OBJECT_ID('dbo.DealerLeads', 'U') IS NULL
CREATE TABLE DealerLeads (
  LeadID    INT IDENTITY PRIMARY KEY,
  FullName  NVARCHAR(150) NOT NULL,
  Phone     NVARCHAR(20) NOT NULL,
  Email     NVARCHAR(150),
  City      NVARCHAR(150),                          -- khu vực muốn làm đại lý
  Status    NVARCHAR(30) DEFAULT 'PENDING',         -- PENDING | CONTACTED | CLOSED
  CreatedAt DATETIME DEFAULT GETDATE()
);
GO

/* ============================================================
   SEED — Categories
   ============================================================ */
IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'dau-nanh')
  INSERT INTO Categories (Name, Slug) VALUES (N'Dòng đậu nành', 'dau-nanh');
IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'dac-biet')
  INSERT INTO Categories (Name, Slug) VALUES (N'Dòng đặc biệt', 'dac-biet');
GO

/* ============================================================
   SEED — Products (giá VND là placeholder, chỉnh trong Admin)
   kcal / màu nền / hương vị lấy đúng từ landing page
   ============================================================ */
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

PRINT N'PureNut_DB schema + seed hoàn tất.';
GO
