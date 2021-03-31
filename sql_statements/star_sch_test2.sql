
USE DWH 
GO

CREATE DATABASE DWH

CREATE SCHEMA DWH_test_1

DROP SCHEMA DWH_test_1


Insert dbo.dateDim(Date, Day, Month, year, IsWeekend)
select 
 [Date Index] AS Date
,day([Date Index]) AS Day
,month([Date Index]) AS Month
,year([Date Index]) AS year 
,(CASE WHEN DATEPART(DW,[for_distinct_dates].[Date Index]) = 6 THEN 1 WHEN DATEPART(DW,[for_distinct_dates].[Date Index]) = 7 THEN 1 ELSE 0 END) as IsWeekend
from 
	(select distinct [Date Index] from [dbo].[staging_table_test]) AS for_distinct_dates
order by [Date Index]



WITH dateDimTest 
as 
(SELECT TOP 3 
[Job No],
[Date],
DATEPART(day, [Date]) as Day,
DATEPART(month, [Date]) as Month,
DATEPART(week, [Date]) as weekNum,
DATEPART(DW, [Date]) as weekdayName
FROM [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2])
Select * from dateDimTest;



--  ,
 
DECLARE @query nvarchar(max) = 'SELECT TOP 3 DATEPART(DW, [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date]) 
FROM [STAGE_2_DB].[BOOKING_SCH_S2].BOOKING_TB_S2 ';
EXEC sp_describe_first_result_set @query, null, 0;  


ALTER TABLE [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
ALTER COLUMN [Weekday] INT;

CREATE TABLE [DWH].[DWH_test_1].[DateDim_1_TB](
    DateDimID int IDENTITY(1,1),
    DateAltKey DATE,
    Day int,
    CalendarMonth int,
    CalendarYear int,
    CalendarQuarter int,

    AUFiscalMonth int, 
    AUFiscalYear int,
    AUFiscalQuarter int,

    Weekday int,
    CalendarWeekNth int,

    SWSFiscalWeekNth int,
    SWSFiscalYear int,
    
    IsPublicHoliday bit, 
    IsWeekend bit
)

-- Set  =>  assign values into variables
-- As => Column name 
-- Declare => declare a variable

DECLARE @TestVariable AS VARCHAR(100)='Save Our Planet'
PRINT @TestVariable


DECLARE @PurchaseName AS NVARCHAR(50)
SELECT @PurchaseName = [Name]
FROM [Purchasing].[Vendor]
WHERE BusinessEntityID = 1492
PRINT @PurchaseName


DECLARE @Year char(4)
, @Date datetime
, @Holiday datetime

SET @Year = 2010

---- New Years Day
SET @Date=CONVERT( datetime, CONVERT(varchar, YEAR( @Year ) )+'-01-01' ) 
IF DATENAME( dw, @Date ) = 'Saturday'
    SET @Date=@Date-1
ELSE IF DATENAME( dw, @Date ) = 'Sunday'
    SET @Date=@Date+1
SELECT @Date [New Years Day], DATENAME( dw, @Date ) [DayOfWeek]





-- =======================


SET DATEFIRST 1
SELECT [Job No],[Date],DATEPART(WEEKDAY, [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date]) , [Weekday]
FROM [STAGE_2_DB].[BOOKING_SCH_S2].BOOKING_TB_S2 
Where [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Weekday] != DATEPART(DW, [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date]) 
Order By [Date] DESC


USE STAGE_2_DB
GO


    AUFiscalMonth int, 
    AUFiscalYear int,
    Weekday int,
    WeekNth int,
    SWSFiscalWeekNum int,
    IsPublicHoliday bit, 
    IsWeekend bit


