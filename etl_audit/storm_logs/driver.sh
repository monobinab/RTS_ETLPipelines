#! /bin/bash
/appl/rts/etl_audit/storm_logs/get_yesterday_count.sh > /logs/rts/storm_get_yesterday_count.log 2>&1
python /appl/rts/etl_audit/storm_logs/validate_count.py > /logs/rts/storm_validate_count.log 2>&1

exit 0
