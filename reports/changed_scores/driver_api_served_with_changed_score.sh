#! /bin/bash
cd /appl/rts/reports/changed_scores 
/appl/rts/reports/changed_scores/step1.sh > /logs/rts/api_served_with_changed_scores_step1.log 2>&1
ret_code=$?
case ${ret_code} in
     0) printf "\nRTS Hive insert into api_served_with_changed_score job Success\n" >> /logs/rts/api_served_with_changed_scores_step1.log
     *) printf "\nRTS Hive insert into api_served_with_changed_score job Failed with Return Code=${ret_code}"| mailx -s "Bteq TI job Failed" -a /logs/rts/api_served_with_changed_scores_step1.log rtsteam$searshc.com
     exit 1 ;;
esac

/appl/rts/reports/changed_scores/step2.sh > /logs/rts/api_served_with_changed_scores_step2.log 2>&1
ret_code=$?
case ${ret_code} in
     0) printf "\nRTS hive insert into storm_serve_count job Success\n" >> /logs/rts/api_served_with_changed_scores_step2.log
     *) printf "\nRTS hive insert into storm_serve_count job Failed with Return Code=${ret_code}"| mailx -s "RTS hive insert into storm_serve_count job Failed" -a /logs/rts/api_served_with_changed_scores_step2.log rtsteam$searshc.com
     exit 1 ;;
esac

#/home/auto/msaha/rts/reports/automation/changed_scores/step3.sh > /home/auto/msaha/rts/reports/automation/changed_scores/logs/step3.log 2>&1
#/home/auto/msaha/rts/reports/automation/changed_scores/step4.sh > /home/auto/msaha/rts/reports/automation/changed_scores/logs/step4.log 2>&1

