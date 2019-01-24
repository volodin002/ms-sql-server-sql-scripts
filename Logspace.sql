
--EXECUTE AS LOGIN = 'RCMOS_NT_01\svcGRDB_sys'

DBCC SQLPERF(logspace);

--BACKUP LOG [RC.Logger] TO DISK = 'NUL:' 

--BACKUP LOG [RC.GRDB.Archive] TO DISK = 'NUL:' 

--BACKUP LOG [RC.GRDB.Prices] TO DISK = 'NUL:' ;


/*
SELECT CAST(StateContents as xml) FROM [Processing].[StateInfo] WHERE StateInfoName = 'IndexStatisticsPollingThread'
UPDATE [Processing].[StateInfo] SET
	StateContents = 
N'<IndexStatisticsProcessor>
  <LastRunDate>2016-03-16T00:00:00+03:00</LastRunDate>
</IndexStatisticsProcessor>'
 WHERE StateInfoName = 'IndexStatisticsPollingThread'
 */
 
 --exec sp_who2

 --CHECKPOINT 