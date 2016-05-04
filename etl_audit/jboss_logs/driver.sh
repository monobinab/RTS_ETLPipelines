#! /bin/bash
/appl/rts/etl_audit/jboss_logs/get_count_by_client.sh > /logs/rts/jboos_api_response_get_count.log 2>&1
python /appl/rts/etl_audit/jboss_logs/validate_count.py > /logs/rts/jboss_api_response_validate_count.log 2>&1

exit 0
