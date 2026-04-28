-- ============================================================
-- OS-LMS Database Setup Script
-- Run this once against (LocalDB)\MSSQLLocalDB before starting
-- the application for the first time.
-- ============================================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'iolsms_db')
BEGIN
    CREATE DATABASE iolsms_db;
END
GO

USE iolsms_db;
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'users')
BEGIN
    CREATE TABLE users (
        UserID   INT          PRIMARY KEY,
        Username VARCHAR(50)  NOT NULL UNIQUE,
        Password VARCHAR(255) NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'simulations')
BEGIN
    CREATE TABLE simulations (
        SimulationID INT PRIMARY KEY,
        UserID       INT,
        ModuleType   INT,
        FOREIGN KEY (UserID) REFERENCES users(UserID)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'results')
BEGIN
    CREATE TABLE results (
        ResultID     INT          PRIMARY KEY,
        SimulationID INT,
        DataOutput   VARCHAR(255) NOT NULL,
        FOREIGN KEY (SimulationID) REFERENCES simulations(SimulationID)
    );
END
GO
