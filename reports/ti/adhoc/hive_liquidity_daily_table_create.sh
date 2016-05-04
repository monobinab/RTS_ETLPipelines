#! /bin/bash
current_day=`date +%-d`
today=1
#yesterday=(9, 10, 11, 12, 13)

current_month=`date +%-m -d "2 day ago"`
current_year=`date +%Y -d "2 day ago"`

hive -hiveconf current_day=${current_day} -hiveconf current_month=${current_month} -hiveconf current_year=${current_year} -f /appl/rts/reports/ti/adhoc/liquidity_daily_table_create.sql
ret_code=$?
printf "\nStatus of TI hive table create job=$ret_code\n" >> /logs/rts/hive_liquidity_daily_table_create_ti.log
case ${ret_code} in
     0) printf "\nhive table job successful\n" >> /logs/rts/hive_liquidity_daily_table_create_ti.log;;
     *) printf "\hive table job Failed\n" >> /logs/rts/hive_liquidity_daily_table_create_ti.log
     printf "\nRTS liquidity TI hive table create job Failed\n with Return Code=${ret_code}"| mailx -s "Hive table create job Failed" -a /logs/rts/hive_liquidity_daily_table_create_ti.log  rtsteam$searshc.com
     exit 1 ;;
esac
 
