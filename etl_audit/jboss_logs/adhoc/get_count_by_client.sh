#! /bin/bash
cd /appl/rts/etl_audit/jboss_logs/adhoc 
sql_dir=/appl/rts/etl_audit/jboss_logs/adhoc
sql_file=get_count_by_client.sql
yesterday=$(date '+%-d' -d "1 day ago")

current_month=`date +%-m`
current_year=`date +%Y`

hive -f ${sql_dir}/${sql_file}
