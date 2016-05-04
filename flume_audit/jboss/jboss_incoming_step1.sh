current_year=`date +%Y`
current_month=`date +%m`
current_day=`date +%d`
#data_dir=/smith/rts/incoming_jboss_files_snapshot1.txt
run_snapshot=./incoming_jboss_files_snapshot1.sh
snapshot_file1=./incoming_jboss_files_snapshot_old.txt
parsed_snapshotfile1=./parsed_snapshot_file1.txt
snapshot_file2=./incoming_jboss_files_snapshot_current.txt


cat<<EOF >  ${run_snapshot}
hadoop fs -ls /incoming/rts/flume/jboss/${current_year}/${current_month}/${current_day} 
EOF

sh ${run_snapshot} > ${snapshot_file1}

python ls_parser.py > ${parsed_snapshotfile1}



