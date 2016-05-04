#! /bin/bash
/appl/rts/etl_audit/occasions_logs/get_yesterday_count.sh > /logs/rts/occasions_get_yesterday_count.log 2>&1
python /appl/rts/etl_audit/occasions_logs/validate_count.py > /logs/rts/occasions_validate_count.log 2>&1

exit 0
