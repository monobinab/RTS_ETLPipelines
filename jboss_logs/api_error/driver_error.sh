#! /bin/bash
/appl/rts/jboss_logs/api_error/ErrorMapper_step1.sh > /logs/rts/api_error_step1.log 2>&1
ret_code=$?
printf "\nStatus of streaming job=$ret_code\n" >> /logs/rts/api_error_step1.log
case ${ret_code} in
     0) printf "\nstreaming job successful step1.sh\n" >> /logs/rts/api_error_step1.log;;
     *) printf "\nstreaming job Failed step1.sh\n" >> /logs/rts/api_error_step1.log
     printf "\nRTS API Error Logs streaming job Failed step1.sh\n with Return Code=${ret_code}"| mailx -s "API Error Log streaming job Failed" -a /logs/rts/api_error_step1.log rtsteam$searshc.com
     exit 1 ;;
esac

/appl/rts/jboss_logs/api_error/error_load_step_2.sh > /logs/rts/api_error_step2.log 2>&1
ret_code=$?
printf "\nStatus of step2 job=$ret_code\n" >> /logs/rts/api_error_step2.log
case ${ret_code} in
     0) printf "\nstaging table load job successful step2.sh\n" >> /logs/rts/api_error_step2.log;;
     *) printf "\nstaging table load job Failed step2.sh\n" >> /logs/rts/api_error_step2.log
     printf "\nRTS API Error Logs staging table load job Failed step2.sh\n with Return Code=${ret_code}"| mailx -s "API Error Log staging table load job Failed" -a /logs/rts/api_error_step2.log rtsteam$searshc.com
     exit 1 ;;
esac

/appl/rts/jboss_logs/api_error/error_load_step3.sh > /logs/rts/api_error_step3.log 2>&1
ret_code=$?
printf "\nStatus of step3 job=$ret_code\n" >> /logs/rts/api_error_step3.log
case ${ret_code} in
     0) printf "\ninsert job successful step3.sh\n" >> /logs/rts/api_error_step3.log;;
     *) printf "\ninsert job Failed step3.sh\n" >> /logs/rts/api_error_step3.log
     printf "\nRTS API Error Logs insert job Failed step3.sh with Return Code=${ret_code}\n"| mailx -s "API Error Log insert job Failed" -a /logs/rts/api_error_step3.log rtsteam$searshc.com
     exit 1 ;;
esac

impala-shell -f /appl/rts/jboss_logs/api_error/refresh_api_error_table.sql > /logs/rts/refresh_api_error_table.log 2>&1
exit 0
