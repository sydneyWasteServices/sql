USE STAGE_1_DB
GO

CREATE SCHEMA TIPPING_SCH_S1

SELECT count(*)   FROM TIPPING_SCH_S1.TIPPING_TB_S1

SELECT [TABLE_NAME]
FROM INFORMATION_SCHEMA.COLUMNS
GROUP BY INFORMATION_SCHEMA.COLUMNS.TABLE_NAME
-- WHERE INFORMATION_SCHEMA.COLUMNS



SELECT MIN(DISTINCT [Route Date]) as EarliestDate, count(*)
FROM  TIPPING_SCH_S1.TIPPING_TB_S1


-- The Latest date of the Dataframe
-- 2,032,499 rows
SELECT MAX(DISTINCT [Route Date]) as LATESTDATE, count(*)
FROM  TIPPING_SCH_S1.TIPPING_TB_S1

SELECT SCHEMA_NAME()

truncate table TIPPING_SCH_S1.TIPPING_TB_S1


SELECT name, database_id, create_date  
FROM sys.databases ;  
GO  
  
select s.name as schema_name, 
    s.schema_id,
    u.name as schema_owner
from sys.schemas s
    inner join sys.sysusers u
        on u.uid = s.principal_id
order by s.name

SELECT TOP 3 * FROM [TIPPING].[STAGE_TABLE_1_TIPPING]
WHERE [TIPPING].[STAGE_TABLE_1_TIPPING].[Route Date] = null

-- 2016 - Nov - 03
SELECT MIN(DISTINCT [Route Date]) as EarliestDate, count(*)
FROM [TIPPING].[STAGE_TABLE_1_TIPPING]


--  2021 - Mar - 02
SELECT MAX(DISTINCT [Route Date]) as LATESTDATE, count(*)
FROM [STAGE_1_DB].[TIPPING_SCH_S1].[TIPPING_TB_S1]  

SELECT
   *
FROM
    msdb.dbo.sysjobs

EXEC sys.sp_cdc_enable_table  
@source_schema = N'TIPPING',  
@source_name   = N'STAGE_TABLE_1_TIPPING',  
@role_name     = NULL
GO

select TOP 3 * 
FROM [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
WHERE [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Weekday] = 7 

SELECT COUNT(*) FROM [STAGE_1_DB].[TIPPING_SCH_S1].[TIPPING_TB_S1]  



