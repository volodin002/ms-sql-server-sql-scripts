/**************************************************************/
--Script: Top Performance Counters - Memory
--Works On: 2008, 2008 R2, 2012, 2014, 2016
/**************************************************************/

/*
Script to Monitor SQL Server Memory Usage: Top Performance Counters � Memory

Results:

Total Server Memory: Shows how much memory SQL Server is using. The primary use of SQL Server�s memory is for the buffer pool, but some memory is also used for storing query plans and keeping track of user process information.

Target Server Memory: This value shows how much memory SQL Server attempts to acquire. If you haven�t configured a max server memory value for SQL Server, the target amount of memory will be about 5MB less than the total available system memory.

Connection Memory (GB): The Connection Memory specifies the total amount of dynamic memory the server is using for maintaining connections

Lock Memory (GB): Shows the total amount of memory the server is using for locks

SQL Cache Memory: Total memory reserved for dynamic SQL statements.

Optimizer Memory: Memory reserved for query optimization.

Granted Workspace Memory: Total amount of memory currently granted to executing processes such as hash, sort, bulk copy, and index creation operations.

Cursor memory usage: Memory using for cursors

Free pages: Amount of free space in pages which are commited but not currently using by SQL Server

Reserved Pages: Shows the number of buffer pool reserved pages.

Stolen pages (MB): Memory used by SQL Server but not for Database pages.It is used for sorting or hashing operations, or �as a generic memory store for allocations to store internal data structures such as locks, transaction context, and connection information.

Cache Pages: Number of 8KB pages in cache.

Page life expectancy: Average how long each data page is staying in buffer cache before being flushed out to make room for other pages

Free list stalls / sec: Number of times a request for a �free� page had to wait for one to become available.

Checkpoint Pages/sec: Checkpoint Pages/sec shows the number of pages that are moved from buffer to disk per second during a checkpoint process

Lazy writes / sec: How many times per second lazy writer has to flush dirty pages out of the buffer cache instead of waiting on a checkpoint.

Memory Grants Outstanding: Number of processes that have successfully acquired workspace memory grant.

Memory Grants Pending: Number of processes waiting on a workspace memory grant.

process_physical_memory_low: Process is responding to low physical memory notification

process_virtual_memory_low: Indicates that low virtual memory condition has been detected

Min Server Memory: Minimum amount of memory SQL Server should acquire

Max Server Memory: Maximum memory that SQL Server can acquire from OS

Buffer cache hit ratio: Percentage of pages that were found in the buffer pool without having to incur a read from disk.

Analysis:

Total Server Memory is almost same as Target Server Memory: Good Health

Total Server Memory is much smaller than Target Server Memory: There is a Memory Pressure or Max Server Memory is set to too low.

Connection Memory: When high, check the number of user connections and make sure it�s under expected value as per your business

Optimizer Memory: Ideally, the value should remain relatively static. If this isn�t the case you might be using dynamic SQL execution excessively.

Higher the value for Stolen Pages: Find the costly queries / procs and tune them

Higher the value for Checkpoint Pages/sec: Problem with I/O, Do not depend on Automatic Checkpoints and use In-direct checkpoints.

Page life expectancy: Usually 300 to 400 sec for each 4 GB of memory. Lesser the value means memory pressure

Free list stalls / sec: High value indicates that the server could use additional memory.

Memory Grants Outstanding: Higher value indicates peak user activity

Memory Grants Pending: Higher value indicates SQL Server need more memory

process_physical_memory_low & process_virtual_memory_low: Both are equals to 0 means no internal memory pressure

Min Server Memory: If it is 0 means default value didnt get changed, it�ll always be better to have a minimum amount of memory allocated to SQL Server

Max Server Memory: If it is default to 2147483647, change the value with the correct amount of memory that you can allow SQL Server to utilize.

Buffer cache hit ratio: This ratio should be in between 95 and 100. Lesser value indicates memory pressure
*/


-- Get size of SQL Server Page in bytes
DECLARE @pg_size INT, @Instancename varchar(50)
SELECT @pg_size = low from master..spt_values where number = 1 and type = 'E'

-- Extract perfmon counters to a temporary table
IF OBJECT_ID('tempdb..#perfmon_counters') is not null DROP TABLE #perfmon_counters
SELECT * INTO #perfmon_counters FROM sys.dm_os_performance_counters;

-- Get SQL Server instance name as it require for capturing Buffer Cache hit Ratio
SELECT  @Instancename = LEFT([object_name], (CHARINDEX(':',[object_name]))) 
FROM    #perfmon_counters 
WHERE   counter_name = 'Buffer cache hit ratio';


