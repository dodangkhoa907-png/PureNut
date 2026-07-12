/* ============================================================
   MIGRATION: Role SHIPPER + MANAGER, gán shipper cho đơn,
   ghi chú theo đơn hàng, chat nội bộ nhân viên.
   Chạy 1 lần trên DB hiện có (PureNutDB).
   ============================================================ */

/* 1. Gán shipper cho đơn hàng */
IF COL_LENGTH('dbo.Orders', 'ShipperID') IS NULL
    ALTER TABLE Orders ADD ShipperID INT NULL FOREIGN KEY REFERENCES Users(UserID);
GO

/* 2. Ghi chú trao đổi theo từng đơn (shipper ↔ manager ↔ admin) */
IF OBJECT_ID('dbo.OrderNotes', 'U') IS NULL
CREATE TABLE OrderNotes (
  NoteID    INT IDENTITY PRIMARY KEY,
  OrderID   INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderID),
  UserID    INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
  Message   NVARCHAR(500) NOT NULL,
  CreatedAt DATETIME DEFAULT GETDATE()
);
GO

/* 3. Chat chung nội bộ nhân viên (SHIPPER + MANAGER + ADMIN) */
IF OBJECT_ID('dbo.StaffMessages', 'U') IS NULL
CREATE TABLE StaffMessages (
  MessageID INT IDENTITY PRIMARY KEY,
  UserID    INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
  Message   NVARCHAR(500) NOT NULL,
  CreatedAt DATETIME DEFAULT GETDATE()
);
GO

/* Ghi chú: Users.Role giờ nhận CUSTOMER | ADMIN | SHIPPER | MANAGER
   (cột NVARCHAR(20) sẵn có — không cần ALTER) */
