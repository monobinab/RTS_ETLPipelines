#! /bin/bash
cd /appl/rts/etl_audit/occasions_logs
sql_dir=/appl/rts/etl_audit/occasions_logs
sql_file=get_yesterday_count.sql
yesterday=`date +%-d -d "1 day ago"`

current_month=`date +%-m -d "1 day ago"`
current_year=`date +%Y -d "1 day ago"`

hive -hiveconf yesterday=${yesterday} -hiveconf current_year=${current_year} -hiveconf current_month=${current_month} -f ${sql_dir}/${sql_file}
