/*
==========================================================
Create Database and Schemas
==========================================================
Script:

This scripts creat a Database "DataWarehouse" after checking if it is already exists, 
if database exist, it is dropped and recreated Additionaly this scripts sets 
three schemas within database : "bronze", "silver", "gold".

Warning: 
	Running this script will drop the entire "DataWarehouse" databse if it exists
	All the date in this database will be deleted permanently. Proceed with caution and
	ensure you have proper backup before running this script.

	*/





--- Create Database 'DataWarehouse'

USE master;
GO
--- Drop and recreate database 'DataWarehouse'
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROOLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;

GO


--- Create Database 'DataWarehouse'
CREATE DATABASE DataWarehouse;
GO
USE DataWarehouse;
GO

--Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
