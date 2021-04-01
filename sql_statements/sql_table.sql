
 
 --Copy of all Source transactions
CREATE DATABASE OLTP_SOURCE_COPY_DB;


CREATE DATABASE OLTP_SOURCE_COPY_TEST;


CREATE SCHEMA OLTP;


---
CREATE TABLE OLTP.waste_edge_booking(
id int IDENTITY(1,1),
job_no float,
date date,
schd_time_start time, 
schd_time_end time,
lat Decimal(9,6),
lng Decimal(8,6),
customer_number float,
customer_name varchar(1000),
address varchar(1000),
city varchar(500),
state varchar(30),
postCode int,
phone varchar(400),
qty_scheduled int,
qty_serviced int,
serv_type varchar(10),
container_type varchar(20),
bin_volume float,
status char,
truck_number varchar(50),
route_number varchar(50),
initial_entry_date datetime2,
weight int,
prorated_weight_kg float,
notes text, 
directions text,
waste_type varchar(300),
Price smallmoney
);



DROP TABLE OLTP.waste_edge_booking;

SELECT * FROM dbo.staging_table_test;
DROP TABLE dbo.staging_table_test;

Select * FROM [dbo].[staging_table_test];


Select 
	temTable. temTable;

Alter TABLE [dbo].[staging_table_test] add [Date index] date;

SELECT 
[Job No],
 Date,
 PARSENAME(REPLACE(Date, '/', '.'), 1) AS year,
  PARSENAME(REPLACE(Date, '/', '.'), 2) AS month,
   PARSENAME(REPLACE(Date, '/', '.'), 3) AS day
FROM [dbo].[staging_table_test]



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
		Convert(date,newDateStr ,103) 
			FROM dateTable)


SELECT * FROM dateIdxTemTable;
q

UPDATE [dbo].[staging_table_test]
	set 


Select * from [dbo].[staging_table_test];





--Declare @date DATE
--SET 
--SELECT 
--FROM 
--	[dbo].[staging_table_test];
--insert into 

Select DISTINCT [Date index] FROM [DBO].[STAGING_TABLE_TEST]

Select [Date] FROM [DBO].[STAGING_TABLE_TEST] GROUP BY [Date index]

Select [Date] FROM [DBO].[STAGING_TABLE_TEST]


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



select distinct
       year([Date Index]) as orderyear
     , month([Date Index]) as ordermonth

  from [DBO].[staging_table_test]
order
    by year([Date Index])
     , month([Date Index])

insert dbo.dateDim(Date, Day, Month, year)




select 
 [Date Index] AS Date
,day([Date Index]) AS Day
,month([Date Index]) AS Month
,year([Date Index]) AS year
from 
	(select distinct [Date Index] from [dbo].[staging_table_test]) AS for_distinct_dates
order by [Date Index]




SELECT * FROM [dbo].[dateDim] WHERE DATEPART(DW,[Date]) = 6 OR DATEPART(DW,[Date]) = 7 

SELECT	
	[Date],
	 [IsWeekend],
      CASE WHEN DATEPART(DW,[Date]) = 6 THEN 1
      WHEN DATEPART(DW,[Date]) = 7 THEN 1
            ELSE 0 END AS condition
  FROM [dbo].[dateDim]


DECLARE @isWkEnd int = 1 
DECLARE @isNotWkEnd int = 0
Select [IsWeekend], 

--SELECT 'year', DATEADD(year,1,@datetime2)  


select * from DBO.OperatingRevenueFact

truncate table dbo.dateDim

SELECT DATEPART(DW, [Date]) as  FROM [DBO].[dateDim]


DECLARE @IsWkend INT = 1;
DECLARE @IsNotWkend INT = 0;
UPDATE dateDim
    set [IsWeekend] = @IsWkend
	ELSE
	set [IsWeekend] = @IsNotWkend
	IF (SELECT [IsWeekend] FROM [dbo].[dateDim] where DATEPART(DW,[Date]) = 6 OR DATEPART(DW,[Date]) = 7)

IF @StudentMarks >= 80
 PRINT 'Congratulations, You are in First division list!!';
  ELSE
    PRINT 'Failed, Try again ';


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


SELECT	
	[Date],
	 [IsWeekend],
      CASE WHEN DATEPART(DW,[Date]) = 6 THEN 1
      WHEN DATEPART(DW,[Date]) = 7 THEN 1
            ELSE 0 END AS condition
  FROM [dbo].[dateDim]


  77price
ALTER TABLE [DBO].[dateDim] ADD DateKey Date

Select * from [DBO].[OperatingRevenueFact] Order by [DateKey]
Select * FROM [DBO].[dateDim]
SELECT * FROM [dbo].[staging_table_test] Order by [Date index]




update table [DBO].[dateDim] Select cast([Date] as Date)

ALTER TABLE [DBO].[dateDim] 
ALTER  COLUMN [Date]  Date;


INSERT INTO [dbo].[OperatingRevenueFact](DateKey, Weight, Prorated_Weight, Price)
	Select 
		dd.[DateDimId] as DateKey,
		[Weight] as Weight,
		[Prorated Weight] as Prorated_Weight,
		[Price] as Price
	FROM
		[dbo].[dateDim] dd,
		[dbo].[staging_table_test] st
	WHERE
		st.[Date Index] = dd.[Date]

select column_name ,data_type from information_schema.columns where table_schema = 'dbo' and table_name = 'staging_table_test';

select * FROM [dbo].[OperatingRevenueFact] order by DateKey

Truncate Table [dbo].[OperatingRevenueFact]