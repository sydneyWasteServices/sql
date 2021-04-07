# Data Audit findings

#### DataFrame Issues  

##### Booking

###### 2021-Mar-24 to 2021-Mar-30 s
    General Waste
        RL2  
        Weight in ton has thousand of tons exceed. 
    Cardboard
        RED
        Weight in ton has thousand of tons exceed
        s
#### General issues

##### Route Number weekday does not match with the actual weekday

    E.g. BR-1 does not match with the actual date's Weekday

    1. reason could be Subcontractor's run 
    2. Runs have been already void 
    etc.


#### Note - Data Audit Queries

##### Earliest and Last Date
SELECT MIN(DISTINCT [Date]) as EarliestDate, count(*)
FROM [BOOKING].[STAGE_TABLE_1]

SELECT MAX(DISTINCT [Date]) as LATESTDATE, count(*)
FROM [BOOKING].[STAGE_TABLE_1]


SELECT MIN(DISTINCT [Date]) as EarliestDate,
MAX(DISTINCT [Date]) as LATESTDATE, count(*)
FROM #SWS_WEEK_YEAR


##### Earliest and Last Date
ALTER TABLE [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2]
ALTER COLUMN [Weekday] INT;


##### Is Booking weekday same as date weekday

SET DATEFIRST 1
SELECT [Job No],[Date],DATEPART(WEEKDAY, [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date]) , [Weekday]
FROM [STAGE_2_DB].[BOOKING_SCH_S2].BOOKING_TB_S2 
Where [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Weekday] != DATEPART(DW, [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date])  


##### Check Query return data type  

DECLARE @query nvarchar(max) = 'SELECT TOP 3 DATEPART(DW, [STAGE_2_DB].[BOOKING_SCH_S2].[BOOKING_TB_S2].[Date]) 
FROM [STAGE_2_DB].[BOOKING_SCH_S2].BOOKING_TB_S2 ';
EXEC sp_describe_first_result_set @query, null, 0;  

##### CDC Table

SELECT * FROM [cdc].[dbo_Users_CT] GO
