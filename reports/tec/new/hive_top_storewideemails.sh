#! /bin/bash
cd /appl/rts
current_timestamp=`date +%Y-%m-%d'  '%H':'%M':'%S`
echo $current_timestamp

current_day=`date +%-d`
today=1
start_date=$(date '+%Y-%m-%d' -d "7 day ago")


sql_dir=/appl/rts/reports/tec/contact_history/new
sql_file_1=hive_top_storewideemails_1.sql

hadoop fs -rm -r -skipTrash /user/hive/warehouse/real_time_scoring.db/api_response_log_tec_staging

hive -hiveconf start_date=${start_date} -f ${sql_dir}/${sql_file_1} > /logs/rts/tec_contact_history_storewideemails.log

ret_code=$?
case ${ret_code} in
     0) printf "\nhive_topreco_storewideemails table create job successful \n" >> /logs/rts/load_contact_history_storewideemails.log;;
     *) printf "\nhive_topreco_storewideemails table create job failed \n" >> /logs/rts/load_contact_history_storewideemails.log
     printf "\nhive_topreco_storewideemails.sql table create job in hive failed\n with Return Code=${ret_code}"| mailx -s "hive_top_storewideemails.sql table create job Failed" -a /logs/rts/load_contact_history_storewideemails.log msaha$searshc.com
     exit 1 ;;
esac

