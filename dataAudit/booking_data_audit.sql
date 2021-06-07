-- Inspect sql server Agent jobs
EXEC sp_who
GO

-- Inspect CDC table 
DECLARE @begin binary(10), @end binary(10)
SET @begin = sys.fn_cdc_get_min_lsn('BOOKING_STAGE_TABLE_1');
SET @end = sys.fn_cdc_get_max_lsn();
SELECT * FROM [cdc].[fn_cdc_get_all_changes_BOOKING_STAGE_TABLE_1](@begin, @end, N'ALL')


USE STAGE_TABLES_DB_1
GO

-- Check customer number
SELECT [Customer number], count([Customer number])
FROM [BOOKING].[STAGE_TABLE_1]
GROUP BY [BOOKING].[STAGE_TABLE_1].[Customer number] 
ORDER BY [BOOKING].[STAGE_TABLE_1].[Customer number] ASC

SELECT * FROM 
[BOOKING].[STAGE_TABLE_1]
WHERE [BOOKING].[STAGE_TABLE_1].[Customer number] = 


SELECT [Date], count(*), count([Date])
FROM [BOOKING].[STAGE_TABLE_1]
WHERE [BOOKING].[STAGE_TABLE_1].[Date] >= '20210101'
GROUP BY [BOOKING].[STAGE_TABLE_1].[Date]
-- GROUP BY [BOOKING].[STAGE_TABLE_1].[Weekday]
ORDER BY [BOOKING].[STAGE_TABLE_1].[Date] DESC

-- Date Record inspect - 
-- Inspect distinct date, that week day not null
-- 2021 - 61 => up until 02/ Mar / 2021  > ok
-- 2020 - 366 day > ok
-- 2019 - 365 day > ok
-- 2018 - 365 day > ok
-- 2017 - 365 day > ok
-- 2016 - 125

SELECT count(DISTINCT [Date]) as counting 
FROM [BOOKING].[STAGE_TABLE_1]
WHERE [BOOKING].[STAGE_TABLE_1].[Date] >= '20210101'
AND [BOOKING].[STAGE_TABLE_1].[Weekday] IS NOT NULL
-- ORDER BY [BOOKING].[STAGE_TABLE_1].[Date] DESC

SELECT count(DISTINCT [DATE])
 FROM [BOOKING].[STAGE_TABLE_1]
 WHERE [BOOKING].[STAGE_TABLE_1].[Date] >= '20160101'
 AND [BOOKING].[STAGE_TABLE_1].[Date] <= '20161231'
 AND [BOOKING].[STAGE_TABLE_1].[Weekday] IS NOT NULL
--  ORDER BY [BOOKING].[STAGE_TABLE_1].[Date] DESC




-- Inspect distinct Date check , what date is left
SELECT DISTINCT [DATE]
 FROM [BOOKING].[STAGE_TABLE_1]
 WHERE [BOOKING].[STAGE_TABLE_1].[Date] >= '20210101'
 ORDER BY [BOOKING].[STAGE_TABLE_1].[Date] DESC


SELECT DISTINCT [DATE], [Weekday]
 FROM [BOOKING].[STAGE_TABLE_1]
 WHERE [BOOKING].[STAGE_TABLE_1].[Date] = '20210228'
--  ORDER BY [BOOKING].[STAGE_TABLE_1].[Date] DESC

SELECT * 
FROM [BOOKING].[STAGE_TABLE_1]
WHERE [BOOKING].[STAGE_TABLE_1].[Date] > '20210101'
AND [BOOKING].[STAGE_TABLE_1].[Date] < '20210103'


USE STAGE_TABLES_DB_1
GO
-- Inspect all tables 
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = 'STAGE_TABLE_1'

SELECT *
 FROM [BOOKING].[STAGE_TABLE_1]
 WHERE [BOOKING].[STAGE_TABLE_1].[Date] = '20210228'
--
-- Total rows 
-- 2,235,043
-- 2,255,398 - 19.3.2021
SELECT COUNT(*)
FROM [BOOKING].[STAGE_TABLE_1]


-- Distinct Job No 
-- 1,833,066 
-- 1,94

SELECT COUNT(DISTINCT [Job No])
FROM [BOOKING].[STAGE_TABLE_1]



-- Group by [BOOKING].[STAGE_TABLE_1].[Date]
-- WHERE id = 2

-- It does group by decimal points
SELECT [Job No], COUNT(*)
 FROM [BOOKING].[STAGE_TABLE_1]
 WHERE [BOOKING].[STAGE_TABLE_1].[Date] = '20210316'
 AND [BOOKING].[STAGE_TABLE_1].[Job No] >= 2681620
 AND [BOOKING].[STAGE_TABLE_1].[Job No] < 2681621
 GROUP BY [BOOKING].[STAGE_TABLE_1].[Job No]
--  ORDER BY [BOOKING].[STAGE_TABLE_1].[Date] DESC

-- Table column data type
 select
  COLUMN_NAME,
  data_type 
  from 
  information_schema.columns where table_schema = 'BOOKING' and table_name = 'STAGE_TABLE_1'; 

TRUNCATE TABLE [BOOKING].[STAGE_TABLE_1]

DROP TABLE [BOOKING].[STAGE_TABLE_1]


 
GO
--  where [BOOKING].[STAGE_TABLE_1].[Job No] = 2669420.01
--  AND [BOOKING].[STAGE_TABLE_1].[Job No] < 2669421
-- [BOOKING].[STAGE_TABLE_1].[Date] = '20210309'



-- Inspect Earliest date
-- Start 
-- From 2016 - August 29

SELECT MIN(DISTINCT [Date]) as EarliestDate, count(*)
FROM [BOOKING].[STAGE_TABLE_1]


-- The Latest date of the Dataframe
-- 2,032,499 rows
SELECT MAX(DISTINCT [Date]) as LATESTDATE, count(*)
FROM [BOOKING].[STAGE_TABLE_1]


-- ---------------------
SELECT MIN(DISTINCT [Date]) as EarliestDate,
MAX(DISTINCT [Date]) as LATESTDATE, count(*)
FROM [BOOKING].[STAGE_TABLE_1]
-- ---------------------

SELECT *
FROM [BOOKING].[STAGE_TABLE_1]
WHERE [BOOKING].[STAGE_TABLE_1].[DATE]

MIN(DISTINCT [Date]) as EarliestDate, count(*)


USE STAGE_1_DB
GO

BOOKING_SCH_S1_ 

DECLARE @begin binary(10), @end binary(10)
SET @begin = sys.fn_cdc_get_min_lsn('BOOKING_STAGE_TABLE_1');
SET @end = sys.fn_cdc_get_max_lsn();
SELECT * FROM [cdc].[fn_cdc_get_all_changes_BOOKING_STAGE_TABLE_1](@begin, @end, N'ALL')



select s.name as schema_name, 
    s.schema_id,
    u.name as schema_owner
from sys.schemas s
    inner join sys.sysusers u
        on u.uid = s.principal_id
order by s.name



-- WHERE INFORMATION_SCHEMA.COLUMNS.TABLE_NAME