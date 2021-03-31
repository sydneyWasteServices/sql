How to check SQL server version name using command prompt?
Step 1 -Open a command prompt window on the machine in which SQL is installed.
Go to Start → Run, type cmd, and hit enter to open the command prompt.

Step 2 -SQLCMD -S servername\instancename (where servernameb= the name of your server, and instancename is the name of the SQL instance).The prompt will change to 1→.

Step 3 -select @@version

Step 4 -At the 2→ prompt type go and hit enter.
This will return the SQL version that is running on your server. If you have multiple instances repeat the process for each instance. The servername mentioned above will be the name of the machine SQL is installed on.

If you are unsure of your instance name do the following:

Step 1 -Open a command prompt window as described above.

Step 2 -services.msc.

Step 3 -Locate the entries beginning with SQL.
There will be an entry for each instance called SQL Server (instancename). The instance name appears within the parentheses.



Values.ID
AccountDetails.AcctID
EntityDetails.EntID



INSERT INTO schema.table VALUES (TO_DATE('17/12/2015'),'DD/MM/YYYY'));

INSERT INTO AccountDetails.AcctID


CREATE SCHEMA Chains;
GO 
-- data type dec(10,2)   0000000000.00
CREATE TABLE Chains.Sizes (ID int, width dec(5,2));

CREATE TABLE Chains.test_db (Id int, name varchar(10));

select * from Chains.test_db;
go

CREATE SCHEMA Finance;
GO

CREATE TABLE Finance.test_db_1(
id int IDENTITY(1,1),
date date,
Customer_Name varchar(1000),
Address varchar(1000),
City varchar(1000),	
State varchar(100),
PostCode int,
Qty_Scheduled int, 	
Qty_Serviced int,	
Serv_Type varchar(100),
Bin_Volume dec(10,5),
Status varchar(10),
Truck_number varchar(500),
Route_number varchar(500),
Waste_Type varchar(500),
Price dec(20,5)
)



CREATE SCHEMA Values1;
GO

CREATE TABLE Values1.Values1(
ID int,
AcctID int,
EntID int,
LogID int,
Month int,
Value int
)
GO

CREATE SCHEMA AccountDetails;
GO


CREATE SCHEMA EntityDetails;
GO

CREATE TABLE EntityDetails.EntityDetails(

EntDesc varchar(100)
)
GO

CREATE SCHEMA Logs
GO


CREATE TABLE AccountDetails.AccountDetails(
AcctID int,
AcctDesc varchar(100)
)
GO

CREATE TABLE EntityDetails.EntityDetails(
EntID int,
EntDesc varchar(100)
)
GO
CREATE TABLE Logs.Logs(
LogID int,
Timestamp datetime, 
Username varchar(100),
UploadDesc varchar(100)
)


DROP TABLE AccountDetails.AcctID
DROP TABLE EntityDetails.EntID
DROP TABLE Logs.LogID
DROP TABLE Values1.ID
a

SELECT
  *
FROM Values1.Values1
JOIN AccountDetails.AccountDetails
  ON Values1.AcctID = AccountDetails.AcctID 
JOIN course
  ON course.id = EntityDetails.EntID
  JOIN course
  ON course.id = student_course.course_id;

--most recent upload
--SELECT DISTINCT ON (sensorID)
--sensorID, timestamp, sensorField1, sensorField2 
--FROM sensorTable
--ORDER BY sensorID, timestamp DESC;




-- INSERT INTO schema.table VALUES (TO_DATE('17/12/2015'),'DD/MM/YYYY'));
 --ANSI Date literal which uses a fixed format 'YYYY-MM-DD'
 --SQL> INSERT INTO t(dob) VALUES(DATE '2015-12-17');


 select * from Finance.test_db_1;

 DROP TABLE Finance.test_db_1;

 select count(*) from Finance.test_db_1;

 DELETE FROM Finance.test_db_1;

 select * from 
 Finance.test_db_1 
 where postcode = 0;


 --Aggregate as Sales price
 SELECT *, price * bin_volume as sales
 from Finance.test_db_1
 order by date desc;
