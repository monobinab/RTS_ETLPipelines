#! /bin/bash
cd /appl/rts/etl_audit/jboss_logs
sql_dir=/appl/rts/etl_audit/jboss_logs
sql_file=attach.sql
yesterday=$(date '+%-d' -d "1 day ago")

current_month=`date +%-m`
current_year=`date +%Y`

hive -hiveconf yesterday=${yesterday} -hiveconf current_year=${current_year} -hiveconf current_month=${current_month} -f ${sql_dir}/${sql_file}
