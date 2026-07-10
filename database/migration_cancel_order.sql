-- Migration: Add cancel columns to Orders table
-- Run this on PureNut_DB before deploying the cancel feature

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Orders') AND name = 'CancelReason')
BEGIN
    ALTER TABLE Orders ADD CancelReason NVARCHAR(500) NULL;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Orders') AND name = 'CancelledAt')
BEGIN
    ALTER TABLE Orders ADD CancelledAt DATETIME NULL;
END
GO
