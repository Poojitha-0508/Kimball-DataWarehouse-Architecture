--Database Creation
CREATE DATABASE AppAnalytics;
GO

USE AppAnalytics;
GO


-- Schema Creation
CREATE SCHEMA Stg;  -- raw imported data lands here
GO
CREATE SCHEMA dw;       -- clean dimensional model lives here
GO