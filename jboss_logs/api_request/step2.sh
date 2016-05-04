#! /bin/bash
cd /appl/rts/jboss_logs/api_request;
current_month=`date +%b`
current_year=`date +%Y`

#input_parentdir=/smith/rts/api_reuest
#input_parentdir=/tmp
sql_dir=/appl/rts/jboss_logs/api_request
sql_file=step2.sql

input_directory=/smith/rts/api_request/stream_logs

echo "data directory is : " ${input_directory}
#export ${input_directory}
hadoop fs -rm -r -skipTrash /user/hive/warehouse/real_time_scoring.db/api_request_log_staging/part*
hive -hiveconf input_directory=${input_directory} -f ${sql_dir}/${sql_file} 
ret_code=$?
case ${ret_code} in
     0) printf "\nAPI Request Staging table load job successful \n" >> /logs/rts/api_request_step2.log ;;
     *) printf "\nAPI Request staging table load job job failed\n" >> /logs/rts/api_request_step2.log
     printf "\nAPI request staging table load job failed with Return Code=${ret_code}\n"| mailx -s "API Request staging table load job Failed" -a /logs/rts/api_request_step2.log rtsteam@searshc.com
     exit 1 ;;
esac
exit 0

