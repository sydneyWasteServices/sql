##### Date Dimension Dev statement

##### CONVERT Calendar YEAR MONTH to Fiscal YEAR MONTH


AUFiscalMonth int, 
AUFiscalYear int,
AUFiscalQuarter int,

With AUfiscalCal as(
    SELECT 
    top 1000  [Date], DATEPART(month, DATEADD(month, -6, [Date])) as AUFISDATE 
    from [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
    Group by  [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date]
    -- ORDER BY [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date] desc
),SecondHalf_FicscalYear as (
    Select * , FISYEAR =
    CASE 
        WHEN AUfiscalCal.AUFISDATE >= 7 AND AUfiscalCal.AUFISDATE <= 12 
        THEN DATEPART(YEAR, DATEADD(YEAR, -1, [AUfiscalCal].[Date])) 
    ELSE
        DATEPART(YEAR,[AUfiscalCal].[Date]) 
    END 
    FROM  AUfiscalCal
)SELECT * FROM SecondHalf_FicscalYear


##### CONVERT Calendar YEAR WEEK to SWS Fiscal YEAR MONTH
    SWSFiscalWeekNth int
    SWSFiscalYear int

<!-- It will hit to 53th Condition 
    When hit to 53th Week, it leaps to the next year -->


WITH DistinctDate AS
(
    SELECT * ,
        ROW_NUMBER() OVER(
            PARTITION BY [Date] ORDER BY [Date]) AS 'RowNum' 
    FROM [STAGE_1_DB].[BOOKING_SCH_S1].[BOOKING_TB_S1]
    
)SELECT * INTO #TmpTable
FROM DistinctDate
WHERE RowNum = 1

ALTER TABLE #TmpTable
DROP COLUMN RowNum;

SET DATEFIRST 3
SELECT top 1000 [Date], [Weekday], DATEPART(wk, [Date]) as weekNum
FROM #TmpTable
ORDER BY [Date] DESC 

DROP TABLE #TmpTable