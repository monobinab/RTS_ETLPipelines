#! /bin/bash

cd /appl/rts/jboss_logs/api_request;
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp
current_day=`date +%-d`
yesterday=$(date '+%-d' -d "1 day ago")

current_month=`date +%-m`
current_year=`date +%Y`
load_date=`date +%Y-%-m-%-d`

sql_dir=/appl/rts/jboss_logs/api_request
sql_file=step3.sql


hive -hiveconf load_date=${load_date} -f ${sql_dir}/${sql_file} 
ret_code=$?
case ${ret_code} in
     0) printf "\nAPI api_request_log table insert job successful \n" >> /logs/rts/api_request_step3.log;;
     *) printf "\nAPI api_request_log table insert failed\n" >> /logs/rts/api_request_step3.log
     printf "\nAPI api_request_log table insert job failed with Return Code=${ret_code}\n"| mailx -s "api_request_log table insert Failed" -a /logs/rts/api_request_step3.log rtsteam@searshc.com
     exit 1 ;;
esac

