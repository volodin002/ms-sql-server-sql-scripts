
--select DB_ID()

SELECT d.object_id, d.database_id, OBJECT_NAME(object_id, database_id) 'proc name',   
    
	d.last_execution_time, d.max_elapsed_time, d.min_elapsed_time,
    d.total_elapsed_time/d.execution_count AS [avg_elapsed_time],  
    d.last_elapsed_time, d.execution_count , d.total_elapsed_time,
	d.cached_time

FROM sys.dm_exec_procedure_stats AS d  
WHERE d.database_id = 15 --and OBJECT_NAME(object_id, database_id) = 'Listing_GetFreeSymbolRencapSecId'
ORDER BY 
--[total_worker_time] 
max_elapsed_time
DESC;  