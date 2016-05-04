#! /bin/bash
cd /home/auto/msaha/rts/api/final;
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp
#current_month=Mar
current_month=`date +%b`
current_year=`date +%Y`

#run directory
run_directory=/home/auto/msaha/rts/api

#generate input directory path
input_parentdir=/incoming/rts/flume
input_directory=${input_parentdir}/$current_month/$current_year

#generate output directory path
out_parentdir=/smith/rts
out_directory=${out_parentdir}/$current_month/$current_year

#clear current directory
hadoop fs -rm -r -skipTrash ${out_parentdir}/$current_month/$current_year

#exeucte map only streaming
hadoop jar /opt/cloudera/parcels/CDH-5.1.2-1.cdh5.1.2.p470.103/lib/hadoop-mapreduce/hadoop-streaming-2.3.0-cdh5.1.2.jar \
-reducer NONE \
-file ./ResponseMapper_increm.py  -mapper ./ResponseMapper_increm.py \
-input ${input_directory}/jboss-.*[0-9] \
-output ${out_directory}

