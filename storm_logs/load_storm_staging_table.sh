#! /bin/bash
cd /appl/rts
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp

input_directory=/smith/rts/storm_logs
sql_dir=/appl/rts/storm_logs
sql_file=load_storm_staging.sql

hadoop fs -rm -r -skipTrash /user/hive/warehouse/real_time_scoring.db/rts_storm_log_staging/part*

echo "data directory is : " ${input_directory}
#export ${input_directory}

hive -hiveconf input_directory=${input_directory} -f ${sql_dir}/${sql_file}

ret_code=$?
case ${ret_code} in
     0) printf "\nStorm logs staging table create job successful load_storm_staging_table.sh\n" >> /logs/rts/load_storm_staging_table.log;;
     *) printf "\nStorm logs staging table create job failed load_storm_staging_table.sh\n" >> /logs/rts/load_storm_staging_table.log
     printf "\nRTS Storm logs staging table create job failed load_storm_staging_table.sh\n with Return Code=${ret_code}"| mailx -s "Storm Log staging table create job Failed" -a /logs/rts/load_storm_staging_table.log rtsteam$searshc.com
     exit 1 ;;
esac
