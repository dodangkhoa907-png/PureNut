-- Migration: Add ProfileImage column to Users table
-- Stores cropped avatar as base64 data URI (small, ~10-20KB per user)
IF COL_LENGTH('dbo.Users', 'ProfileImage') IS NULL
BEGIN
    ALTER TABLE Users ADD ProfileImage NVARCHAR(MAX) NULL;
END
GO
