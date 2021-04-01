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

#### Create a Table for Counting SWS Fiscal Weeks 
    From Wednesday to Tuesday

<!-- Issues -->
    Since the validation lays on less than 7,
    If I Import data less than 1 week 
    the validation will fail.
            #SWS_WEEK_YEAR.[NumOfDaysInWeek] < 7 



##### Step 1 - Create a Table Counting Weeks Number From every Wednesday to Tuesday day
    
```
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
```

##### Step 2 - Created Temporary table Name #SWS_WEEK_YEAR => Count Each week Number of day => Join #SWS_WEEK_YEAR and the Tem table <NumOfDaysLookup> 

Group weekNum  

With NumOfDaysLookup as 
(Select 
    [SWS_Year] as y,
    [weekNum] as wk, 
    count(*) AS NumOfDays
FROM 
#SWS_WEEK_YEAR
GROUP BY 
#SWS_WEEK_YEAR.SWS_Year,
#SWS_WEEK_YEAR.weekNum
) 
Select * From 
    #SWS_WEEK_YEAR
LEFT JOIN NumOfDaysLookup
ON 
#SWS_WEEK_YEAR.SWS_Year = NumOfDaysLookup.y 
AND 
#SWS_WEEK_YEAR.[weekNum] = NumOfDaysLookup.wk

##### Step 3 - Place Number of days in week within the year  
    To deal with two years between Week 
        day From Wednesday to Tuesday

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

##### Full Query to Create 
    1. SWS_Fiscal_Year Deal with Year between
    e.g. Between 26 Dec 2019 to 5 Jan 2020    
            Wednesday to Tuesday do not sit exact within the year

    2. SWS_Fiscal_Week From Wednesday to Tuesday   

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

