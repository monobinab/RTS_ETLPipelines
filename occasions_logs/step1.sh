#! /bin/bash
cd /appl/rts/occasions_logs;
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp
#current_month=May
current_day=$(date +%d -d "1 day ago")
current_month=$(date +%m -d "1 day ago")
current_year=$(date +%Y -d "1 day ago")

#generate output directory path
out_directory=/smith/rts/occasions_logs

#generate input directory path
input_directory=/incoming/rts/flume/storm/${current_year}/${current_month}/${current_day}
#clear current directory
hadoop fs -rm -r -skipTrash ${out_directory}

#exeucte map only streaming
hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
-D mapred.input.compress=true \
-D mapred.input.compression.codec=com.hadoop.compression.gz.GzipCodec \
-D mapred.output.compress=true \
-D mapred.output.compression.codec=com.hadoop.compression.lzo.LzopCodec \
-D mapred.reduce.tasks=2 \
-file /appl/rts/occasions_logs/occasion_logs_parser_daily.py  -mapper /appl/rts/occasions_logs/occasion_logs_parser_daily.py \
-input ${input_directory}/storm-.*[0-9].* \
-output ${out_directory} 

ret_code=$?
case ${ret_code} in
     0) printf "\noccasions streaming job successful \n" >> /logs/rts/occasions_step1.log ;;
     *) printf "\noccasions streaming job failed\n" >> /logs/rts/occasions_step1.log
     echo "\noccasions streaming job failed with Return Code=${ret_code}\n"| mailx -s "Occasions streaming job Failed"  rtsteam@searshc.com
     exit 1 ;;
esac

hadoop jar /opt/cloudera/parcels/GPLEXTRAS/lib/hadoop/lib/hadoop-lzo.jar com.hadoop.compression.lzo.DistributedLzoIndexer ${out_directory}

ret_code=$?
case ${ret_code} in
     0) printf "\noccasions lzo compression successful \n" >> /logs/rts/occasions_step1.log ;;
     *) printf "\noccasions lzo compression job failed\n" >> /logs/rts/occasions_step1.log
     echo "\noccasions lzo compression job failed with Return Code=${ret_code}\n"| mailx -s "Occasions lzo compression job Failed"  rtsteam@searshc.com
     exit 1 ;;
esac
