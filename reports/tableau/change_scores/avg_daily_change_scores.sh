cd /appl/rts/reports/tableau/change_scores
sql_dir=/appl/rts/reports/tableau/change_scores
sql_file=avg_daily_change_scores.sql

current_year=`date +%Y`
current_month=`date +%-m`
current_day=`date +%-d`

hadoop fs -rm -r -skipTrash /user/hive/warehouse/real_time_scoring.db/rts_avg_change_in_scores
hive -hiveconf current_year=${current_year} -hiveconf current_month=${current_month} -f ${sql_dir}/${sql_file} > /logs/rts/daily_avg_scores_change.log

ret_code=$?
case ${ret_code} in
     0) printf "\nAPI avg change of scores table insert job successful \n" >> /logs/rts/avg_change_scores.log;;
     *) printf "\nAPI avg change of scores table insert failed\n" >> /logs/rts/avg_change_scores.log
     printf "\nAPI avg change of scores table insert job failed with Return Code=${ret_code}\n"| mailx -s "API avg chnage of scores create table Failed" -a /logs/rts/avg_change_scores.log msaha@searshc.com
     exit 1 ;;
esac

impala-shell -f refresh_api_avg_scores_change.sql >> /logs/rts/avg_change_scores.log 2>&1

exit 0

