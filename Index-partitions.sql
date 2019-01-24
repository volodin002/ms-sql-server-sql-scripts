select s.Name as SchemaName, o.name as TableName, i.name, p.partition_number

from sys.partitions as p
                inner join sys.objects as o on p.object_id = o.object_id
                inner join sys.indexes as i on i.index_id = p.index_id
				join sys.schemas s on s.schema_id = o.schema_id 
where i.name = 'IX_RowId'
order by o.name, i.name, p.partition_number

/*
select partition_id, partition_number, rows, p.index_id, i.name IndexName
  from sys.partitions p
  inner join sys.indexes as i on i.index_id = p.index_id and i.object_id = p.object_id
  where p.object_id = 
  --object_id ( N'[Publication].[Queue]', N'U' );
  object_id ( N'[InstrumentsTechnical].[Audit]', N'U' );
*/
  --57663892
 --105352952