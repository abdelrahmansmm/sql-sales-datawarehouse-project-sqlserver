/*
Creating Database and the schemas
---------
This code drops the database named 'SalesDataWarehouse' if it is exists, and creating a new one with the same name.
Additionally, this script creates three schemas within the new database: Bronze, Silver, Gold.
---------
WARNING:
Using this code will delete the entire database named 'SalesDataWarehouse', and all the data will be deleted.
Have your backup carefully before using it.
*/

USE master;
GO

-- Dropping the database if exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'SalesDataWarehouse')
BEGIN
  ALTER DATABASE SalesDataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE SalesDataWarehouse;
END;
GO;

--Creating the database
CREATE DATABASE SalesDataWarehouse;
GO

USE SalesDataWarehouse;
GO

-- Creating schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
