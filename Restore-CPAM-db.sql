USE [master]

ALTER DATABASE [RC.GRDB.Counterparties.CPAM]
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

RESTORE DATABASE [RC.GRDB.Counterparties.CPAM]
FROM  DISK = N'E:\GRDBUAT\Backup\RC.GRDB.Counterparties 2017-12-05 18-33 prod.bak' 
WITH  FILE = 1,  
MOVE N'RC.GRDB' TO N'E:\GRDBUAT\Data\RC.GRDB.Counterparties.CPAM\RC.GRDB.mdf',  
MOVE N'RC.GRDB.Cp' TO N'E:\GRDBUAT\Data\RC.GRDB.Counterparties.CPAM\RC.GRDB.Cp.ndf',  
MOVE N'RC.GRDB.CpTechnical' TO N'E:\GRDBUAT\Data\RC.GRDB.Counterparties.CPAM\RC.GRDB.CpTechnical.ndf',  
MOVE N'RC.GRDB.CpPublication' TO N'E:\GRDBUAT\Data\RC.GRDB.Counterparties.CPAM\RC.GRDB.CpPublication.ndf',  
MOVE N'RC.GRDB.Technical' TO N'E:\GRDBUAT\Data\RC.GRDB.Counterparties.CPAM\RC.GRDB.Technical.ndf',  
MOVE N'RC.GRDB.FullText' TO N'E:\GRDBUAT\Data\RC.GRDB.Counterparties.CPAM\RC.GRDB.FullText.ndf',  
MOVE N'RC.GRDB_log' TO N'F:\GRDBUAT\Log\RC.GRDB.Counterparties.CPAM\RC.GRDB_log.ldf',  
NOUNLOAD,  REPLACE,  STATS = 5

GO


-- E:\GRDBDEV\Data\
-- E:\GRDBDEV\Backup