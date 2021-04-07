
USE STAGE_TABLES_DB_2
GO


CREATE DATABASE STAGE_TABLES_DB_2

USE STAGE_TABLES_DB_1
GO 

CREATE SCHEMA BOOKING_S2
CREATE SCHEMA TIPPING_S2



-- SELECT DISTINCT Job No  
-- 209

WITH DistinctJobs AS
(
    SELECT * ,
        ROW_NUMBER() OVER(
            PARTITION BY [Job No] ORDER BY [Job No]) AS 'RowNum' 
    FROM [STAGE_TABLES_DB_1].[BOOKING].[STAGE_TABLE_1]
    Where 

)


SELECT TOP 3 * INTO #TempTable
FROM DistinctJobs
WHERE RowNum = 1


ALTER TABLE #TempTable
DROP COLUMN [RowNum]


SELECT * INTO [STAGE_TABLES_DB_2].[BOOKING_S2].[STAGE_TABLE_2_BOOKING]
FROM #TempTable
DROP TABLE #TempTable

Select TOP 3 *
FROM [STAGE_TABLES_DB_1].[BOOKING].[STAGE_TABLE_1]
WHERE [STAGE_TABLES_DB_1].[BOOKING].[STAGE_TABLE_1].[Latitude] = 0


-- ========================================
SELECT * 
FROM 
[STAGE_1_DB].[BOOKING_SCH_S1].[BOOKING_TB_S1]
WHERE [BOOKING_SCH_S1].[BOOKING_TB_S1].[Date] >= '20210324'
AND [BOOKING_SCH_S1].[BOOKING_TB_S1].[Date] <= '20210330'

-- ========================================
select s.name as schema_name, 
    s.schema_id,
    u.name as schema_owner
from sys.schemas s
    inner join sys.sysusers u
        on u.uid = s.principal_id
order by s.name


SELECT DISTINCT [table_schema], [TABLE_NAME]
FROM INFORMATION_SCHEMA.COLUMNS
-- WHERE [BOOKING].[STAGE_TABLE_1].[Date] >= '20200320'
--     AND [BOOKING].[STAGE_TABLE_1].[Date] <= '20210228'
--     AND [BOOKING].[STAGE_TABLE_1].[Customer number] = 1825.003



