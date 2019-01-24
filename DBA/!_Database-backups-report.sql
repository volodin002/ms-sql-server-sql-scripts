-----   // backup_type // --------------------
/*
D = Database => This is a full database backup.

I = Differential database => This as the name signifies is a differential backup.

L = Log => Transaction log backup

F = File or filegroup => Any file or filgroup backup is classified as this type

G =Differential file => This again contains the changes since the last full file backup

P = Partial => This forms the base of differential partial backup

Q = Differential partial => A differential partial backup records only the data extents that have changed in the filegroups since the previous partial backup, known as the base for the differential. 
*/
-------------------------------------------------------------------------------- 
SELECT 
	CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
	msdb.dbo.backupset.database_name, 
	msdb.dbo.backupset.backup_start_date, 
	msdb.dbo.backupset.backup_finish_date, 
	msdb.dbo.backupset.expiration_date, 
	msdb.dbo.backupset.type AS backup_type, 
	msdb.dbo.backupset.backup_size, 
	msdb.dbo.backupmediafamily.logical_device_name, 
	msdb.dbo.backupmediafamily.physical_device_name, 
	msdb.dbo.backupset.name AS backupset_name, 
	msdb.dbo.backupset.description 
FROM msdb.dbo.backupmediafamily 
INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 
WHERE 
	(CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 7) -- backups for last week 
	and database_name in (
		'RC.GRDB', 'RC.GRDB.Counterparties', 
		'RC.GRDB.MicexPrice', 'RC.GRDB.Prices',
		'RC.GRDB.BPM', 'RC.GRDB.Counterparties.BPM',
		'RC.Logger', 'RC.GRDB.Archive')

	and msdb.dbo.backupset.type not in ('L') -- except transaction log
ORDER BY 
	backup_start_date,
	msdb.dbo.backupset.database_name, 
	msdb.dbo.backupset.backup_finish_date 