#! /bin/bash
cd /appl/rts/reports/ti/adhoc
/appl/rts/reports/ti/adhoc/hive_liquidity_daily_table_create.sh > /logs/rts/hive_liquidity_daily_table_create_ti.log  2>&1
ret_code=$?
printf "\nStatus of TI hive table create job=$ret_code\n" >> /logs/rts/hive_liquidity_daily_table_create_ti.log
case ${ret_code} in
     0) printf "\nhive table job successful\n" >> /logs/rts/hive_liquidity_daily_table_create_ti.log;;
     *) printf "\hive table job Failed\n" >> /logs/rts/hive_liquidity_daily_table_create_ti.log
     printf "\nRTS liquidity TI hive table create job Failed\n with Return Code=${ret_code}"| mailx -s "Hive table create job Failed" -a /logs/rts/hive_liquidity_daily_table_create_ti.log  rtsteam$searshc.com
     exit 1 ;;
esac

hadoop fs -getmerge /user/hive/warehouse/real_time_scoring.db/liquidity_report_daily/*  /staging/rts/liquidity_dailyreport_combined.txt
echo ret_code=$? > /logs/rts/liquidity_dailyreport_combined.log
case ${ret_code} in
     0) printf "\nRTS liquidity merge local files job suceess\n" >> /logs/rts/liquidity_dailyreport_combined.log ;;
     *) printf "\nRTS liquidity TI files combine job Failed\n with Return Code=${ret_code}"| mailx -s "Files combine job Failed"  rtsteam$searshc.com
     exit 1 ;;
esac

fastload</appl/rts/reports/ti/adhoc/liquidity_daily.fld > /logs/rts/liquidity_daily_fld_ti.log
ret_code=$?
case ${ret_code} in
     0) printf "\nRTS fastload job suceess\n" >> /logs/rts/liquidity_daily_fld_ti.log ;;
     *) printf "\nFastload TI job Failed with Return Code=${ret_code}"| mailx -s "Fastload TI job Failed" -a /logs/rts/liquidity_daily_fld_ti.log rtsteam$searshc.com
     exit 1 ;;
esac

