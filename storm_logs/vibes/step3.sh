#! /bin/bash

cd /appl/rts/storm_logs/vibes;
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp
current_day=`date +%-d`
yesterday=$(date '+%-d' -d "1 day ago")

current_month=`date +%-m`
current_year=`date +%Y`
load_date=`date +%Y-%m-%-d`
user_created=`whoami`

sql_dir=/appl/rts/storm_logs/vibes
sql_file=step3.sql


hive -hiveconf load_date=${load_date} -hiveconf user_created=${user_created} -f ${sql_dir}/${sql_file} 
ret_code=$?
case ${ret_code} in
     0) printf "\nVibes table insert job successful \n" >> /logs/rts/load_api.log;;
     *) printf "\nVibes table insert failed\n" >> /logs/rts/load_api.log
     printf "\nVibes table insert job failed with Return Code=${ret_code}\n"| mailx -s "rts_vibes_log table insert Failed" -a /logs/rts/vibes_step3.log msaha@searshc.com
     exit 1 ;;
esac

