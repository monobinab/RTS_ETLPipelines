
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp
current_month=`date +%b`
current_year=`date +%Y`

run_directory=/home/auto/msaha/rts/api
input_parentdir=/incoming/rts/flume
input_directory=${input_parentdir}/$current_month/$current_year

out_parentdir=/smith/rts

out_directory=${out_parentdir}/$current_month/$current_year

hadoop fs -rm -r -skipTrash ${out_parentdir}/$current_month/$current_year


hadoop jar /opt/cloudera/parcels/CDH-5.1.2-1.cdh5.1.2.p470.103/lib/hadoop-mapreduce/hadoop-streaming-2.3.0-cdh5.1.2.jar \
-files ./RtsLogApiResponseMapper_newformat.py  -mapper ./RtsLogApiResponseMapper_newformat.py \
-reducer org.apache.hadoop.mapred.lib.IdentityReducer \
-input ${input_directory}/jboss-.*[0-9] \
-output ${out_directory}

