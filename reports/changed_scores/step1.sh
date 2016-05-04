#! /bin/bash
current_day=`date +%-d`
last_day=$(date '+%-d' -d "1 day ago")
storm_last_day=$(date '+%-d' -d "7 day ago")
#current_month=5
current_month=`date +%-m`
current_year=`date +%Y`

hive -hiveconf current_day=${current_day} -hiveconf current_month=${current_month} -hiveconf current_year=${current_year} -hiveconf last_day=${last_day} -f /appl/rts/reports/changed_scores/step1.sql

ret_code=$?
case ${ret_code} in
     0) printf "\nRTS Hive insert into api_served_with_changed_score job Success\n" >> /logs/rts/api_served_with_changed_scores_step1.log
     *) printf "\nRTS Hive insert into api_served_with_changed_score job Failed with Return Code=${ret_code}"| mailx -s "Bteq TI job Failed" -a /logs/rts/api_served_with_changed_scores_step1.log rtsteam$searshc.com
     exit 1 ;;
esac
