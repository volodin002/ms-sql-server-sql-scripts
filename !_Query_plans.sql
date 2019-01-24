/*****	Script: Top 20 Stored Procedures using High CPU *****/
/*****	Support: SQL Server 2008 and Above *****/
/*****	Tested On: SQL Server 2008 R2 and 2014 *****/
/*****	Output: Queries, CPU, Elapsed Times, Ms and S ****/
SELECT TOP (200)
    st.text AS Query,
	DB_NAME(qp.dbid) db_name,
    qs.execution_count,
    qs.total_worker_time AS Total_CPU,
    total_CPU_inSeconds = --Converted from microseconds
    qs.total_worker_time/1000000,
    average_CPU_inSeconds = --Converted from microseconds
    (qs.total_worker_time/1000000) / qs.execution_count,

	average_CPU = --Converted from microseconds
    (qs.total_worker_time) / qs.execution_count,

	average_Time_inSeconds = --Converted from microseconds
    (qs.total_elapsed_time/1000000) / qs.execution_count,
    
	qs.total_elapsed_time,
    total_elapsed_time_inSeconds = --Converted from microseconds
    qs.total_elapsed_time/1000000,
    qp.query_plan,
	
	last_grant_kb,
	min_grant_kb,
	max_grant_kb,
	last_used_grant_kb,
	min_used_grant_kb,
	max_used_grant_kb,

	last_ideal_grant_kb,
	min_ideal_grant_kb,
	max_ideal_grant_kb,

	last_dop, min_dop, max_dop,
	
	qs.creation_time,
	qs.last_execution_time

FROM sys.dm_exec_query_stats AS qs with(nolock)
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS apply sys.dm_exec_query_plan (qs.plan_handle) AS qp
--where qp.dbid = 10
--and st.text like '(@RowStart int,@RowEnd int,@ProviderId nvarchar(_),@PartyId nvarchar(_),@IsRoot nvarchar(_))with%'
ORDER BY qs.total_worker_time DESC OPTION (RECOMPILE);

--DBCC FREEPROCCACHE;

--SELECT TOP (200)
   
   
--    sum(qs.total_worker_time) AS Total_CPU,
--    total_CPU_inSeconds = --Converted from microseconds
--    sum(qs.total_worker_time)/1000000,
    
--	sum(qs.total_elapsed_time) total_elapsed_time,
--    total_elapsed_time_inSeconds = --Converted from microseconds
--    sum(qs.total_elapsed_time)/1000000
   

--FROM sys.dm_exec_query_stats AS qs
--CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
--CROSS apply sys.dm_exec_query_plan (qs.plan_handle) AS qp
--where qp.dbid = 13
--OPTION (RECOMPILE);

----DBCC FREEPROCCACHE;

-- select DB_ID()