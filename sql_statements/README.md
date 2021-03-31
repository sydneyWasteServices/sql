#### Note / General Queries


##### CASE VS IF 

IF is a control of flow statement; it indicates which T-SQL statement to evaluate next, based on a condition.

CASE is a function -- it simply returns a value.
Since it is a function  
        "Price Range" = 
            to assign Value


    Select * , FISYEAR =
    CASE 
        WHEN AUfiscalCal.AUFISDATE >= 7 AND AUfiscalCal.AUFISDATE <= 12 
        THEN DATEPART(YEAR, DATEADD(YEAR, -1, [AUfiscalCal].[Date])) 
    ELSE
        DATEPART(YEAR,[AUfiscalCal].[Date]) 
    END 
    FROM  AUfiscalCal



##### DATEPART() 
***SET DATEFIRST 1***
This function adds 1 more day to the week
It must  SET DATEFIRST 1 to align Weekday of Monday 1 to SUnday 7


SET DATEFIRST 1
SELECT Top 3 [Date],DATEPART(WEEKDAY, [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date]) , [Weekday]
FROM [STAGE_2_DB].[BOOKING_SCH_S2].BOOKING_TB_S2 


##### DATEADD()

Add one year to the date and return date
    SELECT DATEADD(year, 1, '2017/08/25') AS DateAdd;


##### Check Query return data type  

DECLARE @query nvarchar(max) = 'SELECT TOP 3 DATEPART(DW, [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date]) 
FROM [STAGE_2_DB].[BOOKING_SCH_S2].BOOKING_TB_S2 ';
EXEC sp_describe_first_result_set @query, null, 0;  


##### First and last date of the dataset 

SELECT MIN(DISTINCT [Route Date]) as EarliestDate, count(*)
FROM  TIPPING_SCH_S1.TIPPING_TB_S1

SELECT MAX(DISTINCT [Route Date]) as LATESTDATE, count(*)
FROM  TIPPING_SCH_S1.TIPPING_TB_S1

##### Unique Job No
Problem is it would insert Column with RowNum
as it picks row by 1


WITH DistinctJobs AS
(
    SELECT * ,
        ROW_NUMBER() OVER(
            PARTITION BY [Job No] ORDER BY [Job No]) AS 'RowNum' 
    FROM [STAGE_1_DB].[BOOKING_SCH_S1].[BOOKING_TB_S1]
    
)
SELECT * INTO [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
FROM DistinctJobs
WHERE RowNum = 1


##### Insert into Dimension Table 

insert dbo.dateDim(Date, Day, Month, year, IsWeekend)

select 
 [Date Index] AS Date
,day([Date Index]) AS Day
,month([Date Index]) AS Month
,year([Date Index]) AS year 
,(CASE WHEN DATEPART(DW,[for_distinct_dates].[Date Index]) = 6 
THEN 
1 WHEN DATEPART(DW,[for_distinct_dates].[Date Index]) = 7 THEN 1 ELSE 0 END) as IsWeekend
from 
	(select distinct [Date Index] from [dbo].[staging_table_test]) AS for_distinct_dates
order by [Date Index]

##### Australia Financial Year - month  

DATEPART(month, DATEADD(month, -6, [Date]))

SELECT 
top 1000  [Date], DATEPART(month, DATEADD(month, -6, [Date])) as AUFISDATE 
from [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
Group by  [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date]
ORDER BY [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date] desc


##### Mutiple CTE, Mutiple WITH

WITH DateSplit 
as 
(SELECT DateStr,
 PARSENAME(REPLACE(DateStr, '/', '.'), 1) AS year,
  PARSENAME(REPLACE(DateStr, '/', '.'), 2) AS month,
   PARSENAME(REPLACE(DateStr, '/', '.'), 2) AS day
FROM [dbo].[test]),
dateTable AS 
(Select 
    CONCAT(day,'/',month,'/20',year) 
    as newDateStr 
    FROM DateSplit)
Select 
    Convert(date,newDateStr ,103) 
        as Date_idx 
        into [dbo].staging_table_test FROM dateTable;
