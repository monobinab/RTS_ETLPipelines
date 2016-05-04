#! /bin/bash
cd /appl/rts/jboss_logs/api_error;
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp
#current_month=Jan
current_month=`date +%m -d "1 day ago"`
current_year=`date +%Y -d "1 day ago"`
current_day=`date +%d -d "1 day ago"`

#run directory
run_directory=/appl/rts/jboss_logs/api_error

#generate input directory path
input_parentdir=/incoming/rts/flume/jboss
input_directory=${input_parentdir}/$current_year/${current_month}/${current_day}

#generate output directory path
#out_parentdir=/tmp/api_error
out_parentdir=/smith/rts
out_directory=${out_parentdir}/jboss_logs/api_error/stream_logs

#clear current directory
hadoop fs -rm -r -skipTrash ${out_directory}

#exeucte map only streaming
hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
-D mapred.input.compress=true \
-D mapred.input.compression.codec=com.hadoop.compression.gz.GzipCodec \
-D mapred.output.compress=true \
-D mapred.output.compression.codec=com.hadoop.compression.lzo.LzopCodec \
-D mapred.reduce.tasks=1 \
-file /appl/rts/jboss_logs/api_error/RtsLogApiCallErrorMapper.py  -mapper /appl/rts/jboss_logs/api_error/RtsLogApiCallErrorMapper.py \
-input ${input_directory}/jboss-.*[0-9].gz \
-output ${out_directory}

hadoop jar /opt/cloudera/parcels/GPLEXTRAS/lib/hadoop/lib/hadoop-lzo.jar com.hadoop.compression.lzo.DistributedLzoIndexer ${out_directory}

ret_code=$?
case ${ret_code} in
     0) printf "\nAPI Error streaming job successful \n" >> /logs/rts/api_error_step1.log ;;
     *) printf "\nAPI Error streaming job failed\n" >> /logs/rts/api_error_step1.log
     echo "\nAPI Error streaming job failed with Return Code=${ret_code}\n"| mailx -s "API Error streaming job Failed" -a /logs/rts/api_error_step1.log rtsteam$searshc.com
     exit 1 ;;
esac
