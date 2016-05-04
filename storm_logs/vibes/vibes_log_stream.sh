#! /bin/bash
cd /appl/rts/storm_logs/vibes
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp
#current_month=Jan
current_day=`date +%d -d "1 day ago"`
current_month=`date +%m -d "1 day ago"`
current_year=`date +%Y -d "1 day ago"`

run_directory=/appl/rts/storm_logs/vibes
input_directory=/incoming/rts/flume/storm/${current_year}/${current_month}/${current_day}
out_directory=/smith/rts/storm_logs/vibes


hadoop fs -rm -r -skipTrash ${out_directory}
#hadoop fs -rm -r -skipTrash ${out_parentdir}/Jan/2015
echo "removed out directory" 

hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
-D mapred.input.compress=true \
-D mapred.input.compression.codec=com.hadoop.compression.gz.GzipCodec \
-D mapred.output.compress=true \
-D mapred.output.compression.codec=com.hadoop.compression.lzo.LzopCodec \
-reducer NONE \
-file /appl/rts/storm_logs/vibes/vibes_records_parser_from_stdin.py -mapper /appl/rts/storm_logs/vibes/vibes_records_parser_from_stdin.py \
-input ${input_directory}/storm*[0-9].gz \
-output ${out_directory}
