-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
--CREATE PROCEDURE <Procedure_Name, sysname, ProcedureName> 
--	-- Add the parameters for the stored procedure here
--	<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
--	<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--    -- Insert statements for procedure here
--	SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
--END
--GO   Customer Name  Complex Solutions

CREATE PROCEDURE SelectByCustomerName
@cName varchar(100)
AS
BEGIN
SELECT 
[Job No] 
FROM 
[dbo].[sws_booking_1] 
where 
[Customer Name] = @cName
END;


GO

truncate table [dbo].[DimDept]
    SELECT distinct [Location]
    FROM [PTO_DW_AMOS].[DBO].[TASKs_dw]


insert into [dbo].[DimMonth](PKey, Month) values(1,'Jan')
......   (12,'Dec')
-- =================================

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
