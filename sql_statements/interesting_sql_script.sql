-- Table columns name and Information
SELECT column_name,data_type from INFORMATION_SCHEMA.COLUMNS where table_schema = 'dbo' and table_name = 'sws_booking_1';

-- execute function
EXEC dbo.SelectByCustomerName @cName = 'Complex Solutions';


-- is null row
SELECT column_names
FROM table_name
WHERE column_name IS NULL;



SELECT 
CAST('12/01/2019' as date) as StringToDate 
, CAST(GETDATE() as VARCHAR(50)) as DateToString


StringToDate DateToString
'12/01/2019' Jan 29 2020 11:42

-- Select and create new table
Select CONVERT(varchar, Date, 103) as stringToDate into  [dbo].[test_1] From [dbo].staging_table_test ;


-- Split One column string and place them to column

SELECT DateStr,
 PARSENAME(REPLACE(DateStr, '/', '.'), 1) AS year,
  PARSENAME(REPLACE(DateStr, '/', '.'), 2) AS month,
   PARSENAME(REPLACE(DateStr, '/', '.'), 2) AS day
FROM [dbo].[test]

-- CTE 
WITH DateSplit 
as 
(SELECT DateStr,
 PARSENAME(REPLACE(DateStr, '/', '.'), 1) AS year,
  PARSENAME(REPLACE(DateStr, '/', '.'), 2) AS month,
   PARSENAME(REPLACE(DateStr, '/', '.'), 2) AS day
FROM [dbo].[test])
Select year from DateSplit;

    -- creating a tem table Of 
    (SELECT DateStr,
        PARSENAME(REPLACE(DateStr, '/', '.'), 1) AS year,
        PARSENAME(REPLACE(DateStr, '/', '.'), 2) AS month,
        PARSENAME(REPLACE(DateStr, '/', '.'), 2) AS day
    FROM [dbo].[test]) 
    -- And Then select Year from that table
    Select year from DateSplit;


-- Transform date String to date
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


-- Select Into From 
-- pick something put it into a table
Select Date as DateStr into @tmp From [dbo].staging_table_test



DECLARE @EMPLOYEENAME VARCHAR(MAX) 

SET @EMPLOYEENAME =(SELECT EMPLOYEE_NAME 
                    FROM   EMPLOYEE) 
DECLARE @SEPARATOR CHAR(1) 
SET @SEPARATOR=',' 
INSERT INTO EMPLOYEE_DETAIL 
            (EMPNAME) 
SELECT * 
FROM   STRING_SPLIT(@EMPLOYEENAME, @SEPARATOR)



-- Create Function
CREATE PROCEDURE SelectByCustomerName
@cName varchar(100)
AS
BEGIN
SELECT [Job No] FROM [dbo].[sws_booking_1] where [Customer Name] = @cName

END;
GO

-- Populate the Dimension table
truncate table [dbo].[DimDept]
    SELECT distinct [Location]
    FROM [PTO_DW_AMOS].[DBO].[TASKs_dw]


insert into [dbo].[DimMonth](PKey, Month) values(1,'Jan')
......   (12,'Dec')

-- =================================
-- populate Fact Table
truncate table [dbo].[FactTasks]
insert into [dbo].[FactTasks]
    select 
           p.PKey as [PkeyType],
           l.PKey as [PkeyLocation],
           d.PKey as [PKeyDept],
           m.Pkey as [PKeyMonth],
           [Amount]
    FROM 
        [dbo].[Task_dw] t,
        [dbo].[DimDept] d,
        [dbo].[DimLocation] l,
        [dbo].[DimMonth] m,
        [dbo].[DimType] p
    WHERE
        t.Dept = d.Dept and
        t.Location = l.Location and
        t.Month = m.Month and
        t.Type = p.Type        


-- ================================
-- Developing Tranformation
    -- Transformation From str date
    -- to new column of dateIndex
WITH DateSplit 
as 
(SELECT 
[Job No],
 Date,
 PARSENAME(REPLACE(Date, '/', '.'), 1) AS year,
  PARSENAME(REPLACE(Date, '/', '.'), 2) AS month,
   PARSENAME(REPLACE(Date, '/', '.'), 3) AS day
FROM [dbo].[staging_table_test]),
dateTable AS 
(Select 
	[Job No],
    CONCAT(day,'/',month,'/20',year) 
    as newDateStr 
    FROM DateSplit),
dateIdxTemTable AS
(SELECT
	[Job No],
		Convert(date,newDateStr ,103) as dateIdx
			FROM dateTable)
UPDATE stagingTable

SET 
    stagingTable.[Date index] = temTable.dateIdx 
FROM [dbo].[staging_table_test] stagingTable
INNER JOIN
dateIdxTemTable temTable
ON stagingTable.[Job No] = temTable.[Job No]

-- ======================================
-- Date Dimension insert query 

-- simple date dimension table
insert datedimension (date, dayname, daynumber, monthname, monthnumber, year)
select 
 date
,datename(weekday,date) dayname
,datepart(weekday,date) daynumber
,datename(month, date) monthname
,month(date) monthnumber
,year(date) year
from (select distinct date date from dbo.yahoo_prices_volumes_for_MSSQLTips) for_distinct_dates
order by date
 
-- echo datedimension
select * from datedimension


-- ==============================================
-- Select Distinct date and Order By Year then month

	 select distinct
       year(orderdate) as orderyear
     , month(orderdate) as ordermonth
  from ordertable
order
    by year(orderdate)
     , month(orderdate)

-- =====================================
-- Populate date Dimension  

insert dbo.dateDim(Date, Day, Month, year)
select 
 [Date Index] AS Date
,day([Date Index]) AS Day
,month([Date Index]) AS Month
,year([Date Index]) AS year
from 
	(select distinct [Date Index] from [dbo].[staging_table_test]) AS for_distinct_dates
order by [Date Index]

-- =============================
-- Mutiple Condition 
-- When condition  


SELECT	
	[Date],
	 [IsWeekend],
      CASE WHEN DATEPART(DW,[Date]) = 6 THEN 1
      WHEN DATEPART(DW,[Date]) = 7 THEN 1
            ELSE 0 END AS condition
  FROM [dbo].[dateDim]



-- =========================
-- Temporary (Must improve)
-- insert date and Weekend  

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



-- =======================
-- Earliest date

SELECT MIN(DISTINCT [Date]) as EarliestDate, count(*)
FROM [BOOKING].[STAGE_TABLE_1]

-- Lastest Date

SELECT MAX(DISTINCT [Date]) as LATESTDATE, count(*)
FROM [BOOKING].[STAGE_TABLE_1]