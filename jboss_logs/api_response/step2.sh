#! /bin/bash
cd /appl/rts/jboss_logs/api_response;

input_parentdir=/smith/rts/jboss_logs
#input_parentdir=/tmp
sql_dir=/appl/rts/jboss_logs/api_response
sql_file1=load_into_staging1_tbl.sql
sql_file2=insert_into_staging2_tbl.sql
out_directory_1=/user/hive/warehouse/real_time_scoring.db/rts_api_response_log_staging
out_directory_2=/user/hive/warehouse/real_time_scoring.db/rts_api_response_log_staging_deduped

input_directory=${input_parentdir}/api_response_log

echo "data directory is : " ${input_directory}
#export ${input_directory}
hadoop fs -rm -r -skipTrash /user/hive/warehouse/real_time_scoring.db/rts_api_response_log_staging
hadoop fs -rm -r -skipTrash /user/hive/warehouse/real_time_scoring.db/rts_api_response_log_staging_deduped

hive -hiveconf input_directory=${input_directory}  -f ${sql_dir}/${sql_file1} 
ret_code=$?
case ${ret_code} in
     0) printf "\nAPI Staging table load job successful \n" >> /logs/rts/api_response_step2.log ;;
     *) printf "\nAPI staging table load job job failed\n" >> /logs/rts/api_response_step2.log
     printf "\nAPI Response staging table load job failed with Return Code=${ret_code}\n"| mailx -s "API Response staging table load job Failed" -a /logs/rts/api_response_step2.log msaha@searshc.com
     exit 1 ;;
esac

hadoop jar /opt/cloudera/parcels/GPLEXTRAS/lib/hadoop/lib/hadoop-lzo.jar com.hadoop.compression.lzo.DistributedLzoIndexer ${out_directory_1}
ret_code=$?
case ${ret_code} in
     0) printf "\nAPI Staging table1 indexing job successful \n" >> /logs/rts/api_response_step2.log ;;
     *) printf "\nAPI staging table1 deduped job job failed\n" >> /logs/rts/api_response_step2.log
     printf "\nAPI Response staging table1  job failed with Return Code=${ret_code}\n"| mailx -s "API Response staging table1 job Failed" -a /logs/rts/api_response_step2.log msaha@searshc.com
     exit 1 ;;
esac

hive -hiveconf input_directory=${input_directory}  -f ${sql_dir}/${sql_file2}
ret_code=$?
case ${ret_code} in
     0) printf "\nAPI Staging table2 insert job successful \n" >> /logs/rts/api_response_step2.log ;;
     *) printf "\nAPI staging table2 insert job job failed\n" >> /logs/rts/api_response_step2.log
     printf "\nAPI Response staging table2 insert job failed with Return Code=${ret_code}\n"| mailx -s "API Response staging table2 insert job Failed" -a /logs/rts/api_response_step2.log msaha@searshc.com
     exit 1 ;;
esac

hadoop jar /opt/cloudera/parcels/GPLEXTRAS/lib/hadoop/lib/hadoop-lzo.jar com.hadoop.compression.lzo.DistributedLzoIndexer ${out_directory_2}
ret_code=$?
case ${ret_code} in
     0) printf "\nAPI Staging deduped table indexing job successful \n" >> /logs/rts/api_response_step2.log ;;
     *) printf "\nAPI staging table deduped job job failed\n" >> /logs/rts/api_response_step2.log
     printf "\nAPI Response staging table deduped job failed with Return Code=${ret_code}\n"| mailx -s "API Response staging table deduped job Failed" -a /logs/rts/api_response_step2.log msaha@searshc.com
     exit 1 ;;
esac
exit 0

