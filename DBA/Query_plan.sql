--USE [master]
--GO
--ALTER DATABASE [RC.GRDB.Counterparties] SET ARITHABORT ON WITH NO_WAIT
--GO

SELECT cp.objtype AS ObjectType,
OBJECT_NAME(st.objectid,st.dbid) AS ObjectName,
cp.usecounts AS ExecutionCount,
st.TEXT AS QueryText,
qp.query_plan AS QueryPlan
,qs.*
FROM sys.dm_exec_cached_plans AS cp with(nolock)
LEFT JOIN
    sys.dm_exec_query_stats qs WITH (NOLOCK)
ON  qs.plan_handle = cp.plan_handle

CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) AS qp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) AS st
where st.dbid = 10
and st.Text like '%ServAgrProductType%for xml raw, type%' --and st.Text like 'with ServAgrLabel as (%' -- 'create table #ParentIds%'
and cp.usecounts > 10
--and cp.usecounts = 1
--and
--st.TEXT like '%@PartyId%' and st.Text like '%AllDocumentParty%'




