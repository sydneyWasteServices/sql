

With AUfiscalCal as(
    SELECT 
    top 1000  [Date], DATEPART(month, DATEADD(month, -6, [Date])) as AUFISDATE 
    from [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
    Group by  [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date]
    ORDER BY [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date] DESC
),SecondHalf_FicscalYear as (
    Select * , FISYEAR =
    CASE 
        WHEN AUfiscalCal.AUFISDATE >= 7 AND AUfiscalCal.AUFISDATE <= 12 
        THEN DATEPART(YEAR, DATEADD(YEAR, -1, [AUfiscalCal].[Date])) 
    ELSE
        DATEPART(YEAR,[AUfiscalCal].[Date]) 
    END 
    FROM  AUfiscalCal
)
SELECT 
*,
DATEPART(WEEKDAY, [Date]) as wkDay,
DATEPART(wk, [Date]) as week  FROM SecondHalf_FicscalYear





SET DATEFIRST 1
SELECT [Job No],[Date],DATEPART(WEEKDAY, [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date]) , [Weekday]
FROM [STAGE_2_DB].[BOOKING_SCH_S2].BOOKING_TB_S2 
Where [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Weekday] != DATEPART(DW, [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date]) 
Order By [Date] DESC


SELECT 

SELECT DATEADD(year, 1, '2017/08/25') AS DateAdd;


USE STAGE_2_DB
GO


SELECT 
MIN(DISTINCT [Date]) as EarliestDate,
MAX(DISTINCT [Date]) as LATESTDATE, 
count(*)
FROM  STAGE_2_DB.BOOKING_SCH_S2.BOOKING_TB_S2


SELECT 
MIN(DISTINCT [Date]) as EarliestDate,
MAX(DISTINCT [Date]) as LATESTDATE, 
count(*)
FROM  STAGE_1_DB.BOOKING_SCH_S1.BOOKING_TB_S1


SELECT 
MIN(DISTINCT [Route Date]) as EarliestDate,
MAX(DISTINCT [Route Date]) as LATESTDATE, 
count(*)
FROM  STAGE_1_DB.TIPPING_SCH_S1.[TIPPING_TB_S1]



DECLARE @begin binary(10), @end binary(10);
 SET @begin = sys.fn_cdc_get_min_lsn('BOOKING_SCH_S1_BOOKING_TB_S1');
 SET @end = sys.fn_cdc_get_max_lsn();
SELECT * FROM [cdc].[fn_cdc_get_all_changes_BOOKING_SCH_S1_BOOKING_TB_S1](@begin, @end, N'ALL')

USE STAGE_1_DB
GO
SELECT DISTINCT [table_schema], [TABLE_NAME]
FROM INFORMATION_SCHEMA.COLUMNS


    Weekday int,
    WeekNth int,


    SWSFiscalWeekNum int,
    IsPublicHoliday bit, 
    IsWeekend bit


-- ============================================================================
    AUFiscalMonth int, 
    AUFiscalYear int,

SET DATEPART (WEEK, '2021-04-21') = 1



-- , DATEPART(WEEKDAY, [Date]) as weekDay1 






-- =========================================================================================


DATEADD(year, 1, '2017/08/25') AS DateAdd;


insert dbo.dateDim(Date, Day, Month, year, IsWeekend)
select 
 [Date Index] AS Date
,day([Date Index]) AS Day
,month([Date Index]) AS Month
,year([Date Index]) AS year 
,(CASE WHEN DATEPART(DW,[for_distinct_dates].[Date Index]) = 6 THEN 1 WHEN DATEPART(DW,[for_distinct_dates].[Date Index]) = 7 THEN 1 ELSE 0 END) as IsWeekend
from 
	(select distinct [Date Index] from [dbo].[staging_table_test]) AS for_distinct_dates
order by [Date Index]

