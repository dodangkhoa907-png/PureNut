/* ================================================================
   MIGRATION COMBO & INVENTORY — Combo rule-based bundle sản phẩm,
   dùng chung tồn kho với bán lẻ + auto-expiry đơn chuyển khoản PENDING.
   Chạy 1 lần trên PureNut_DB (SSMS). An toàn chạy lại (idempotent).

   QUYẾT ĐỊNH THIẾT KẾ:
   - Combo KHÔNG có tồn kho riêng — trừ kho trực tiếp trên Products.StockQuantity
     của từng sản phẩm cụ thể khách chọn để lấp đầy rule (cùng transaction
     placeOrder hiện có).
   - ComboRules chỉ match theo CategoryID (chưa có thuộc tính Size).
   - Lựa chọn cụ thể (concrete Product picks) lưu dạng JSON phẳng
     (SelectionJson) trên CartComboItems/OrderComboItems, KHÔNG chuẩn hoá
     thành bảng con — tránh phình schema cho tính năng v1.
   - Orders.ExpiresAt: chỉ set cho PaymentMethod='BANK_TRANSFER' lúc PENDING
     (now + 15 phút). Sweep job (AppContextListener) hủy đơn PENDING quá hạn
     + hoàn kho, TÁI DÙNG restoreStock() hiện có (mở rộng để cộng thêm
     OrderComboItems). Đơn CANCELLED do hết hạn không thêm status mới, tránh
     phải sửa Set hợp lệ/rank map hardcode trong AdminOrderController.
   ================================================================ */

/* ---------- 1. BẢNG Combos — danh mục combo do admin định nghĩa ---------- */
IF OBJECT_ID('dbo.Combos', 'U') IS NULL
CREATE TABLE Combos (
  ComboID     INT IDENTITY PRIMARY KEY,
  Name        NVARCHAR(150)  NOT NULL,
  Slug        NVARCHAR(150)  UNIQUE NOT NULL,
  Description NVARCHAR(MAX)  NULL,
  ImageUrl    NVARCHAR(500)  NULL,
  ComboPrice  DECIMAL(10,2)  NOT NULL,        -- giá trọn gói cố định (không tự tính tổng SP con)
  IsActive    BIT            NOT NULL DEFAULT 1,
  IsDeleted   BIT            NOT NULL DEFAULT 0,
  CreatedAt   DATETIME       NOT NULL DEFAULT GETDATE()
);
GO

/* ---------- 2. BẢNG ComboRules — luật "N sản phẩm từ Category X" ---------- */
IF OBJECT_ID('dbo.ComboRules', 'U') IS NULL
CREATE TABLE ComboRules (
  ComboRuleID  INT IDENTITY PRIMARY KEY,
  ComboID      INT NOT NULL FOREIGN KEY REFERENCES Combos(ComboID),
  CategoryID   INT NOT NULL FOREIGN KEY REFERENCES Categories(CategoryID),
  RequiredQty  INT NOT NULL,                  -- tổng số lượng SP phải chọn từ CategoryID này
  DisplayOrder INT NOT NULL DEFAULT 0
);
GO

/* ---------- 3. BẢNG CartComboItems — lựa chọn combo trong giỏ hàng ---------- */
IF OBJECT_ID('dbo.CartComboItems', 'U') IS NULL
CREATE TABLE CartComboItems (
  CartComboItemID INT IDENTITY PRIMARY KEY,
  UserID          INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
  ComboID         INT NOT NULL FOREIGN KEY REFERENCES Combos(ComboID),
  Quantity        INT NOT NULL DEFAULT 1,     -- số lần lặp lại combo này (nhân với SelectionJson)
  SelectionJson   NVARCHAR(MAX) NOT NULL,     -- '[{"productId":N,"qty":N}, ...]' cho 1 lần combo
  CreatedAt       DATETIME NOT NULL DEFAULT GETDATE()
);
GO

/* ---------- 4. BẢNG OrderComboItems — dòng combo đã đặt (snapshot) ---------- */
IF OBJECT_ID('dbo.OrderComboItems', 'U') IS NULL
CREATE TABLE OrderComboItems (
  OrderComboItemID INT IDENTITY PRIMARY KEY,
  OrderID          INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderID),
  ComboID          INT NOT NULL FOREIGN KEY REFERENCES Combos(ComboID),
  ComboName        NVARCHAR(150)  NOT NULL,   -- snapshot tên combo tại thời điểm mua
  Quantity         INT NOT NULL,
  PriceAtPurchase  DECIMAL(10,2)  NOT NULL,   -- ComboPrice tại thời điểm mua
  SelectionJson    NVARCHAR(MAX)  NOT NULL    -- snapshot lựa chọn SP cụ thể (để hoàn kho + hiển thị)
);
GO

/* ---------- 5. ALTER Orders — ExpiresAt cho reservation chuyển khoản ---------- */
IF COL_LENGTH('dbo.Orders', 'ExpiresAt') IS NULL
    ALTER TABLE Orders ADD ExpiresAt DATETIME NULL;
GO

/* ---------- 6. INDEXES ---------- */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ComboRules_Combo')
    CREATE INDEX IX_ComboRules_Combo ON ComboRules(ComboID);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_CartComboItems_User')
    CREATE INDEX IX_CartComboItems_User ON CartComboItems(UserID);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_OrderComboItems_Order')
    CREATE INDEX IX_OrderComboItems_Order ON OrderComboItems(OrderID);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Combos_Slug')
    CREATE UNIQUE INDEX IX_Combos_Slug ON Combos(Slug) WHERE IsDeleted = 0;
GO
-- Sweep query trọng tâm: WHERE Status='PENDING' AND PaymentMethod='BANK_TRANSFER' AND ExpiresAt < GETDATE()
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Orders_Expiry_Sweep')
    CREATE INDEX IX_Orders_Expiry_Sweep ON Orders(Status, PaymentMethod, ExpiresAt);
GO

/* ---------- 7. CHECK CONSTRAINTS ---------- */
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_ComboRules_Qty')
    ALTER TABLE ComboRules WITH NOCHECK ADD CONSTRAINT CK_ComboRules_Qty CHECK (RequiredQty > 0);
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Combos_Price')
    ALTER TABLE Combos WITH NOCHECK ADD CONSTRAINT CK_Combos_Price CHECK (ComboPrice >= 0);
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_CartComboItems_Qty')
    ALTER TABLE CartComboItems WITH NOCHECK ADD CONSTRAINT CK_CartComboItems_Qty CHECK (Quantity > 0);
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_OrderComboItems_Qty')
    ALTER TABLE OrderComboItems WITH NOCHECK ADD CONSTRAINT CK_OrderComboItems_Qty CHECK (Quantity > 0);
GO

/* ---------- 8. KIỂM TRA SAU MIGRATION ---------- */
SELECT 'Bang Combos' AS CheckName, COUNT(*) AS Cnt FROM Combos
UNION ALL
SELECT 'Bang ComboRules', COUNT(*) FROM ComboRules
UNION ALL
SELECT 'Bang CartComboItems', COUNT(*) FROM CartComboItems
UNION ALL
SELECT 'Bang OrderComboItems', COUNT(*) FROM OrderComboItems
UNION ALL
SELECT 'Orders co cot ExpiresAt (phai > 0)', COUNT(*) FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Orders') AND name = 'ExpiresAt';
GO
