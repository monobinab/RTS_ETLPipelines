#! /bin/bash
cd /appl/rts/jboss_logs/api_request;
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp
#current_month=May
current_month=`date +%m -d "1 day ago"`
current_year=`date +%Y -d "1 day ago"`
current_day=`date +%d -d "1 day ago"`

#generate output directory path
#input_parentdir=/tmp/api
out_directory=/smith/rts/api_request/stream_logs


#generate input directory path
input_directory=/incoming/rts/flume/jboss/${current_year}/${current_month}/${current_day}
#input_directory=/tmp/adhoc_api

#clear current directory
hadoop fs -rm -r -skipTrash ${out_directory}

#exeucte map only streaming
hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
-D mapred.input.compress=true \
-D mapred.input.compression.codec=com.hadoop.compression.gz.GzipCodec \
-D mapred.output.compress=true \
-D mapred.output.compression.codec=com.hadoop.compression.lzo.LzopCodec \
-D mapred.reduce.tasks=2 \
-file /appl/rts/jboss_logs/api_request/RtsLogApiRequestMapper.py  -mapper /appl/rts/jboss_logs/api_request/RtsLogApiRequestMapper.py \
-input ${input_directory}/jboss-.*[0-9].gz \
-output ${out_directory} 


hadoop jar /opt/cloudera/parcels/GPLEXTRAS/lib/hadoop/lib/hadoop-lzo.jar com.hadoop.compression.lzo.DistributedLzoIndexer ${out_directory}

ret_code=$?
case ${ret_code} in
     0) printf "\nAPI api_request_log table streaming job successful \n" >> /logs/rts/api_request_step1.log;;
     *) printf "\nAPI Request streaming job failed\n" > /logs/rts/api_request_step1..log
     echo "\nAPI Request streaming job failed with Return Code=${ret_code}\n"| mailx -s "API Request streaming job Failed"  -a /logs/rts/api_request_step1.log rtsteam@searshc.com
     exit 1 ;;
esac
