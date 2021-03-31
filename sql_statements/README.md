


#### Data Audit 

Is Booking weekday same as date weekday

SET DATEFIRST 1
SELECT [Job No],[Date],DATEPART(WEEKDAY, [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date]) , [Weekday]
FROM [STAGE_2_DB].[BOOKING_SCH_S2].BOOKING_TB_S2 
Where [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Weekday] != DATEPART(DW, [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date])  

#### System fn / inspect sys

##### list all schema
select s.name as schema_name, 
    s.schema_id,
    u.name as schema_owner
from sys.schemas s
    inner join sys.sysusers u
        on u.uid = s.principal_id
order by s.name

##### List all schema and Table in the DB
SELECT DISTINCT [table_schema], [TABLE_NAME]
FROM INFORMATION_SCHEMA.COLUMNS

##### List Server Agent Job
SELECT 
    [sJOB].[job_id] AS [JobID]
    , [sJOB].[name] AS [JobName]
    , [sDBP].[name] AS [JobOwner]
    , [sCAT].[name] AS [JobCategory]
    , [sJOB].[description] AS [JobDescription]
    , CASE [sJOB].[enabled]
        WHEN 1 THEN 'Yes'
        WHEN 0 THEN 'No'
      END AS [IsEnabled]
    , [sJOB].[date_created] AS [JobCreatedOn]
    , [sJOB].[date_modified] AS [JobLastModifiedOn]
    , [sSVR].[name] AS [OriginatingServerName]
    , [sJSTP].[step_id] AS [JobStartStepNo]
    , [sJSTP].[step_name] AS [JobStartStepName]
    , CASE
        WHEN [sSCH].[schedule_uid] IS NULL THEN 'No'
        ELSE 'Yes'
      END AS [IsScheduled]
    , [sSCH].[schedule_uid] AS [JobScheduleID]
    , [sSCH].[name] AS [JobScheduleName]
    , CASE [sJOB].[delete_level]
        WHEN 0 THEN 'Never'
        WHEN 1 THEN 'On Success'
        WHEN 2 THEN 'On Failure'
        WHEN 3 THEN 'On Completion'
      END AS [JobDeletionCriterion]
FROM
    [msdb].[dbo].[sysjobs] AS [sJOB]
    LEFT JOIN [msdb].[sys].[servers] AS [sSVR]
        ON [sJOB].[originating_server_id] = [sSVR].[server_id]
    LEFT JOIN [msdb].[dbo].[syscategories] AS [sCAT]
        ON [sJOB].[category_id] = [sCAT].[category_id]
    LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sJSTP]
        ON [sJOB].[job_id] = [sJSTP].[job_id]
        AND [sJOB].[start_step_id] = [sJSTP].[step_id]
    LEFT JOIN [msdb].[sys].[database_principals] AS [sDBP]
        ON [sJOB].[owner_sid] = [sDBP].[sid]
    LEFT JOIN [msdb].[dbo].[sysjobschedules] AS [sJOBSCH]
        ON [sJOB].[job_id] = [sJOBSCH].[job_id]
    LEFT JOIN [msdb].[dbo].[sysschedules] AS [sSCH]
        ON [sJOBSCH].[schedule_id] = [sSCH].[schedule_id]
ORDER BY [JobName]

##### Is CDC enabled
SELECT name, database_id, is_cdc_enabled FROM sys.databases
WHERE is_cdc_enabled = 1

##### Disable / Enable Table CDC
EXEC sys.sp_cdc_enable_db  
GO  
EXEC sys.sp_cdc_disable_db  
GO  


EXEC sys.sp_cdc_enable_table  
@source_schema = N'BOOKING_SCH_S1',  
@source_name   = N'BOOKING_TB_S1',  
@role_name     = NULL
GO

##### Sql Agent Activate
    sudo /opt/mssql/bin/mssql-conf set sqlagent.enabled true 
    sudo systemctl restart mssql-server

##### Query Changes

DECLARE @begin binary(10), @end binary(10);
 SET @begin = sys.fn_cdc_get_min_lsn('BOOKING_SCH_S1_BOOKING_TB_S1');
 SET @end = sys.fn_cdc_get_max_lsn();
SELECT * FROM [cdc].[fn_cdc_get_all_changes_BOOKING_SCH_S1_BOOKING_TB_S1](@begin, @end, N'ALL')




#### Note / Queries
##### CONVERT Calendar YEAR MONTH to Fiscal YEAR MONTH


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
