WITH DistinctDate AS
(
    SELECT * ,
        ROW_NUMBER() OVER(
            PARTITION BY [Date] ORDER BY [Date]) AS 'RowNum' 

    FROM [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
    
)SELECT * INTO #TmpTable
FROM DistinctDate
WHERE RowNum = 1

ALTER TABLE #TmpTable
DROP COLUMN RowNum;

SET DATEFIRST 3
SELECT  
    [Date], 
    [Weekday], 
    DATEPART(wk, [Date]) as weekNum, 
    DATEPART(YEAR, [Date]) as SWS_Year
    INTO 

    #SWS_WEEK_YEAR
    
FROM #TmpTable
ORDER BY [Date] DESC; 
DROP TABLE #TmpTable;

Alter Table #SWS_WEEK_YEAR
ADD NumOfDaysInWeek int;

With NumOfDaysLookup as (Select 
    [SWS_Year] as y,
    [weekNum] as wk, 
    count(*) AS NumOfDays
FROM 
    #SWS_WEEK_YEAR
GROUP BY 
#SWS_WEEK_YEAR.SWS_Year,
#SWS_WEEK_YEAR.weekNum
)
Update #SWS_WEEK_YEAR
SET #SWS_WEEK_YEAR.[NumOfDaysInWeek] = NumOfDaysLookup.[NumOfDays]
FROM #SWS_WEEK_YEAR
LEFT JOIN 
NumOfDaysLookup
ON 
#SWS_WEEK_YEAR.SWS_Year = NumOfDaysLookup.y 
AND 
#SWS_WEEK_YEAR.[weekNum] = NumOfDaysLookup.wk;


UPDATE #SWS_WEEK_YEAR
    SET #SWS_WEEK_YEAR.[weekNum] = 
        CASE 
            WHEN #SWS_WEEK_YEAR.[NumOfDaysInWeek] < 7 AND #SWS_WEEK_YEAR.[weekNum] > 52
            THEN 1
            ELSE #SWS_WEEK_YEAR.[weekNum]
        END
        ,
        #SWS_WEEK_YEAR.[SWS_Year] = 
        CASE 
            WHEN #SWS_WEEK_YEAR.[NumOfDaysInWeek] < 7 AND #SWS_WEEK_YEAR.[weekNum] > 52
            THEN DATEPART(Year, DATEADD(year, 1, #SWS_WEEK_YEAR.[Date]))
            ELSE #SWS_WEEK_YEAR.[SWS_Year]
        END
    FROM #SWS_WEEK_YEAR

SELECT [weekNum],count([SWS_Year]) FROM #SWS_WEEK_YEAR
GROUP BY #SWS_WEEK_YEAR.weekNum

Drop Table #SWS_WEEK_YEAR



-- ORDER BY #SWS_WEEK_YEAR.[Date]

-- IF @IsWeekend = 1
--     UPDATE table_name SET column_A = column_A + @new_value WHERE ID = @ID;
-- ELSE
--     UPDATE table_name SET column_B = column_B + @new_value WHERE ID = @ID;



Update #SWS_WEEK_YEAR
    IF DATEPART(WEEKDAY, #SWS_WEEK_YEAR.[Date]) = 6 OR  DATEPART(WEEKDAY, #SWS_WEEK_YEAR.[Date]) = 7
        SET  #SWS_WEEK_YEAR.[IsWeekend] = 1
    ELSE 
        SET  #SWS_WEEK_YEAR.[IsWeekend] = 0
    FROM #SWS_WEEK_YEAR


Update #SWS_WEEK_YEAR SET  #SWS_WEEK_YEAR.[IsWeekend] = 1 FROM #SWS_WEEK_YEAR WHERE #SWS_WEEK_YEAR.[WEEKDAY] = 6 OR  #SWS_WEEK_YEAR.[WEEKDAY] = 7;
Update #SWS_WEEK_YEAR SET  #SWS_WEEK_YEAR.[IsWeekend] = 0 FROM #SWS_WEEK_YEAR WHERE #SWS_WEEK_YEAR.[Weekday] != 6 AND  #SWS_WEEK_YEAR.[Weekday] != 7;


SELECT *
FROM
#SWS_WEEK_YEAR
WHERE #SWS_WEEK_YEAR.[IsWeekend] = 0
-- AND  #SWS_WEEK_YEAR.[WeekDay] = 7
-- OR  #SWS_WEEK_YEAR.[WeekDay] = 6
order by 
[Date]


DECLARE @query nvarchar(max) = 'SELECT TOP 3 [Weekday] FROM #SWS_WEEK_YEAR ';
EXEC sp_describe_first_result_set @query, null, 0;  


-- Eample
-- DECLARE @maxWeight FLOAT, @productKey INTEGER  
-- SET @maxWeight = 100.00  
-- SET @productKey = 424  
-- IF @maxWeight <= (SELECT Weight from DimProduct WHERE ProductKey = @productKey)   
--     SELECT @productKey AS ProductKey, EnglishDescription, Weight, 'This product is too heavy to ship and is only available for pickup.' 
--         AS ShippingStatus
--     FROM DimProduct WHERE ProductKey = @productKey
-- ELSE  
--     SELECT @productKey AS ProductKey, EnglishDescription, Weight, 'This product is available for shipping or pickup.' 
--         AS ShippingStatus
--     FROM DimProduct WHERE ProductKey = @productKey

-- ============================================================
    -- IsWeekend  IsPublic
    Update #SWS_WEEK_YEAR
        SET [IsWeekend] = 1
        FROM #SWS_WEEK_YEAR 
            WHERE #SWS_WEEK_YEAR.[Weekday] = 6
            OR #SWS_WEEK_YEAR.[Weekday] = 7

        [IsWeekend] = 0
            FROM #SWS_WEEK_YEAR 
            WHERE #SWS_WEEK_YEAR.[Weekday] BETWEEN 1 TO 5
            

-- ============================================================

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


USE STAGE_1_DB
GO

[COLUMN_NAME], [DATA_TYPE]

SELECT DISTINCT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA != 'cdc'
AND INFORMATION_SCHEMA.COLUMNS.[COLUMN_NAME] = 'WeekDay'


ALTER TABLE [STAGE_1_DB].[BOOKING_SCH_S1].[BOOKING_TB_S1]
ALTER COLUMN [Weekday] INT;



-- ========================================================
-- Developing SWS fiscal Week
-- From Wednesday to Tuesday 

-- 1. Inspect How many Wednesday to Tuesday in those years 
 -- ( Sunday )
 

SELECT TOP 1000 [Date], [Weekday], DATEPART(wk, [Date]) as weekNum
FROM [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
GROUP BY [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date]
ORDER BY [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date]

-- =============================================================
WITH DistinctDate AS
(
    SELECT * ,
        ROW_NUMBER() OVER(
            PARTITION BY [Date] ORDER BY [Date]) AS 'RowNum' 

    FROM [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
    
)SELECT * INTO #TmpTable
FROM DistinctDate
WHERE RowNum = 1

ALTER TABLE #TmpTable
DROP COLUMN RowNum;


SET DATEFIRST 3
SELECT top 1000 
    [Date], 
    [Weekday], 
    DATEPART(wk, [Date]) as weekNum, 
    DATEPART(YEAR, [Date]) as SWS_Year
FROM #TmpTable
ORDER BY [Date] DESC 

-- =============================================================


DROP TABLE #TmpTable
ALTER TABLE [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
DROP COLUMN RowNum

SELECT top 3 * from [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]



-- =============================================================


WITH DistinctDate AS
(
    SELECT * ,
        ROW_NUMBER() OVER(
            PARTITION BY [Date] ORDER BY [Date]) AS 'RowNum' 

    FROM [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
    
)SELECT * INTO #TmpTable
FROM DistinctDate
WHERE RowNum = 1

ALTER TABLE #TmpTable
DROP COLUMN RowNum;

SET DATEFIRST 3
SELECT  
    [Date], 
    [Weekday], 
    DATEPART(wk, [Date]) as weekNum, 
    DATEPART(YEAR, [Date]) as SWS_Year
    INTO 
    #SWS_WEEK_YEAR
FROM #TmpTable
ORDER BY [Date] DESC; 
DROP TABLE #TmpTable;


-- Condition
-- https://stackoverflow.com/questions/35914894/how-to-assign-multiple-values-in-case-statement


DROP TABLE #SWS_WEEK_YEAR;

-- ===============================================


DROP Table #SWS_WEEK_YEAR











Select * From 
    #SWS_WEEK_YEAR
LEFT JOIN NumOfDaysLookup
ON 
#SWS_WEEK_YEAR.SWS_Year = NumOfDaysLookup.y 
AND 
#SWS_WEEK_YEAR.[weekNum] = NumOfDaysLookup.wk





-- ====================================
Select 
    top 100
    [SWS_Year],
    [weekNum],     
    count([Date]) AS NumOfDays
FROM 
#SWS_WEEK_YEAR
GROUP BY 
#SWS_WEEK_YEAR.SWS_Year,
#SWS_WEEK_YEAR.weekNum
ORDER BY 
#SWS_WEEK_YEAR.SWS_Year;