SELECT * FROM (
SELECT  'Total Server Memory (GB)' as Cntr,
        (cntr_value/1048576.0) AS Value 
FROM    #perfmon_counters 
WHERE   counter_name = 'Total Server Memory (KB)'
UNION ALL
SELECT  'Target Server Memory (GB)', 
        (cntr_value/1048576.0) 
FROM    #perfmon_counters 
WHERE   counter_name = 'Target Server Memory (KB)'
UNION ALL
SELECT  'Connection Memory (MB)', 
        (cntr_value/1024.0) 
FROM    #perfmon_counters 
WHERE   counter_name = 'Connection Memory (KB)'
UNION ALL
SELECT  'Lock Memory (MB)', 
        (cntr_value/1024.0) 
FROM    #perfmon_counters 
WHERE   counter_name = 'Lock Memory (KB)'
UNION ALL
SELECT  'SQL Cache Memory (MB)', 
        (cntr_value/1024.0) 
FROM    #perfmon_counters 
WHERE   counter_name = 'SQL Cache Memory (KB)'
UNION ALL
SELECT  'Optimizer Memory (MB)', 
        (cntr_value/1024.0) 
FROM    #perfmon_counters 
WHERE   counter_name = 'Optimizer Memory (KB) '
UNION ALL
SELECT  'Granted Workspace Memory (MB)', 
        (cntr_value/1024.0) 
FROM    #perfmon_counters 
WHERE   counter_name = 'Granted Workspace Memory (KB) '
UNION ALL
SELECT  'Cursor memory usage (MB)', 
        (cntr_value/1024.0) 
FROM    #perfmon_counters 
WHERE   counter_name = 'Cursor memory usage' and instance_name = '_Total'
UNION ALL
SELECT  'Total pages Size (MB)', 
        (cntr_value*@pg_size)/1048576.0 
FROM    #perfmon_counters 
WHERE   object_name= @Instancename+'Buffer Manager' 
        and counter_name = 'Total pages'
UNION ALL
SELECT  'Database pages (MB)', 
        (cntr_value*@pg_size)/1048576.0 
FROM    #perfmon_counters 
WHERE   object_name = @Instancename+'Buffer Manager' and counter_name = 'Database pages'
UNION ALL
SELECT  'Free pages (MB)', 
        (cntr_value*@pg_size)/1048576.0 
FROM    #perfmon_counters 
WHERE   object_name = @Instancename+'Buffer Manager' 
        and counter_name = 'Free pages'
UNION ALL
SELECT  'Reserved pages (MB)', 
        (cntr_value*@pg_size)/1048576.0 
FROM    #perfmon_counters 
WHERE   object_name=@Instancename+'Buffer Manager' 
        and counter_name = 'Reserved pages'
UNION ALL
SELECT  'Stolen pages (MB)', 
        (cntr_value*@pg_size)/1048576.0 
FROM    #perfmon_counters 
WHERE   object_name=@Instancename+'Buffer Manager' 
        and counter_name = 'Stolen pages'
UNION ALL
SELECT  'Plan Cache (MB)', 
        (cntr_value*@pg_size)/1048576.0 
FROM    #perfmon_counters 
WHERE   object_name=@Instancename+'Plan Cache' 
        and counter_name = 'Cache Pages' and instance_name = '_Total'
UNION ALL
SELECT  'Page Life Expectency in seconds',
        cntr_value 
FROM    #perfmon_counters 
WHERE   object_name=@Instancename+'Buffer Manager' 
        and counter_name = 'Page life expectancy'
UNION ALL
SELECT  'Free list stalls/sec',
        cntr_value 
FROM    #perfmon_counters 
WHERE   object_name=@Instancename+'Buffer Manager' 
        and counter_name = 'Free list stalls/sec'
UNION ALL
SELECT  'Checkpoint pages/sec',
        cntr_value 
FROM    #perfmon_counters 
WHERE   object_name=@Instancename+'Buffer Manager' 
        and counter_name = 'Checkpoint pages/sec'
UNION ALL
SELECT  'Lazy writes/sec',
        cntr_value 
FROM    #perfmon_counters 
WHERE   object_name=@Instancename+'Buffer Manager' 
        and counter_name = 'Lazy writes/sec'
UNION ALL
SELECT  'Memory Grants Pending',
        cntr_value 
FROM    #perfmon_counters 
WHERE   object_name=@Instancename+'Memory Manager' 
        and counter_name = 'Memory Grants Pending'
UNION ALL
SELECT  'Memory Grants Outstanding',
        cntr_value 
FROM    #perfmon_counters 
WHERE   object_name=@Instancename+'Memory Manager' 
        and counter_name = 'Memory Grants Outstanding'
UNION ALL
SELECT  'process_physical_memory_low',
        process_physical_memory_low 
FROM    sys.dm_os_process_memory WITH (NOLOCK)
UNION ALL
SELECT  'process_virtual_memory_low',
        process_virtual_memory_low 
FROM    sys.dm_os_process_memory WITH (NOLOCK)
UNION ALL
SELECT  'Max_Server_Memory (MB)' ,
        [value_in_use] 
FROM    sys.configurations 
WHERE   [name] = 'max server memory (MB)'
UNION ALL
SELECT  'Min_Server_Memory (MB)' ,
        [value_in_use] 
FROM    sys.configurations 
WHERE   [name] = 'min server memory (MB)'
UNION ALL
SELECT  'BufferCacheHitRatio',
        (a.cntr_value * 1.0 / b.cntr_value) * 100.0 
FROM    sys.dm_os_performance_counters a
        JOIN (SELECT cntr_value,OBJECT_NAME FROM sys.dm_os_performance_counters
              WHERE counter_name = 'Buffer cache hit ratio base' AND 
                    OBJECT_NAME = @Instancename+'Buffer Manager') b ON 
                    a.OBJECT_NAME = b.OBJECT_NAME WHERE a.counter_name = 'Buffer cache hit ratio' 
                    AND a.OBJECT_NAME = @Instancename+'Buffer Manager'

) AS D;