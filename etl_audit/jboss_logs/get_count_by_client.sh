#! /bin/bash
cd /home/auto/msaha/rts/api/final/audit
sql_dir=/home/auto/msaha/rts/api/final/audit
sql_file=get_count_by_client.sql
yesterday=$(date '+%-d' -d "1 day ago")

current_month=`date +%-m`
current_year=`date +%Y`

hive -hiveconf yesterday=${yesterday} -hiveconf current_year=${current_year} -hiveconf current_month=${current_month} -f ${sql_dir}/${sql_file}
