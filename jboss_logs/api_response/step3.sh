#! /bin/bash

cd /appl/rts/jboss_logs/api_response;
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp
current_day=`date +%-d`
yesterday=$(date '+%-d' -d "1 day ago")


current_month=`date +%-m`
current_year=`date +%Y`
load_date=`date +%Y-%m-%-d`

sql_dir=/appl/rts/jboss_logs/api_response
sql_file=insert_into_prod_tbl.sql
out_directory=/user/hive/warehouse/real_time_scoring.db/api_response_log/year=${current_year}/month=${current_month}/day=${yesterday}

hive -hiveconf load_date=${load_date} -f ${sql_dir}/${sql_file} 
ret_code=$?
case ${ret_code} in
     0) printf "\nAPI api_response_log table insert job successful \n" >> /logs/rts/api_response_step3.log;;
     *) printf "\nAPI api_response_log table insert failed\n" >> /logs/rts/api_response_step3.log
     printf "\nAPI Response table insert job failed with Return Code=${ret_code}\n"| mailx -s "API response log table insert Failed" -a /logs/rts/api_response_step3.log rtsteam@searshc.com
     exit 1 ;;
esac

hadoop jar /opt/cloudera/parcels/GPLEXTRAS/lib/hadoop/lib/hadoop-lzo.jar com.hadoop.compression.lzo.DistributedLzoIndexer ${out_directory}
ret_code=$?
case ${ret_code} in
     0) printf "\nAPI Staging deduped table indexing job successful \n" >> /logs/rts/api_response_step3.log ;;
     *) printf "\nAPI staging table deduped job job failed\n" >> /logs/rts/api_response_step3.log
     printf "\nAPI Response staging table deduped job failed with Return Code=${ret_code}\n"| mailx -s "API Response staging table deduped job Failed" -a /logs/rts/api_response_step3.log rtsteam@searshc.com
     exit 1 ;;
esac

exit 0;
