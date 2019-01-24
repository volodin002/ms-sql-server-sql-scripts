
EXECUTE AS LOGIN = 'RCMOS_NT_01\svcTestSpx_sys'
GO


DECLARE 
	@RestoreDatabaseName nvarchar(150) = N'RC.GRDB.Counterparties.Replica1',
	@FullBackupFileName nvarchar(255) = N'\\vs-tst01-bsm01\GRDBINTSync\RC.GRDB.Counterparties Full 2016.03.15 14-27-35.bak',
	@DestinationDbStandbyFile nvarchar(255) = N'D:\DATA\WEB\RC.GRDB.Counterparties\RC.GRDB.Replica1.standby'

USE [RC.GRDB.Counterparties.Replica1];
ALTER DATABASE [RC.GRDB.Counterparties.Replica1] SET SINGLE_USER WITH ROLLBACK IMMEDIATE

USE [master];

--DROP DATABASE [RC.GRDB.Counterparties.Replica1]
RESTORE DATABASE [RC.GRDB.Counterparties.Replica1] WITH RECOVERY;

RESTORE DATABASE @RestoreDatabaseName
FROM DISK = @FullBackupFileName
WITH 
MOVE N'RC.GRDB' TO N'D:\DATA\WEB\RC.GRDB.Counterparties\RC.GRDB.Replica1.mdf',
MOVE N'RC.GRDB.Books' TO N'D:\DATA\WEB\RC.GRDB.Counterparties\RC.GRDB.Replica1.Books.ndf',
MOVE N'RC.GRDB.BooksTechnical' TO N'D:\DATA\WEB\RC.GRDB.Counterparties\RC.GRDB.Replica1.BooksTechnical.ndf',
MOVE N'RC.GRDB.Common' TO N'D:\DATA\WEB\RC.GRDB.Counterparties\RC.GRDB.Replica1.Common.ndf',
MOVE N'RC.GRDB.FullText' TO N'D:\DATA\WEB\RC.GRDB.Counterparties\RC.GRDB.Replica1.FullText.ndf',
MOVE N'RC.GRDB.Instruments' TO N'D:\DATA\WEB\RC.GRDB.Counterparties\RC.GRDB.Replica1.Instruments.ndf',
MOVE N'RC.GRDB.InstrumentsTechnical' TO N'D:\DATA\WEB\RC.GRDB.Counterparties\RC.GRDB.Replica1.InstrumentsTechnical.ndf',
MOVE N'RC.GRDB.Prices' TO N'D:\DATA\WEB\RC.GRDB.Counterparties\RC.GRDB.Replica1.Prices.ndf',
MOVE N'RC.GRDB.PricesListing' TO N'D:\DATA\WEB\RC.GRDB.Counterparties\RC.GRDB.Replica1.PricesListing.ndf',
MOVE N'RC.GRDB.Publication' TO N'D:\DATA\WEB\RC.GRDB.Counterparties\RC.GRDB.Replica1.Publication.ndf',
MOVE N'RC.GRDB.Technical' TO N'D:\DATA\WEB\RC.GRDB.Counterparties\RC.GRDB.Replica1.CommonTechnical.ndf',
MOVE N'RC.GRDB.Processing' TO N'D:\DATA\WEB\RC.GRDB.Counterparties\RC.GRDB.Replica1.Processing.ndf',
MOVE N'RC.GRDB.Counterparties' TO N'D:\DATA\WEB\RC.GRDB.Counterparties\RC.GRDB.Replica1.Counterparties.ndf',
MOVE N'RC.GRDB.CounterpartiesTechnical' TO N'D:\DATA\WEB\RC.GRDB.Counterparties\RC.GRDB.Replica1.CounterpartiesTechnical.ndf',
MOVE N'RC.GRDB_log' TO N'D:\DATA\WEB\RC.GRDB.Counterparties\RC.GRDB.Replica1_log.ldf',

STANDBY = @DestinationDbStandbyFile,
NOUNLOAD, REPLACE, STATS = 10;

--RESTORE DATABASE [RC.GRDB.Counterparties]
--FROM DISK = N'\\vs-tst01-bsm01\GRDBINTSync\RC.GRDB.Counterparties Full 2016.03.14 17-38-31.bak'
--WITH RECOVERY, REPLACE, STATS = 10;

ALTER DATABASE  [RC.GRDB.Counterparties.Replica1] SET MULTI_USER;

GO

REVERT;

--DROP DATABASE [RC.GRDB.Counterparties.Replica1];