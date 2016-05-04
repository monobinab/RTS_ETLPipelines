#! /bin/bash

cd /appl/rts/occasions_logs;
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
load_date=`date +%Y-%m-%d`
echo $current_timestamp

sql_dir=/appl/rts/occasions_logs
sql_file=step3.sql


hive -hiveconf load_date=${load_date} -f ${sql_dir}/${sql_file} 
ret_code=$?
case ${ret_code} in
     0) printf "\noccasions insert table load job successful \n" >> /logs/rts/occasions_insert.log;;
     *) printf "\noccasions insert table load job job failed\n" >> /logs/rts/occasions_insert.log
     printf "\noccasions insert table load job failed with Return Code=${ret_code}\n"| mailx -s "Occasions insert table load job Failed" -a /logs/rts/occasions_step3.log rtsteam@searshc.com
     exit 1 ;;
esac
exit 0
