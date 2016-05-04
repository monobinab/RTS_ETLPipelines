#! /bin/bash
cd /appl/rts/reports/tec 
/appl/rts/reports/tec/hive_liquidity_daily_table_create_tec.sh > /logs/rts/hive_liquidity_daily_table_create_tec.log  2>&1
ret_code=$?
printf "\nStatus of hive table create job=$ret_code\n" >> /logs/rts/hive_liquidity_daily_table_create_tec.log
case ${ret_code} in
     0) printf "\nhive table job successful\n" >> /logs/rts/hive_liquidity_daily_table_create_tec.log;;
     *) printf "\hive table job Failed\n" >> /logs/rts/hive_liquidity_daily_table_create_tec.log
     printf "\nRTS liquidity tec hive table create job Failed\n with Return Code=${ret_code}"| mailx -s "RTS tec Hive table create job Failed" -a /logs/rts/hive_liquidity_daily_table_create_tec.log  rtsteam$searshc.com
     exit 1 ;;
esac

rm -r /staging/liquidity_report_daily_tec
ret_code=$?
printf "\nStatus of removing existing liquidity_report_daily folder=$ret_code\n" > /logs/rts/remove_liquidity_report_daily_tec.log
case ${ret_code} in
     0) printf "\nStatus of removing existing liquidity_report_daily_tec folder job successful\n" >> /logs/rts/remove_liquidity_report_daily_tec;;
     *) printf "\nStatus of removing existing liquidity_report_daily_tec folder job Failed\n" >> /logs/rts/remove_liquidity_report_daily_tec.log
     printf "\nRTS remove liquidity_report_daily_tec folder job Failed\n with Return Code=${ret_code}"| mailx -s "RTS remove liquidity_report_daily_tec folder job Failed" -a /logs/rts/remove_liquidity_report_daily_tec.log  rtsteam$searshc.com
     exit 1 ;;
esac

mkdir /staging/liquidity_report_daily_tec
ret_code=$?
printf "\nStatus of mkdir liquidity_report_daily folder=$ret_code\n" > /logs/rts/mkdir_liquidity_report_daily_tec.log
case ${ret_code} in
     0) printf "\nStatus of mkdir liquidity_report_daily_tec folder job successful\n" >> /logs/rts/mkdir_liquidity_report_daily_tec.log;;
     *) printf "\nStatus of mkdir liquidity_report_daily_tec folder job Failed\n" >> /logs/rts/mkdir_liquidity_report_daily_tec.log
     printf "\nRTS mkdir liquidity_report_daily_tec folder job Failed\n with Return Code=${ret_code}"| mailx -s "RTS mkdir liquidity_report_daily_tec folder job Failed" -a /logs/rts/mkdir_liquidity_report_daily_tec.log  rtsteam$searshc.com
     exit 1 ;;
esac

chmod 766 /staging/liquidity_report_daily_tec
et_code=$?
printf "\nStatus of permission to liquidity_report_daily_tec folder=$ret_code\n" > /logs/rts/chmod_liquidity_report_daily_tec.log
case ${ret_code} in
     0) printf "\nStatus of permission to liquidity_report_daily_tec folder job successful\n" >> /logs/rts/chmod_liquidity_report_daily_tec.log;;
     *) printf "\nStatus of permission to liquidity_report_daily_tec folder job Failed\n" >> /logs/rts/chmod_liquidity_report_daily_tec.log
     printf "\nRTS permission to liquidity_report_daily_tec folder job Failed\n with Return Code=${ret_code}"| mailx -s "RTS permission to liquidity_report_daily_tec folder job Failed" -a /logs/rts/chmod_liquidity_report_daily_tec.log  rtsteam$searshc.com
     exit 1 ;;
esac

hadoop fs -copyToLocal /user/hive/warehouse/real_time_scoring.db/rts_liquidity_daily_tec/* /staging/liquidity_report_daily_tec
ret_code=$?
case ${ret_code} in
     0) printf "\nRTS copy to local job success\n" > /logs/rts/copyToLocal_tec.log ;;
     *) printf "\nRTS TEC copy to local job Failed\n with Return Code=${ret_code}"| mailx -s "RTS TEC copy to local job Failed" -a /logs/rts/copyToLocal_tec.log rtsteam$searshc.com
     exit 1 ;;
esac

#rm /staging/liquidity_report_daily/*_data.0

cat /staging/liquidity_report_daily_tec/* > /staging/liquidity_dailyreport_tec_combined.txt
ret_code=$?
case ${ret_code} in
     0) printf "\nRTS TEC combine file job success\n" > /logs/rts/combined_file_job_tec.log ;;
     *) printf "\nRTS liquidity tec combine files job Failed with Return Code=${ret_code}"| mailx -s "liquidity tec combine files job Failed" -a /logs/rts/combined_file_job_tec.log  rtsteam$searshc.com
     exit 1 ;;
esac

fastload</appl/rts/reports/tec/liquidity_daily_tec.fld > /logs/rts/liquidity_daily_fld_tec.log  2>&1
ret_code=$?
case ${ret_code} in
     0) printf "\nRTS fastload job suceess\n" > /logs/rts/liquidity_daily_fld_tec.log ;;
     *) printf "\nFastload TEC job Failed with Return Code=${ret_code}"| mailx -s "tec Fastload job Failed" -a /logs/rts/liquidity_daily_fld_tec.log rtsteam$searshc.com
     exit 1 ;;
esac

bteq</appl/rts/reports/tec/insert_into_prod_rts_liquidity_tec.sql > /logs/rts/insert_into_prod_rts_liquidity_tec.log
ret_code=$?
case ${ret_code} in
     0) printf "\nRTS Bteq job Success\n" > /logs/rts/insert_into_prod_rts_liquidity_ti.log
     *) printf "\nRTS TEC Bteq job Failed with Return Code=${ret_code}"| mailx -s "TEC Bteq job Failed" -a /logs/rts/insert_into_prod_rts_liquidity_ti.log rtsteam$searshc.com
     exit 1 ;;
esac

