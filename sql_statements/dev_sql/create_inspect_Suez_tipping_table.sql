
CREATE DATABASE METADATA

USE STAGE_1_DB
GO 

CREATE SCHEMA SUEZ_TIPPING_SCH_S1;

SELECT MIN(DISTINCT [Date]) as EarliestDate,
MAX(DISTINCT [Date]) as LATESTDATE, count(*)
FROM [SUEZ_TIPPING_SCH_S1].[SUEZ_TIPPING_TB_S1]





-- SELECT 
--     [Date],
--     [1st Weigh],
--     [Docket],
--     [Rego],
--     [Net (t)],
--     [Price per unit],
--     [Net (t)] * [Price per unit] AS [total_price]
--     FROM 
-- [SUEZ_TIPPING_SCH_S1].[SUEZ_TIPPING_TB_S1]
-- WHERE 
--     [DATE] BETWEEN '20210414' AND '20210420'

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
    [DATE] BETWEEN '20210414' AND '20210420'

SELECT count(*) FROM #TmpTable