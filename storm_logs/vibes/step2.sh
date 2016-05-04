#! /bin/bash
cd /appl/rts/storm_logs/vibes;

input_directory=/smith/rts/storm_logs/vibes
#input_parentdir=/tmp
sql_dir=/appl/rts/storm_logs/vibes
sql_file=step2.sql


echo "data directory is : " ${input_directory}
#export ${input_directory}
hadoop fs -rm -r -skipTrash /user/hive/warehouse/real_time_scoring.db/rts_vibes_log_staging/part*
hive -hiveconf input_directory=${input_directory} -f ${sql_dir}/${sql_file} 
ret_code=$?
case ${ret_code} in
     0) printf "\nAPI Staging table load job successful \n" >> /logs/rts/vibes_step2.log ;;
     *) printf "\nAPI staging table load job job failed\n" >> /logs/rts/vibes_step2.log
     printf "\nAPI staging table load job failed with Return Code=${ret_code}\n"| mailx -s "API staging table load job Failed" -a /logs/rts/vibes_step2.log msaha@searshc.com
     exit 1 ;;
esac
exit 0

