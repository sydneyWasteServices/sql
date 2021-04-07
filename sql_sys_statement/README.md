#### System fn / inspect sys

##### list all DB
SELECT name, database_id, create_date  
FROM sys.databases ;  
GO  


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

##### Add Column 
ALTER TABLE dbo.doc_exa ADD column_b VARCHAR(20) NULL, column_c INT NULL ;

##### Is CDC enabled with Schema and Table name

    USE STAGE_2_DB
    GO

    SELECT s.name AS Schema_Name, tb.name AS Table_Name
    , tb.object_id, tb.type, tb.type_desc, tb.is_tracked_by_cdc
    FROM sys.tables tb
    INNER JOIN sys.schemas s on s.schema_id = tb.schema_id
    WHERE tb.is_tracked_by_cdc = 1

##### List all tables in DB


    SELECT TABLE_CATALOG, 
        TABLE_SCHEMA, 
        TABLE_NAME, 
        COLUMN_NAME, 
        DATA_TYPE, 
        IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS

    WHERE TABLE_NAME = 'Employee';


***Only list Schema and Table name 
    SELECT 
        TABLE_SCHEMA, 
        TABLE_NAME
    FROM INFORMATION_SCHEMA.COLUMNS
    GROUP BY 
        INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA,
        INFORMATION_SCHEMA.COLUMNS.TABLE_NAME


