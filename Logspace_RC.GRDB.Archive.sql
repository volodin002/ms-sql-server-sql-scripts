USE [master]
GO
ALTER DATABASE [RC.GRDB.Archive] MODIFY FILE ( NAME = N'RC.GRDB.Archive_log', SIZE = 40096000KB )
GO
