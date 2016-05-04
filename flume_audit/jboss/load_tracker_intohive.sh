#! /bin/bash
cd /appl/rts/flume_audit;

#input_parentdir=/smith/rts/pig
input_directory=/staging/
sql_dir=/appl/rts/occasions_logs
sql_file=step2.sql


echo "data directory is : " ${input_directory}
#export ${input_directory}
#hadoop fs -rm -r -skipTrash /user/hive/warehouse/real_time_scoring.db/rts_api_response_log_staging/part*
hive -hiveconf input_directory=${input_directory} -f ${sql_dir}/${sql_file}
ret_code=$?
case ${ret_code} in
     0) printf "\noccasions staging table load job successful \n" >> /home/auto/msaha/rts/api/final/logs/load_api.log;;
     *) printf "\noccasions staging table load job job failed\n" >> /home/auto/msaha/rts/api/final/logs/load_api.log
     printf "\noccasions staging table load job failed with Return Code=${ret_code}\n"| mailx -s "Occasions staging table load job Failed" -a /logs/rts/occasions_step2.log rtsteam@searshc.com
     exit 1 ;;
esac
exit 0
