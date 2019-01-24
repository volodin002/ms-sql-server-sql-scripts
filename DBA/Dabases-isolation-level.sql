SELECT 
	--snapshot_isolation_state_desc, 
	snapshot_isolation_state, 
	is_read_committed_snapshot_on, 
	*
from sys.databases 