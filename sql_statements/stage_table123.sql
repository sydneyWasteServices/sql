SELECT name, database_id, is_cdc_enabled FROM sys.databases
WHERE is_cdc_enabled = 1


USE STAGE_1_DB  
GO  
EXEC sys.sp_cdc_enable_db  
GO  


SELECT MIN(DISTINCT [Route Date]) as EarliestDate,
MAX(DISTINCT [Route Date]) as LATESTDATE, count(*)
FROM [TIPPING_SCH_S1].[TIPPING_TB_S1]


select 
    top 1 * 
FROM [TIPPING_SCH_S1].[TIPPING_TB_S1]

select 
    * 
FROM [TIPPING_SCH_S1].[TIPPING_TB_S1]
WHERE [Route Date] between '20210331' AND '20210406'


USE STAGE_2_DB
GO


EXEC sys.sp_cdc_enable_table  
@source_schema = N'BOOKING_SCH_S2',  
@source_name   = N'BOOKING_TB_S2',  
@role_name     = NULL
GO  

SELECT name, database_id, is_cdc_enabled FROM sys.databases
WHERE is_cdc_enabled = 1

SELECT
   *
FROM
    msdb.dbo.sysjobs 


SELECT
   *
FROM
    msdb.dbo.sysjobs 

DECLARE @begin binary(10), @end binary(10);
 SET @begin = sys.fn_cdc_get_min_lsn('BOOKING_SCH_S1_BOOKING_TB_S1');
 SET @end = sys.fn_cdc_get_max_lsn();
SELECT * FROM [cdc].[fn_cdc_get_all_changes_BOOKING_SCH_S1_BOOKING_TB_S1](@begin, @end, N'ALL')


USE STAGE_1_DB
GO
SELECT s.name AS Schema_Name, tb.name AS Table_Name
, tb.object_id, tb.type, tb.type_desc, tb.is_tracked_by_cdc
FROM sys.tables tb
INNER JOIN sys.schemas s on s.schema_id = tb.schema_id
WHERE tb.is_tracked_by_cdc = 1

EXEC sys.sp_cdc_scan 


Select [name], is_tracked_by_cdc
FROM sys.tables

SELECT TOP 3 *  FROM cdc.BOOKING_SCH_S1_BOOKING_TB_S1_CT

USE STAGE_1_DB
GO

select TOP 3 * FROM [BOOKING_SCH_S1].[BOOKING_TB_S1]

TRUNCATE TABLE [BOOKING_SCH_S1].[BOOKING_TB_S1]


EXEC sys.sp_cdc_disable_db  

EXEC sys.sp_cdc_enable_db  


CREATE DATABASE STAGE_2_DB


USE STAGE_2_DB
GO

CREATE SCHEMA BOOKING_SCH_S2


SELECT MIN(DISTINCT [Date]) as EarliestDate, count(*)
FROM [BOOKING_SCH_S1].[BOOKING_TB_S1]


SELECT MAX(DISTINCT [Date]) as LATESTDATE, count(*)
FROM [BOOKING_SCH_S1].[BOOKING_TB_S1]



WITH DistinctJobs AS
(
    SELECT * ,
        ROW_NUMBER() OVER(
            PARTITION BY [Job No] ORDER BY [Job No]) AS 'RowNum' 
    FROM [STAGE_1_DB].[BOOKING_SCH_S1].[BOOKING_TB_S1]
    

)
SELECT * INTO [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
FROM DistinctJobs
WHERE RowNum = 1


SELECT COUNT(*) FROM [STAGE_1_DB].[BOOKING_SCH_S1].[BOOKING_TB_S1]
SELECT COUNT(*) FROM [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]

 
USE [STAGE_2_DB]
GO


SELECT * INTO [STAGE_TABLES_DB_2].[BOOKING_S2].[STAGE_TABLE_2_BOOKING]
FROM #TempTable

USE STAGE_1_DB
GO

select s.name as schema_name, 
    s.schema_id,
    u.name as schema_owner
from sys.schemas s
    inner join sys.sysusers u
        on u.uid = s.principal_id
order by s.name


    -- db = "STAGE_1_DB"
    -- sch = "BOOKING_SCH_S1"
    -- tablename = "BOOKING_TB_S1"
    

-- SELECT C.NAME AS COLUMN_NAME,
--        TYPE_NAME(C.USER_TYPE_ID) AS DATA_TYPE,
--        C.IS_NULLABLE,
--        C.MAX_LENGTH,
--        C.PRECISION,
--        C.SCALE
-- FROM SYS.COLUMNS C
-- JOIN SYS.TYPES T
--      ON C.USER_TYPE_ID=T.USER_TYPE_ID
-- WHERE C.OBJECT_ID=OBJECT_ID('BOOKING_TB_S1');

--  ===========================================

