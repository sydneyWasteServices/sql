USE 
    STAGE_1_DB
GO

SELECT MIN(DISTINCT [Route Date]) as EarliestDate,
MAX(DISTINCT [Route Date]) as LATESTDATE, count(*)
FROM [STAGE_1_DB].[TIPPING_SCH_S1].[TIPPING_TB_S1]



SELECT MIN(DISTINCT [Date]) as EarliestDate,
MAX(DISTINCT [Date]) as LATESTDATE, count(*)
FROM [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]


select 
    * 
FROM [TIPPING_SCH_S1].[TIPPING_TB_S1]
WHERE [Route Date] between '20210331' AND '20210406'

select 
    sum([Price])
FROM [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
WHERE [Date] between '20210331' AND '20210406'
-- ORDER BY [DATE] ASC


select 
    *
FROM 
    [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
WHERE 
    [Date] between '20210324' AND '20210330'


-- 4032 From Mar 2020 to March 2021
-- 2398

Select
    *
FROM 
    [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
WHERE
      [Date] between '20200301' AND '20210331'
AND
    [Customer number] BETWEEN 4032.000 AND 4032.1
AND 
    [Bin Volume] != 0.05
ORDER BY  
    [Bin Volume]

--     [Customer number] = 4032.000


