#! /bin/bash
#generate output directory path
out_directory=/tmp/api_response_0209_streamlogs


#generate input directory path
input_directory=/incoming/rts/flume/jboss/2016/02/09

#clear current directory
hadoop fs -rm -r -skipTrash ${out_directory}

#exeucte map only streaming
hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
-D mapred.input.compress=true \
-D mapred.input.compression.codec=com.hadoop.compression.gz.GzipCodec \
-D mapred.output.compress=true \
-D mapred.output.compression.codec=com.hadoop.compression.lzo.LzopCodec \
-D mapred.reduce.tasks=10 \
-file /appl/rts/jboss_logs/api_response/ResponseMapper_daily.py  -mapper /appl/rts/jboss_logs/api_response/ResponseMapper_daily.py \
-input ${input_directory}/jboss-.*[0-9].gz \
-output ${out_directory} 


hadoop jar /opt/cloudera/parcels/GPLEXTRAS/lib/hadoop/lib/hadoop-lzo.jar com.hadoop.compression.lzo.DistributedLzoIndexer ${out_directory}

