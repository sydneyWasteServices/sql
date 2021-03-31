CREATE SCHEMA Split_col_test;
go

CREATE TABLE Split_col_test.Split_col1(
id int IDENTITY(1,1),
col1 varchar,
num_col int
)
select * from student;

--dbo default schema => database owner

CREATE TABLE dbo.sws_booking(
Id int IDENTITY(1,1),
Job_No float ,
Date date,
Schd_Time_Start time,
Schd_Time_End time,
Lat decimal(8,6),
Lng decimal(9,6),
Customer_number float,
Customer_Name varchar(1000),
Site_Name varchar(1000),
Address_1 varchar(1000),
Address_2 varchar(1000),
City varchar(500),
State varchar(30),
PostCode int,
Zone varchar(100),
Phone varchar(100),
Qty_Scheduled int,
Qty_Serviced int,
Serv_Type varchar(10),
Container_Type varchar(20),
Bin_Volume float,
Status char,
Truck_number varchar(50),
Route_number varchar(50),
Generate_ID varchar(100),
Initial_Entry_Date datetime2,
Weight float,
Prorated_Weight float,
Notes text,
Directions text,
CheckLists varchar(1000),
Waste_Type varchar(300),
Tip_Site varchar(500),
Price smallmoney,
PO varchar(100)
);


drop table dbo.sws_booking;
select * FROM dbo.sws_booking;	 


DROP TABLE OLTP.waste_edge_booking;

--au_Fiscal_Month => month 1 is July to 12 June
--IsWeekend => Saturday Sunday
--bit => boolean => 1,0,null
--Payweek increment every Tuesday and end at the year end

CREATE TABLE dbo.dateDim(
DateDimId int IDENTITY(1,1),
Date datetime2,
Day int,
Month int,
year int,
AccFiscalYear varchar(100),
AccFiscalMonth int,
PayWeek int,
IsHoliday bit,
IsWeekend bit);

--Timestamp May be, not sure how to convert time and date together

CREATE TABLE dbo.OperatingRevenueFact(
OperatingRevFactID int IDENTITY(1,1),
Weight float,
Prorated_Weight float,
Price smallmoney
);

drop TABLE dbo.dateDim;

select * from dbo.sws_booking_1;

ALTER TABLE table_name
MODIFY column_name datatype;
)

select * from dbo.sws_booking_1;

SELECT column_name,data_type from INFORMATION_SCHEMA.COLUMNS where table_schema = 'dbo' and table_name = 'staging_table_test';

EXEC dbo.SelectByCustomerName @cName = 'Complex Solutions';

select * from dbo.staging_table_test;

--DD/MM/YY

select CONVERT(datetime2, DATE) FROM dbo.staging_table_test;

select * from dbo.staging_table_test where [Schd Time End] IS NULL;

SELECT TRY_CONVERT(datetime2, Date, 103) as StringToDate From dbo.staging_table_test;

select GETDATE(Date) FROM dbo.staging_table_test;

SELECT CONVERT(datetime2,Date,103) as strToDate FROM dbo.staging_table_test;
SELECT PARSE(Date as datetime2) as strToDate from dbo.staging_table_test;

SELECT CONVERT(DATE,SUBSTRING(Date,2,8)),3) as strToDate FROM dbo.staging_table_test --3 for dd/mm/yy

SELECT  CAST(SUBSTRING(Date,2,8)  AS DATE) FROM dbo.staging_table_test;


select * from dbo.staging_table_test
SELECT len(Date) as lenght From dbo.staging_table_test;

