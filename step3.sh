#! /bin/bash

cd /home/auto/msaha/rts/api/final;
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp
current_day=`date +%d`
yesterday=$(date '+%d' -d "1 day ago")
current_month=`date +%m`
current_year=`date +%Y`

sql_dir=/home/auto/msaha/rts/api/final
sql_file=step3.sql


hive -hiveconf current_year=${current_year} current_month=${current_month} current_day=${current_day} yesterday=${yesterday} -f ${sql_dir}/${sql_file}
