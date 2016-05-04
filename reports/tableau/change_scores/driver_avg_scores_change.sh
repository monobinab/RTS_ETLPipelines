sh /appl/rts/reports/tableau/change_scores/avg_daily_change_scores_by_source.sh > /logs/rts/avg_change_scores_by_source.log
ret_code=$?
case ${ret_code} in
     0) printf "\nAPI avg change of scores by source table insert job successful \n" >> /logs/rts/avg_change_scores_by_source.log;;
     *) printf "\nAPI avg change of scores by source table insert failed\n" >> /logs/rts/avg_change_scores_by_source.log
     printf "\nAPI avg change of scores by source table insert job failed with Return Code=${ret_code}\n"| mailx -s "API avg chnage of scores by source create table Failed" -a /logs/rts/avg_change_scores_by_source.log msaha@searshc.com
     exit 1 ;;
esac

sh /appl/rts/reports/tableau/change_scores/avg_daily_change_scores.sh > /logs/rts/avg_change_scores.log
ret_code=$?
case ${ret_code} in
     0) printf "\nAPI avg change of scores table insert job successful \n" >> /logs/rts/avg_change_scores.log;;
     *) printf "\nAPI avg change of scores table insert failed\n" >> /logs/rts/avg_change_scores.log
     printf "\nAPI avg change of scores table insert job failed with Return Code=${ret_code}\n"| mailx -s "API avg chnage of scores create table Failed" -a /logs/rts/avg_change_scores.log msaha@searshc.com
     exit 1 ;;
esac
