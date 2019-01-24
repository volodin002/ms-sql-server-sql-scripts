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
    
	average_CPU = --Converted from microseconds
    (qs.total_worker_time) / qs.execution_count,

	average_CPU_inSeconds = --Converted from microseconds
    (qs.total_worker_time/1000000) / qs.execution_count,

	average_Time_inSeconds = --Converted from microseconds
    (qs.total_elapsed_time/1000000) / qs.execution_count,
    
	qs.total_elapsed_time,
    total_elapsed_time_inSeconds = --Converted from microseconds
    qs.total_elapsed_time/1000000,

	qs.max_elapsed_time,
	max_Time_inSeconds = --Converted from microseconds
	(qs.max_elapsed_time/1000000),

	qs.min_elapsed_time,
	min_Time_inSeconds = --Converted from microseconds
	(qs.min_elapsed_time/1000000),

	qs.max_worker_time max_CPU_time,
	max_CPU_Time_inSeconds = --Converted from microseconds
	(qs.max_worker_time/1000000),

	qs.min_worker_time min_CPU_time,
	min_CPU_Time_inSeconds = --Converted from microseconds
	(qs.min_worker_time/1000000),

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
	qs.last_execution_time,
	
	qs.max_rows,
	qs.min_rows,
	qs.last_rows,

	qs.max_physical_reads,
	qs.min_physical_reads,
	qs.last_physical_reads,

	qs.max_logical_reads,
	qs.min_logical_reads,
	qs.last_logical_reads,
	qs.query_hash

FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS apply sys.dm_exec_query_plan (qs.plan_handle) AS qp
--where qp.dbid = 10
--	and (st.text like '%OtcPrice_GetLast%' or st.text like '%IssuePrice_GetLast%') 
--and st.text like '(@fullTextData%' and st.text like '%merge FullText.Relation as target%'
ORDER BY qs.total_worker_time DESC 
OPTION (RECOMPILE);

--DBCC FREEPROCCACHE;
/*
SELECT TOP (200)
   
   
    sum(qs.total_worker_time) AS Total_CPU,
    total_CPU_inSeconds = --Converted from microseconds
    sum(qs.total_worker_time)/1000000,
    
	sum(qs.total_elapsed_time) total_elapsed_time,
    total_elapsed_time_inSeconds = --Converted from microseconds
    sum(qs.total_elapsed_time)/1000000
   

FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS apply sys.dm_exec_query_plan (qs.plan_handle) AS qp
--where qp.dbid = 24
OPTION (RECOMPILE);
*/
--DBCC FREEPROCCACHE;

--select DB_ID()
