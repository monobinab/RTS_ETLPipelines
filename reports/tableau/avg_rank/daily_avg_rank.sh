cd /appl/rts/reports/tableau/avg_rank
current_date=`date +%Y%m%d`
current_year=`date +%Y`
current_month=`date +%-m`
sql_file=daily_avg_rank.sql
sql_dir=/appl/rts/reports/tableau/avg_rank


hive -hiveconf current_year=${current_year} -hiveconf current_month=${current_month} -f ${sql_dir}/${sql_file} > /logs/rts/report_daily_avg_rank.log 
ret_code=$?
case ${ret_code} in
     0) printf "\nAPI api_avg_model_rank table insert job successful \n" >> /logs/rts/report_daily_avg_rank.log;;
     *) printf "\nAPI api_avg_model_rank table insert failed\n" >> /logs/rts/report_daily_avg_rank.log
     printf "\nAPI api_avg_model_rank table insert job failed with Return Code=${ret_code}\n"| mailx -s "API api_avg_model_rank create table Failed" -a /logs/rts/report_daily_avg_rank.log msaha@searshc.com
     exit 1 ;;
esac

impala-shell -f refresh_api_avg_rank.sql >> /logs/rts/refresh_api_avg_rank.log 2>&1

exit 0
