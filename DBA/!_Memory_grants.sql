select * from sys.dm_os_wait_stats with(nolock)
where wait_type like 'RESOURCE_SEMAPHORE%'

select 
cp.objtype AS ObjectType,
OBJECT_NAME(st.objectid,st.dbid) AS ObjectName,
cp.usecounts AS ExecutionCount,
st.TEXT AS QueryText,
qp.query_plan AS QueryPlan,
mg.*
from sys.dm_exec_query_memory_grants mg with(nolock) 
join sys.dm_exec_cached_plans cp with(nolock) ON  mg.plan_handle = cp.plan_handle
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) AS qp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) AS st
where st.dbid = 10