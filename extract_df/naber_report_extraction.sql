

SELECT MIN(DISTINCT [Date]) as EarliestDate,
MAX(DISTINCT [Date]) as LATESTDATE, count(*)
FROM 
[STAGE_1_DB].[BOOKING_SCH_S1].[BOOKING_TB_S1]


SELECT MIN(DISTINCT [Date]) as EarliestDate,
MAX(DISTINCT [Date]) as LATESTDATE, count(*)
FROM 
[STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]


USE
    [STAGE_2_DB]
GO


WITH naber_report_ds AS(
    SELECT
        * 
    FROM
        [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
    WHERE 
        [Customer number] IN (1887,3763,3268,3483,2317,4236,3476,4156,3966,4365)
    AND
        [DATE] BETWEEN '20210401' AND '20210430'

        UNION

    SELECT
        * 
    FROM
        [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
    WHERE
        [Customer number] BETWEEN 4138 AND 4138.1
    AND
        [DATE] BETWEEN '20210401' AND '20210430'

        UNION

    SELECT
        * 
    FROM
        [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
    WHERE
        [Customer number] BETWEEN 3139 AND 3139.1
    AND
        [DATE] BETWEEN '20210401' AND '20210430'

        UNION

    SELECT
        * 
    FROM
        [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
    WHERE
        [Customer number] BETWEEN 1021 AND 1021.1
    AND
        [DATE] BETWEEN '20210401' AND '20210430'

        UNION

    SELECT
        * 
    FROM
        [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
    WHERE
        [Customer number] BETWEEN 2505 AND 2505.1
    AND
        [DATE] BETWEEN '20210401' AND '20210430'

)Select *
FROM naber_report_ds
ORDER BY [Date]


-- =====================================================================================

WITH naber_report_ds AS(
    SELECT
        * 
    FROM
        [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
    WHERE 
        [Customer number] IN (1887,3763,3268,3483,2317,4236,3476,4156,3966,4365)
    AND
        [DATE] BETWEEN '20210401' AND '20210430'

        UNION

    SELECT
        * 
    FROM
        [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
    WHERE
        [Customer number] BETWEEN 4138 AND 4138.1
    AND
        [DATE] BETWEEN '20210401' AND '20210430'

        UNION

    SELECT
        * 
    FROM
        [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
    WHERE
        [Customer number] BETWEEN 3139 AND 3139.1
    AND
        [DATE] BETWEEN '20210401' AND '20210430'

        UNION

    SELECT
        * 
    FROM
        [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
    WHERE
        [Customer number] BETWEEN 1021 AND 1021.1
    AND
        [DATE] BETWEEN '20210401' AND '20210430'

        UNION

    SELECT
        * 
    FROM
        [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
    WHERE
        [Customer number] BETWEEN 2505 AND 2505.1
    AND
        [DATE] BETWEEN '20210401' AND '20210430'

)  
Select * FROM naber_report_ds
order by [DATE]




-- 4138 All
-- 3139 All
-- 1021 All
-- 2505 All

-- 1887,3763,3268,3483,2317,4236,3476,4156,3966
-- 4365 Only