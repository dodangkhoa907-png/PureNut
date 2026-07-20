/* ================================================================
   MIGRATION COMBO FIXED-BUNDLE — Đổi Combo từ rule-based (chọn theo
   danh mục) sang fixed-bundle (admin chọn đích danh sản phẩm cụ thể).
   Chạy SAU migration_combo_inventory.sql. An toàn chạy lại (idempotent).

   QUYẾT ĐỊNH THIẾT KẾ:
   - ComboRules (rule "N sản phẩm từ Category X") bị loại bỏ — khách
     không còn tự chọn sản phẩm để lấp combo nữa.
   - ComboItems thay thế: admin multi-select đích danh sản phẩm + số
     lượng cố định cho từng combo. Giá bán (Combos.ComboPrice) admin tự
     nhập tay, KHÔNG tự tính từ tổng giá sản phẩm con.
   - CartComboItems.SelectionJson bị xoá — không còn "lựa chọn của
     khách" để lưu (nội dung combo đã cố định sẵn trong ComboItems).
   - OrderComboItems.SelectionJson GIỮ NGUYÊN — vẫn là snapshot JSON
     [{"productId":N,"qty":N}], nhưng giờ được SERVER tự sinh từ
     ComboItems tại thời điểm đặt hàng (không phải do khách gửi lên),
     dùng để hoàn kho đúng dù sau này admin đổi nội dung combo.
   ================================================================ */

/* ---------- 1. XOÁ ComboRules (thay bằng ComboItems) ---------- */
IF OBJECT_ID('dbo.ComboRules', 'U') IS NOT NULL
    DROP TABLE ComboRules;
GO

/* ---------- 2. BẢNG ComboItems — sản phẩm cố định trong combo ---------- */
IF OBJECT_ID('dbo.ComboItems', 'U') IS NULL
CREATE TABLE ComboItems (
  ComboItemID INT IDENTITY PRIMARY KEY,
  ComboID     INT NOT NULL FOREIGN KEY REFERENCES Combos(ComboID),
  ProductID   INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
  Quantity    INT NOT NULL
);
GO

/* ---------- 3. ALTER CartComboItems — bỏ SelectionJson ---------- */
IF COL_LENGTH('dbo.CartComboItems', 'SelectionJson') IS NOT NULL
    ALTER TABLE CartComboItems DROP COLUMN SelectionJson;
GO

/* ---------- 4. INDEXES ---------- */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ComboItems_Combo')
    CREATE INDEX IX_ComboItems_Combo ON ComboItems(ComboID);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ComboItems_Product')
    CREATE INDEX IX_ComboItems_Product ON ComboItems(ProductID);
GO

/* ---------- 5. CHECK CONSTRAINTS ---------- */
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_ComboItems_Qty')
    ALTER TABLE ComboItems WITH NOCHECK ADD CONSTRAINT CK_ComboItems_Qty CHECK (Quantity > 0);
GO

/* ---------- 6. KIỂM TRA SAU MIGRATION ---------- */
SELECT 'Bang ComboRules (phai khong ton tai)' AS CheckName, COUNT(*) AS Cnt
    FROM sys.tables WHERE name = 'ComboRules'
UNION ALL
SELECT 'Bang ComboItems', COUNT(*) FROM ComboItems
UNION ALL
SELECT 'CartComboItems con cot SelectionJson (phai = 0)', COUNT(*)
    FROM sys.columns WHERE object_id = OBJECT_ID('dbo.CartComboItems') AND name = 'SelectionJson';
GO
