--USE [RC.GRDB.Archive]
-- USE [RC.GRDB]

SELECT 
                s.name,
                OBJECT_NAME(ind.OBJECT_ID) AS TableName, 
                ind.name AS IndexName,
                indexstats.partition_number,
                indexstats.index_type_desc AS IndexType, 
                indexstats.avg_fragmentation_in_percent 
FROM
                sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats 
INNER JOIN
                sys.indexes ind  ON ind.object_id = indexstats.object_id AND ind.index_id = indexstats.index_id 
LEFT JOIN
                sys.objects ob on ind.object_id = ob.object_id
LEFT JOIN
                sys.schemas as s on ob.schema_id = s.schema_id

