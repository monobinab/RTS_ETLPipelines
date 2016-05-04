#! /bin/bash
cd /appl/rts/jboss_logs/api_response;
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp
#current_month=May
current_month=11
current_day=07
current_year=2015

#generate output directory path
out_directory=/smith/rts/jboss_logs/stream_logs


#generate input directory path
input_parent_directory=/incoming/rts/flume/jboss
input_directory=${input_parent_directory}/${current_year}/${current_month}/${current_day}

#clear current directory
hadoop fs -rm -r -skipTrash ${out_directory}

#exeucte map only streaming
hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
-D mapred.input.compress=true \
-D mapred.input.compression.codec=com.hadoop.compression.gz.GzipCodec \
-D mapred.output.compress=true \
-D mapred.output.compression.codec=com.hadoop.compression.lzo.LzopCodec \
-reducer NONE \
-file /appl/rts/jboss_logs/api_response/ResponseMapper_daily.py  -mapper /appl/rts/jboss_logs/api_response/ResponseMapper_daily.py \
-input ${input_directory}/jboss-.*[0-9].gz \
-output ${out_directory} 

ret_code=$?
case ${ret_code} in
     0) printf "\nAPI api_response_log table streaming job successful \n" >> /logs/rts/api_response_step1.log;;
     *) printf "\nAPI streaming job failed\n" >> /logs/rts/api_response_step1.log
     echo "\nAPI streaming job failed with Return Code=${ret_code}\n"| mailx -s "API streaming job Failed" -a /logs/rts/api_response_step1.log msaha@searshc.com
     exit 1 ;;
esac

hadoop jar /opt/cloudera/parcels/GPLEXTRAS/lib/hadoop/lib/hadoop-lzo.jar com.hadoop.compression.lzo.DistributedLzoIndexer ${out_directory}

ret_code=$?
case ${ret_code} in
     0) printf "\nAPI api_response_log table streaming job compression files successful \n" >> /logs/rts/api_response_step1.log;;
     *) printf "\nAPI streaming job compression files failed\n" > /logs/rts/api_response_step1.log
     echo "\nAPI streaming job failed with Return Code=${ret_code}\n"| mailx -s "API streaming job compression files Failed" -a /logs/rts/api_response_step1.log msaha@searshc.com
     exit 1 ;;
esac
