#! /bin/bash
current_day=`date +%-d`
today=1
yesterday=$(date '+%-d' -d "1 day ago")

current_month=`date +%-m -d "1 day ago"`
current_year=`date +%Y -d "1 day ago"`

hadoop fs -rm -r -skipTrash /user/hive/warehouse/real_time_scoring.db/liquidity_report_daily

hive -hiveconf current_day=${current_day} -hiveconf yesterday=${yesterday} -hiveconf current_month=${current_month} -hiveconf current_year=${current_year} -f /appl/rts/reports/ti/liquidity_daily_table_create.sql

ret_code=$?
printf "\nStatus of TI hive table create job=$ret_code\n" >> /logs/rts/hive_liquidity_daily_table_create_ti.log
case ${ret_code} in
     0) printf "\nhive table job successful\n" >> /logs/rts/hive_liquidity_daily_table_create_ti.log;;
     *) printf "\hive table job Failed\n" >> /logs/rts/hive_liquidity_daily_table_create_ti.log
     printf "\nRTS liquidity TI hive table create job Failed\n with Return Code=${ret_code}"| mailx -s "Hive table create job Failed" -a /logs/rts/hive_liquidity_daily_table_create_ti.log  rtsteam$searshc.com
     exit 1 ;;
esac
 
