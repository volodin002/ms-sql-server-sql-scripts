
use [master];
go
WITH LastRestores AS
(
SELECT
    DatabaseName = [d].[name] ,
    [d].[create_date] ,
    [d].[compatibility_level] ,
    [d].[collation_name] ,
    r.*,
    RowNum = ROW_NUMBER() OVER (PARTITION BY d.Name ORDER BY r.[restore_date] DESC)
FROM master.sys.databases d
LEFT OUTER JOIN msdb.dbo.[restorehistory] r ON r.[destination_database_name] = d.Name
)
SELECT DatabaseName, restore_date, destination_database_name, restore_type, replace, recovery,  user_name
FROM [LastRestores]
WHERE 
	[RowNum] < 10 and DatabaseName IN ('RC.GRDB.Test.Replica1', 'RC.GRDB.Test.Replica2')
ORDER BY 
	[restore_date] desc

GO
--RESTORE DATABASE [RC.GRDB.Test.Replica1] WITH RECOVERY;