#! /bin/bash
cd /appl/rts/jboss_logs/api_error;
#current_month=Feb
current_month=`date +%m -d "1 day ago"`
current_year=`date +%Y -d "1 day ago"`
current_day=`date +%d -d "1 day ago"`

input_parentdir=/smith/rts
#input_parentdir=/tmp/api_error
sql_dir=/appl/rts/jboss_logs/api_error
sql_file=error_load_step_2.sql

input_directory=${input_parentdir}/jboss_logs/api_error/stream_logs

echo "data directory is : " ${input_directory}
#export ${input_directory}

hadoop fs -rm -r -skipTrash /user/hive/warehouse/real_time_scoring.db/rts_api_error_log_staging

hive -hiveconf input_directory=${input_directory} -f ${sql_dir}/${sql_file} 
ret_code=$?
case ${ret_code} in
     0) printf "\nAPI Error staging table load job successful \n" >> /logs/rts/api_error_step2.log;;
     *) printf "\nAPI Error staging table load job job failed\n" >> /logs/rts/api_error_step2.log
     printf "\nAPI Error staging table load job failed with Return Code=${ret_code}\n"| mailx -s "API Error staging table load job Failed" -a /logs/rts/api_error_step2.log rtsteam$searshc.com
     exit 1 ;;
esac
exit 0

