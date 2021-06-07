
-- Description of ANomalies
-- DB location 
-- Schmea location 
-- Table location
-- is Solve

USE [Stage_1_DB]
go

-- 255
-- 254     -5 NULL
-- count()
-- count(*)

SELECT [Sequence No], [Docket No]
FROM [TIPPING_SCH_S1].[TIPPING_TB_S1]
WHERE 
    [Tare Weight] > 0 
AND 
    [Weight] > 1000
ORDER BY [Docket No]
-- AND [Docket No] IS NULL
-- Find Duplicate Docket 

with dup_table as (
    SELECT [Docket No], COUNT(*) AS OC
    FROM [TIPPING_SCH_S1].[TIPPING_TB_S1]
    WHERE [Tare Weight] > 0 
    AND [Weight] > 1000
    GROUP BY 
        [Docket No]
    HAVING 
        count(*) > 1

)  Select 
        -- a.[Sequence No], 
        a.[Docket No]
    FROM 
        dup_table a
    INNER JOIN 
        dup_table b
    ON
        a.[Docket No] = b.[Docket No]
    ORDER BY 
        a.[Docket No]


SELECT 
    * 
FROM
    [TIPPING_SCH_S1].[TIPPING_TB_S1]
WHERE [Docket No] IN ('6584', 'BC130050953', 'S000379', 'SOOO379') 
and 
    [Tare Weight] > 0 
AND 
    [Weight] > 1000

CREATE DATABASE ANOMALY_RECORDS_DB
use ANOMALY_RECORDS_DB
GO
CREATE SCHEMA TIPPING_SCH

-- ==================================================
-- Query for tipping records 
WITH Distinct_SQ_NO AS
(
    SELECT * ,
        ROW_NUMBER() OVER(
            PARTITION BY [Sequence No] ORDER BY [Sequence No]) AS 'RowNum' 
    FROM
         [STAGE_1_DB].[TIPPING_SCH_S1].[TIPPING_TB_S1]
    WHERE 
        [Tare Weight] > 0 
    AND 
        [Weight] > 1000
    
)SELECT * INTO #TMPTB
FROM Distinct_SQ_NO
WHERE RowNum = 1

Alter table #TMPTB
DROP COLUMN [RowNum]

SELECT 
    Is_Solve = 0,
    Descrption = 'Tipping Weight is incorrect, Weight more than 1000. Error in Weight, Tare Weight',
    DB = 'STAGE_1_DB',
    SCH = 'TIPPING_SCH_S1',
    TB = 'TIPPING_TB_S1',
    * INTO [ANOMALY_RECORDS_DB].[TIPPING_SCH].[TIPPING_TB] 
FROM 
    #TMPTB

DROP TABLE #TMPTB


-- ==================================================
DROP TABLE[ANOMALY_RECORDS_DB].[TIPPING_SCH].[TIPPING_TB] 



