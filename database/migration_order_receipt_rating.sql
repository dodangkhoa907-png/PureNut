/* ================================================================
   PureNut — Xác nhận nhận hàng + đánh giá giao hàng (khách hàng)
   Thêm cột vào Orders. File IDEMPOTENT: chạy lại nhiều lần không lỗi.
   ================================================================ */

USE PureNut_DB;
GO

-- Thời điểm shipper báo hoàn thành (tách biệt CreatedAt của đơn)
IF COL_LENGTH('dbo.Orders', 'DeliveredAt') IS NULL
  ALTER TABLE Orders ADD DeliveredAt DATETIME NULL;
GO

-- Thời điểm khách hàng xác nhận đã nhận hàng
IF COL_LENGTH('dbo.Orders', 'ReceivedConfirmedAt') IS NULL
  ALTER TABLE Orders ADD ReceivedConfirmedAt DATETIME NULL;
GO

-- Đánh giá giao hàng của khách (1-5 sao, tùy chọn)
IF COL_LENGTH('dbo.Orders', 'DeliveryRating') IS NULL
  ALTER TABLE Orders ADD DeliveryRating INT NULL;
GO

-- Nhận xét kèm theo (tùy chọn)
IF COL_LENGTH('dbo.Orders', 'DeliveryReview') IS NULL
  ALTER TABLE Orders ADD DeliveryReview NVARCHAR(500) NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Orders_DeliveryRating')
  ALTER TABLE Orders WITH NOCHECK ADD CONSTRAINT CK_Orders_DeliveryRating
    CHECK (DeliveryRating IS NULL OR DeliveryRating BETWEEN 1 AND 5);
GO

PRINT N'Đã thêm DeliveredAt, ReceivedConfirmedAt, DeliveryRating, DeliveryReview vào Orders.';
