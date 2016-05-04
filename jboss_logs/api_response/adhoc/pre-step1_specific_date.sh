#! /bin/bash
cd /home/auto/msaha/rts/api/final;
current_date=`date +%Y-%m-%d`
echo $current_date


#generate input directory path
input_parentdir=/incoming/rts/flume
input_directory=${input_parentdir}/Aug/2015
#generate output directory path
out_parentdir=/tmp/storm_0814
hadoop fs -rm -r -skipTrash ${out_parentdir}
hadoop fs -mkdir ${out_parentdir}

hadoop fs -ls ${input_directory} | grep storm* | grep '2015-08-14' |
while read -a record; do
createDate=${record[5]}
createTime=${record[6]}
file=${record[7]}
hadoop fs -cp ${file} ${out_parentdir}
echo "Processing file ${file} Create Date: $createDate Create Time: $createTime"
done

