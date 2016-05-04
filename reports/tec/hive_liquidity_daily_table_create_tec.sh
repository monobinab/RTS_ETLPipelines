#! /bin/bash
current_day=`date +%-d`
yesterday=$(date '+%-d' -d "2 day ago")

current_month=`date +%-m`
current_year=`date +%Y`

hive -hiveconf current_day=${current_day} -hiveconf yesterday=${yesterday} -hiveconf current_month=${current_month} -hiveconf current_year=${current_year} -f /appl/rts/reports/tec/hive_liquidity_daily_table_tec.sql
ret_code=$?
printf "\nStatus of hive table create job=$ret_code\n" >> /logs/rts/hive_liquidity_daily_table_create_tec.log
case ${ret_code} in
     0) printf "\nhive table job successful\n" >> /logs/rts/hive_liquidity_daily_table_create_tec.log;;
     *) printf "\hive table job Failed\n" >> /logs/rts/hive_liquidity_daily_table_create_tec.log
     printf "\nRTS liquidity tec hive table create job Failed\n with Return Code=${ret_code}"| mailx -s "RTS tec Hive table create job Failed" -a /logs/rts/hive_liquidity_daily_table_create_tec.log  rtsteam$searshc.com
     exit 1 ;;
esac
 
