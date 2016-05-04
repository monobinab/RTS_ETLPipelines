#! /bin/bash

cd /appl/rts/jboss_logs/api_error;
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp

current_month=`date +%-m`
current_year=`date +%Y`

sql_dir=/appl/rts/jboss_logs/api_error
sql_file=error_load_step3.sql


hive -hiveconf current_year=${current_year} -hiveconf current_month=${current_month} -f ${sql_dir}/${sql_file} 
ret_code=$?
case ${ret_code} in
     0) printf "\nAPI error table insert job successful \n" >> /logs/rts/api_error_step3.log ;;
     *) printf "\nAPI error table insert failed\n" >> /logs/rts/api_error_step3.log
     printf "\nAPI error table insert job failed with Return Code=${ret_code}\n"| mailx -s "api error table insert Failed" -a /logs/rts/api_error_step3.log rtsteam$searshc.com
     exit 1 ;;
esac

