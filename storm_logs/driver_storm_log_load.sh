#! /bin/bash
/appl/rts/storm_logs/storm_log_stream.sh > /logs/rts/storm_log_stream.log 2>&1

ret_code=$?
case ${ret_code} in
     0) printf "\nstreaming job successful storm_log_stream.sh\n" >> /logs/rts/process_flow_status.log;;
     *) printf "\nstreaming job Failed storm_log_stream.sh\n" >> /logs/rts/process_flow_status.log
     printf "\nRTS Storm Logs streaming job Failed storm_log_stream.sh\n with Return Code=${ret_code}"| mailx -s "Storm Log streaming job Failed" -a /logs/rts/storm_log_stream.log msaha$searshc.com
     exit 1 ;;
esac

/appl/rts/storm_logs/load_storm_staging_table.sh > /logs/rts/load_storm_staging_table.log 2>&1

ret_code=$?
case ${ret_code} in
     0) printf "\nStorm logs staging table create job successful load_storm_staging_table.sh\n" >> /logs/rts/load_storm_staging_table.log;;
     *) printf "\nStorm logs staging table create job failed load_storm_staging_table.sh\n" >> /logs/rts/load_storm_staging_table.log
     printf "\nRTS Storm logs staging table create job failed load_storm_staging_table.sh\n with Return Code=${ret_code}"| mailx -s "Storm Log staging table create job Failed" -a /logs/rts/load_rts_api.log msaha$searshc.com
     exit 1 ;;
esac

/appl/rts/storm_logs/insert_storm_log_partition.sh > /logs/rts/insert_storm_log_partition.log 2>&1

ret_code=$?
printf "\nStatus of Create log Table job=$ret_code\n" >> /logs/rts/insert_storm_log_partition.log
case ${ret_code} in
     0) printf "\nStatus of Create log Table job successful insert_storm_log_partition.sh\n" >> /logs/rts/insert_storm_log_partition.log;;
     *) printf "\nStatus of Create log Table failed insert_storm_log_partition.sh\n" >> /logs/rts/insert_storm_log_partition.log
     printf "\nRTS Storm Logs Create log Table failed insert_storm_log_partition.sh\n with Return Code=${ret_code}"| mailx -s "RTS Storm Logs Create log Table failed insert_storm_log_partition.sh" -a /logs/rts/insert_storm_log_partition.log msaha$searshc.com
     exit 1 ;;
esac

impala-shell -f /appl/rts/storm_logs/refresh_storm_log_table.sql > /logs/rts/refresh_storm_log_table.log 2>&1

ret_code=$?
printf "\nStatus of Refresh Storm log Table job=$ret_code\n" >> /logs/rts/refresh_storm_log_table.log
case ${ret_code} in
     0) printf "\nStatus of Refresh Storm log Table job successful insert_storm_log_partition.sh\n" >> /logs/rts/insert_storm_log_partition.log;;
     *) printf "\nStatus of Refresh Storm log Table failed insert_storm_log_partition.sh\n" >> /logs/rts/insert_storm_log_partition.log
     printf "\nRefresh Storm log Table failed\n with Return Code=${ret_code}"| mailx -s "Refresh Storm log Table failed" -a /logs/rts/refresh_storm_log_table.log msaha$searshc.com
     exit 1 ;;
esac

~
