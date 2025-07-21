-- STAGE Creation --
USE ist722_netid_stage
;


GO
CREATE SCHEMA Northwind
GO


/* STEP 1: DROP STAGING TABLES IF THEY EXIST
	- **stg_date_dimension** - handled by northwind_dates
	- StgNorthwindProducts
	- StgNorthwindDates
	- **StgNorthwindOrderDetails** - handled by fact table staging
	- StgFactOrderFulfillment

*/
-- Drop foreign key constraints
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + N'.' + 
              QUOTENAME(OBJECT_NAME(parent_object_id)) + 
              N' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys;

EXEC sp_executesql @sql;


/* Drop northwind.StgNorthwindProducts | Dependencies on:  */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.StgNorthwindProducts') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE northwind.StgNorthwindProducts 

/* Drop northwind.StgNorthwindOrderDetails | Dependencies on:  */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.StgNorthwindOrderDetails') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE northwind.StgNorthwindOrderDetails

/* Drop northwind.StgFactOrderFulfillment | Dependencies on:  */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.StgFactOrderFulfillment') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE northwind.StgFactOrderFulfillment

/* Drop northwind.StgNorthwindDates | Dependencies on:  */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.StgNorthwindDates') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE northwind.StgNorthwindDates

--########################################################################################################################################################

-- STAGE Northwind Products --
--- Test Select Query ---
SELECT [ProductID]
	,[ProductName]
	,[Discontinued]
	,[CompanyName]
	,[CategoryName]
FROM [Northwind].[dbo].[Products] p
	join [Northwind].[dbo].Suppliers s
		on p.[SupplierID] = s.[SupplierID]
	join [Northwind].[dbo].Categories c
		on c.[CategoryID] = p.[CategoryID]

--- Execute Select INTO clause to stage the data ---
SELECT [ProductID]
	,[ProductName]
	,[Discontinued]
	,[CompanyName]
	,[CategoryName]
INTO [Northwind].[StgNorthwindProducts]
FROM [Northwind].[dbo].[Products] p
	join [Northwind].[dbo].Suppliers s
		on p.[SupplierID] = s.[SupplierID]
	join [Northwind].[dbo].Categories c
		on c.[CategoryID] = p.[CategoryID]

--- Validate Staging Worked ---
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10) [ProductID]
      ,[ProductName]
      ,[Discontinued]
      ,[CompanyName]
      ,[CategoryName]
  FROM [ist722_netid_stage].[northwind].[StgNorthwindProducts]

--##########################################################################################################################################

--- STAGE NORTHWIND ORDER DATES ---
---- MODIFIED FOR ACIDEMIC PURPOSES - ONLY STAGING THE DATE DATA WE NEED FROM Orders table at this time ----
SELECT min(OrderDate) as MinOrderDate
		,max(OrderDate) as MaxOrderDate
		,min(ShippedDate) as MinShippedDate
		,max(ShippedDate) as MaxShippedDate
FROM [Northwind].[dbo].[Orders]

--- Test Query ---
SELECT *
FROM [ExternalSources2].[dbo].[date_dimension]
WHERE Year between 1996 and 1998

--- STAGE ORDER DATES ---
SELECT *
INTO [northwind].[StgNorthwindDates]
FROM [ExternalSources2].[dbo].[date_dimension] -- Using ExternalSources2 rather than ExternalSources which is offline
WHERE Year between 1996 and 1998

--- Validate Staging ---
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10) [DateKey]
      ,[Date]
      ,[FullDateUK]
      ,[FullDateUSA]
      ,[DayOfMonth]
      ,[DaySuffix]
      ,[DayName]
      ,[DayOfWeekUSA]
      ,[DayOfWeekUK]
      ,[DayOfWeekInMonth]
      ,[DayOfWeekInYear]
      ,[DayOfQuarter]
      ,[DayOfYear]
      ,[WeekOfMonth]
      ,[WeekOfQuarter]
      ,[WeekOfYear]
      ,[Month]
      ,[MonthName]
      ,[MonthOfQuarter]
      ,[Quarter]
      ,[QuarterName]
      ,[Year]
      ,[YearName]
      ,[MonthYear]
      ,[MMYYYY]
      ,[FirstDayOfMonth]
      ,[LastDayOfMonth]
      ,[FirstDayOfQuarter]
      ,[LastDayOfQuarter]
      ,[FirstDayOfYear]
      ,[LastDayOfYear]
      ,[IsWeekday]
      ,[IsWeekdayYesNo]
      ,[IsHolidayUSA]
      ,[IsHolidayUSAYesNo]
      ,[HolidayNameUSA]
      ,[IsHolidayUK]
      ,[HolidayNameUK]
      ,[FiscalDayOfYear]
      ,[FiscalWeekOfYear]
      ,[FiscalMonth]
      ,[FiscalQuarter]
      ,[FiscalQuarterName]
      ,[FiscalYear]
      ,[FiscalYearName]
      ,[FiscalMonthYear]
      ,[FiscalMMYYYY]
      ,[FiscalFirstDayOfMonth]
      ,[FiscalLastDayOfMonth]
      ,[FiscalFirstDayOfQuarter]
      ,[FiscalLastDayOfQuarter]
      ,[FiscalFirstDayOfYear]
      ,[FiscalLastDayOfYear]
  FROM [ist722_netid_stage].[northwind].[StgNorthwindDates]

--############################################################################################################################################

-- STAGE FACT ORDER FULFILLMENT --
---- Test Select Query ----
SELECT [ProductID]
	,d.[OrderID]
	,[OrderDate]
	,[ShippedDate]
FROM [Northwind].[dbo].[Order Details] d
	join [Northwind].[dbo].[Orders] o
		on o.[OrderID] = d.[OrderID]

--- LOAD Stage Fact Order Fulfillment ---
SELECT [ProductID]
	,d.[OrderID]
	,[OrderDate]
	,[ShippedDate]
INTO [northwind].[StgFactOrderFulfillment]
FROM [Northwind].[dbo].[Order Details] d
	join [Northwind].[dbo].[Orders] o
		on o.[OrderID] = d.[OrderID]

--- VALIDATE Stage ---
/****** Script for SelectTopNRows command  ******/
SELECT TOP (10) [ProductID]
      ,[OrderID]
      ,[OrderDate]
      ,[ShippedDate]
  FROM [ist722_netid_stage].[northwind].[StgFactOrderFulfillment]