SELECT CONCAT(Date,''


SELECT cast(Date as date) from dbo.staging_table_test;


--WITH
--(
-- DISTRIBUTION = ROUND_ROBIN
-- ,CLUSTERED COLUMNSTORE INDEX
--)

--CREATE TABLE [dbo].[FactInternetSales_new]
--AS
Select CONVERT(varchar, Date, 103) as stringToDate into  [dbo].[test_1] From [dbo].staging_table_test ;

SELECT column_name,data_type from INFORMATION_SCHEMA.COLUMNS where table_schema = 'dbo' and table_name = 'test_1';

drop table test_1


DECLARE @STRING VARCHAR(MAX) 
DECLARE @SPECIALCHARACTER CHAR(1) 
SET @STRING='NISARG,NIRALI,RAMESH,SURESH' 
SELECT * 
FROM   STRING_SPLIT (@STRING, ',')


Select STRING_SPLIT(Date, '/') From [dbo].staging_table_test ;


declare @tmp table (DateStr varchar(500))

Select Date as DateStr into @tmp From [dbo].staging_table_test
;WITH [dbo].[staging_table_test]
AS (
    SELECT DateStr
        ,CAST('<x>' + REPLACE(DateStr, '/', '</x><x>') + '</x>' AS XML) AS Parts
    FROM @tmp
    )
SELECT Date
    ,Parts.value(N'/x[1]', 'varchar(50)') AS [First]
    ,Parts.value(N'/x[2]', 'varchar(50)') AS [Second]
    ,Parts.value(N'/x[3]', 'varchar(50)') AS [Third] 
FROM dbo.staging_table_test;


Declare [dbo].[test] table (name varchar(50))

Select Date as DateStr into [dbo].[test] From [dbo].staging_table_test;
select parsename(DateStr,3),parsename(DateStr,2),parsename(DateStr,1) from [dbo].[test];


DECLARE @EmployeeName VARCHAR(120)
 
SELECT @EmployeeName = 'Monpara, Vishal'


SELECT DateStr,
 PARSENAME(REPLACE(DateStr, '/', '.'), 1) AS year,
  PARSENAME(REPLACE(DateStr, '/', '.'), 2) AS month,
   PARSENAME(REPLACE(DateStr, '/', '.'), 2) AS day
FROM [dbo].[test]


WITH DateSplit 
as 
(SELECT DateStr,
 PARSENAME(REPLACE(DateStr, '/', '.'), 1) AS year,
  PARSENAME(REPLACE(DateStr, '/', '.'), 2) AS month,
   PARSENAME(REPLACE(DateStr, '/', '.'), 2) AS day
FROM [dbo].[test]),
dateTable AS (Select CONCAT(day,'/',month,'/20',year) wqqqqwas newDateStr FROM DateSplit)
Select Convert(date,newDateStr ,103) as realdate FROM dateTable;


ALTER TABLE YOUR_TABLE ADD DATETIME_COL DATETIME

select Date STRING_SPLIT()

sp_help 'dbo.staging_table_test' 


WITH DateSplit 
as 
(SELECT Date,
 PARSENAME(REPLACE(Date, '/', '.'), 1) AS year,
  PARSENAME(REPLACE(Date, '/', '.'), 2) AS month,
   PARSENAME(REPLACE(Date, '/', '.'), 2) AS day
FROM [dbo].[staging_table_test]),
dateTable AS 
(Select 
    CONCAT(day,'/',month,'/20',year) 
    as newDateStr 
    FROM DateSplit)
Select 
    Convert(date,newDateStr ,103) 
        as Date_idx 
        into [dbo].[staging_table_test] FROM dateTable;

Select * from [dbo].[sws_booking_1];



WITH DateSplit as
(SELECT [Job No], Date,
 PARSENAME(REPLACE(Date, '/', '.'), 1) AS year,
  PARSENAME(REPLACE(Date, '/', '.'), 2) AS month,
   PARSENAME(REPLACE(Date, '/', '.'), 2) AS day
FROM [dbo].[staging_table_test])
Select [Job No], CONCAT(day,'/',month,'/20',year) 
    FROM DateSplit;



--dateTable AS 
--(Select 
--    CONCAT(day,'/',month,'/20',year) 
--    as newDateStr 
--    FROM DateSplit)

