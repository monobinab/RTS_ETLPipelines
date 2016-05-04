#! /bin/bash
cd /appl/rts/reports/tableau/api_fastness
sql_file_1=rts_fastness_1.sql
sql_file_2=rts_fastness_2.sql
current_month=`(date +%-m)`
start_month=`date +%m --date="1 month ago"`
end_month=`date +%m -d "1 day ago"`
start_year=`date +%Y --date="1 month ago"`
end_year=`date +%Y -d "1 day ago"`
start_day=`date +%d --date="1 month ago"`
end_day=`date +%d -d "1 day ago"`
start_date=`date '+%Y-%m-%d %H:%M:%S' --date="1 month ago"`
end_date=`date '+%Y-%m-%d %H:%M:%S' --date="1 day ago"`
echo "start_date" is ${start_date}
echo "end_date" is ${end_date}
echo $work_month


hive -hiveconf start_year=${start_year} -hiveconf start_month=${start_month} -hiveconf end_year=${end_year} -hiveconf end_month=${end_month} -hiveconf start_date=${start_date} -hiveconf end_date=${end_date} -f ${sql_file_1} > /logs/rts/api_fastness_1.log
ret_code=$?
case ${ret_code} in
     0) printf "\nReport api_calls_scores table streaming job successful \n" >> /logs/rts/api_fastness_1.log;;
     *) printf "\nReport api_calls_scores table create job failed\n" >> /logs/rts/api_fastness_1.log
     echo "\nReport api_calls_scores create job failed with Return Code=${ret_code}\n"| mailx -s "Report api_calls_scores job Failed" -a /logs/rts/api_fastness_1.log msaha@searshc.com
     exit 1 ;;
esac


hive -hiveconf start_year=${start_year} -hiveconf start_month=${start_month} -hiveconf end_year=${end_year} -hiveconf end_month=${end_month} -hiveconf start_date=${start_date} -hiveconf end_date=${end_date} -f ${sql_file_2} > /logs/rts/api_fastness_2.log
ret_code=$?
case ${ret_code} in
     0) printf "\nReport api calls percentage calculation job successful \n" >> /logs/rts/api_fastness_2.log;;
     *) printf "\nReport api calls percentage calculation job failed\n" >> /logs/rts/api_fastness_2.log
     echo "\nReport api calls percentage calculation job failed with Return Code=${ret_code}\n"| mailx -s "Report api calls percentage calculation job Failed" -a /logs/rts/api_fastness_2.log msaha@searshc.com
     exit 1 ;;
esac

impala-shell -f /appl/rts/reports/tableau/api_fastness/refresh_api_calls_percentage.sql >> /logs/rts/api_fastness_2.log
ret_code=$?
case ${ret_code} in
     0) printf "\nReport api calls fastness impala table refresh job successful \n" >> /logs/rts/api_fastness_2.log;;
     *) printf "\nReport api calls fastness impala table refresh job failed\n" >> /logs/rts/api_fastness_2.log
     echo "\nReport api calls fastness impala table refresh job failed with Return Code=${ret_code}\n"| mailx -s "Report api calls fastness imapala table refresh job Failed" -a /logs/rts/ pi_fastness_2.log msaha@searshc.com
     exit 1 ;;
esac
