#! /bin/bash
cd /appl/rts/storm_logs

sql_dir=/appl/rts/storm_logs
sql_file=insert_storm_log_partition.sql


hive -f ${sql_dir}/${sql_file}
ret_code=$?
case ${ret_code} in
     0) printf "\nStorm table insert job successful \n" >> /logs/rts/insert_storm_log_partition.log;;
     *) printf "\nStorm table insert failed\n" >> /logs/rts/insert_storm_log_partition.log
     printf "\nStorm table insert job failed with Return Code=${ret_code}\n"| mailx -s "Storm table insert Failed" -a /logs/rts/insert_storm_log_partition.log rtsteam@searshc.com
     exit 1 ;;
esac
