CREATE SCHEMA ssis_test;
go


CREATE TABLE ssis_test.ssis_csv_load(
id int IDENTITY(1,1),
Date date,
sch_Time_Start varchar(10),
sch_Time_End varchar(10),
lat Decimal(9,6),
lng Decimal(8,6),
customer_number float,
customer_Name varchar(500))

ALTER TABLE ssis_test.ssis_csv_load
ADD job_id int;


ALTER TABLE ssis_test.ssis_csv_load
ADD job_id int;


ALTER TABLE ssis_test.ssis_csv_load
ALTER COLUMN customer_number int;

SELECT * from ssis_test.ssis_csv_load;


DELETE FROM ssis_test.ssis_csv_load;


SELECT *
    FROM Databases.INFORMATION_SCHEMA;


Drop TABLE master.ssis_test.ssis_csv_load;

CREATE DATABASE SWS_Star_DWH;

CREATE test_db.


SELECT * FROM dbo.sws_booking_1;

DROP TABLE [dbo].[sws_booking];
-- ==================================

--Truncate the table prevent duplicate information
Truncate table [dbo].[task]
 
SELECT 
	DISTINCT [STATE]
FROM [CRIME].[SOURCE_DATA_STAGING]
ORDER BY [STATE] ASC

INSERT INTO [dbo].[DimDept]
 SELECT distinct [Dept]
	FROM [PTO_DW_Amos].[dbo].[Tasks_dw];

-- Fact Table
Truncate TABLE [dbo].[FactTasks]


INSERT INTO [dbo].[FactTacks]
--p.PKEY = Column of PKEYType
--It will Insert whether below script is true
SELECT p.PKEY as [PKEYType]
	,l.Pkey as [PKeyLocation]
	,d.PKey as [PkeyDept]
	,m.Pkey as [PkeyMonth],
	[Amount]
FROM
	[dbo].[Task_dw] t, 
	[dbo].[DimDept] d,
	[dbo].[DimMonth] m,
	[dbo].[DimType] p
WHERE
	t.Dept = d.Dept
AND
	t.Location = l.Location 
AND 
	t.Month = m.Month 
AND
	t.Type = p.Type
 
 
-- ==================================
SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema ='dbo' AND TABLE_NAME = 'sws_booking_1' ;
--USE master;  
--DECLARE @root nvarchar(100);  
--DECLARE @fullpath nvarchar(1000);  
  
--SELECT @root = FileTableRootPath();  
--SELECT @fullpath = @root + file_stream.GetFileNamespacePath()  
--    FROM filetable_name  
--    WHERE name = N'document_name';  
  
--PRINT @fullpath;  
--GO  



--DECLARE 
--      @SQL NVARCHAR(1000)
--    , @DB_NAME NVARCHAR(100) = 'AdventureWorks2008R2'

--SELECT TOP 1 @SQL = '
--    BACKUP DATABASE [' + @DB_NAME + '] 
--    TO DISK = ''' + REPLACE(mf.physical_name, '.mdf', '.bak') + ''''
--FROM sys.master_files mf
--WHERE mf.[type] = 0
--    AND mf.database_id = DB_ID(@DB_NAME)

--PRINT @SQL
--EXEC sys.sp_executesql @SQL