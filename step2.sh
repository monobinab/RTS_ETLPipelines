#! /bin/bash
cd /home/auto/msaha/rts/api/final;
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp
current_month=`date +%b`
#current_month=Mar
current_year=`date +%Y`

input_parentdir=/smith/rts
sql_dir=/home/auto/msaha/rts/api/final
sql_file=step2.sql

input_directory=${input_parentdir}/$current_month/$current_year

echo "data directory is : " ${input_directory}
#export ${input_directory}

hive -hiveconf input_directory=${input_directory} -f ${sql_dir}/${sql_file}
