#! /bin/bash
cd /appl/rts/storm_logs
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp
#current_month=May
current_day=`date +%d -d "1 day ago"`
current_month=`date -d "1 day ago" +%m`
current_year=`date +%Y -d "1 day ago"`

run_directory=/appl/rts/storm_logs
input_parent_directory=/incoming/rts/flume/storm
input_directory=${input_parent_directory}/${current_year}/${current_month}/${current_day}
echo "input directory is : ${input_directory}"

out_directory=/smith/rts/storm_logs


hadoop fs -rm -r -skipTrash ${out_directory}
echo "removed out directory" 

hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
-D mapred.input.compress=true \
-D mapred.input.compression.codec=com.hadoop.compression.gz.GzipCodec \
-reducer NONE \
-file /appl/rts/storm_logs/storm_logs_parser_daily.py -mapper /appl/rts/storm_logs/storm_logs_parser_daily.py \
-input ${input_directory}/storm-.*[0-9].gz \
-output ${out_directory}

ret_code=$?
case ${ret_code} in
     0) printf "\nStorm api_storm_log table streaming job successful \n" >> /logs/rts/storm_log_stream.log;;
     *) printf "\nStorm streaming job failed\n" > /logs/rts/storm_log_stream.log
     echo "\nStorm streaming job failed with Return Code=${ret_code}\n"| mailx -s "Storm streaming job Failed"  msaha@searshc.com
     exit 1 ;;
esac
