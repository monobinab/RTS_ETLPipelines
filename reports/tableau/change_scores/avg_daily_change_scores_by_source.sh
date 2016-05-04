cd /appl/rts/reports/tableau/change_scores
sql_dir=/appl/rts/reports/tableau/change_scores
sql_file=avg_change_scores_by_source.sql
current_year=`date +%Y`
current_month=`date +%-m`
current_day=`date +%-d`

hadoop fs -rm -r -skipTrash /user/hive/warehouse/real_time_scoring.db/rts_avg_change_in_scores_by_source
hive -hiveconf current_year=${current_year} -hiveconf current_month=${current_month} -f ${sql_dir}/${sql_file} >> /logs/rts/avg_change_scores_by_source.log

ret_code=$?
case ${ret_code} in
     0) printf "\nAPI avg change of scores by source table insert job successful \n" >> /logs/rts/avg_change_scores_by_source.log;;
     *) printf "\nAPI avg change of scores by source table insert failed\n" >> /logs/rts/avg_change_scores_by_source.log
     printf "\nAPI avg change of scores by source table insert job failed with Return Code=${ret_code}\n"| mailx -s "API avg chnage of scores by source create table Failed" -a /logs/rts/avg_change_scores_by_source.log msaha@searshc.com
     exit 1 ;;
esac

impala-shell -f refresh_api_avg_scores_change.sql >> /logs/rts/avg_change_scores_by_source.log 2>&1

exit 0



