#! /bin/bash
/appl/rts/etl_audit/reports/ti/get_count_by_client.sh > /logs/rts/teradata_ti_response_get_count.log 2>&1
python /appl/rts/etl_audit/reports/ti/validate_count.py > /logs/rts/teradata_ti_validate_count.log 2>&1

exit 0
