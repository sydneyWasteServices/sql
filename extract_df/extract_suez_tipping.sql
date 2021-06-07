
SELECT MIN(DISTINCT [Date]) as EarliestDate,
MAX(DISTINCT [Date]) as LATESTDATE, count(*)
FROM [STAGE_1_DB].[SUEZ_TIPPING_SCH_S1].[SUEZ_TIPPING_TB_S1]


SELECT MIN(DISTINCT [Date]) as EarliestDate,
MAX(DISTINCT [Date]) as LATESTDATE, count(*)
FROM [STAGE_2_DB].[SUEZ_TIPPING_SCH_S2].[SUEZ_TIPPING_TB_S2]

-- 6/5/2021 - 13/5/2021
-- 07 04 2021 13 04 2021


TRUNCATE TABLE [STAGE_2_DB].[SUEZ_TIPPING_SCH_S2].[SUEZ_TIPPING_TB_S2]

SELECT 
    [Date],
    [1st Weigh],
    [Docket],
    [Rego],
    [Net (t)],
    [Price per unit],
    [Net (t)] * [Price per unit] AS [total_price]
FROM 
    [STAGE_1_DB].[SUEZ_TIPPING_SCH_S1].[SUEZ_TIPPING_TB_S1]
WHERE 
    [DATE] = '20210427'
    -- [DATE] BETWEEN '20210424' AND '20210426'



-- ===================================================
-- Insert new non duplicate records to stage 2 table  

WITH Distinct_Doc AS
(
    SELECT * ,
        ROW_NUMBER() OVER(
            PARTITION BY [Docket] ORDER BY [Docket]) AS 'RowNum' 

    FROM [STAGE_1_DB].[SUEZ_TIPPING_SCH_S1].[SUEZ_TIPPING_TB_S1]
    WHERE [Date] BETWEEN '20210514' AND '20210522'
    
)
SELECT * INTO #TmpTable
FROM Distinct_Doc
WHERE RowNum = 1

ALTER TABLE #TmpTable
DROP COLUMN RowNum;

INSERT INTO  
    [STAGE_2_DB].[SUEZ_TIPPING_SCH_S2].[SUEZ_TIPPING_TB_S2]
SELECT *
FROM #TmpTable

DROP TABLE #TmpTable


Select * from  #TmpTable
WHERE [DATE] = '20210424'
ORDER BY [DOCKET]


SELECT * from 
[STAGE_2_DB].[SUEZ_TIPPING_SCH_S2].[SUEZ_TIPPING_TB_S2]
WHERE [Date] BETWEEN '20210505' AND '20210511'
ORDER BY [Date]

-- ===============================================
-- Extract with Date

SELECT 
    [Date],
    [1st Weigh],
    [Docket],
    [Rego],
    [Net (t)],
    [Price per unit],
    [Net (t)] * [Price per unit] AS [total_price]
FROM 
     [STAGE_2_DB].[SUEZ_TIPPING_SCH_S2].[SUEZ_TIPPING_TB_S2]
WHERE 
    [DATE] BETWEEN '20210512' AND '20210518'
ORDER BY 
    [DATE]


-- ===========================================
-- Data Audit 
SELECT 
    [DATE],
    count([DATE]) as occurence

FROM
    [STAGE_2_DB].[SUEZ_TIPPING_SCH_S2].[SUEZ_TIPPING_TB_S2]
WHERE [DATE] BETWEEN '20210331' AND '20210409'
GROUP BY []
ORDER BY [DATE]


-- Calculate Weight
-- =====================
SELECT 
    
    sum([Net (t)])
    
FROM 
     [STAGE_2_DB].[SUEZ_TIPPING_SCH_S2].[SUEZ_TIPPING_TB_S2]
WHERE 
    [DATE] BETWEEN '20210407' AND '20210413'
