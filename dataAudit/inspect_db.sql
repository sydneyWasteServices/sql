USE [STAGE_1_DB]
GO



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


SELECT DISTINCT [table_schema], [TABLE_NAME]
FROM INFORMATION_SCHEMA.COLUMNS

SELECT name, database_id, is_cdc_enabled FROM sys.databases
WHERE is_cdc_enabled = 1


DECLARE @begin binary(10), @end binary(10);
 SET @begin = sys.fn_cdc_get_min_lsn('BOOKING_SCH_S1_BOOKING_TB_S1');
 SET @end = sys.fn_cdc_get_max_lsn();
SELECT * FROM [cdc].[fn_cdc_get_all_changes_BOOKING_SCH_S1_BOOKING_TB_S1](@begin, @end, N'ALL')



SELECT * FROM [cdc].[BOOKING_SCH_S1_BOOKING_TB_S1_CT] GO



SELECT 
    MIN(DISTINCT [Date]) as EarliestDate,
    MAX(DISTINCT [Date]) as LATESTDATE,
    count(*)
FROM [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]

