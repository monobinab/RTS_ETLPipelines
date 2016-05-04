#! /bin/bash
cd /appl/rts/occasions_logs
/appl/rts/occasions_logs/step1.sh > /logs/rts/occasions_step1.log 2>&1
ret_code=$?
printf "\nStatus of streaming job=$ret_code\n" >> /logs/rts/occasions_step1.log
case ${ret_code} in
     0) printf "\nstreaming job successful step1.sh\n" >> /logs/rts/occasions_step1.log;;
     *) printf "\nstreaming job Failed step1.sh\n" >> /logs/rts/occasions_step1.log
     printf "\nRTS Occasions Logs streaming job Failed step1.sh\n with Return Code=${ret_code}"| mailx -s "Occasions Log streaming job Failed" -a /logs/rts/occasions_step1.log rtsteam$searshc.com
     exit 1 ;;
esac

/appl/rts/occasions_logs/step2.sh > /logs/rts/occasions_step2.log 2>&1
ret_code=$?
printf "\nStatus of step2 job=$ret_code\n" >> /logs/rts/occasions_step2.log
case ${ret_code} in
     0) printf "\nstaging table load job successful step2.sh\n" >> /logs/rts/occasions_step2.log;;
     *) printf "\nstaging table load job Failed step2.sh\n" >> /logs/rts/occasions_step2.log
     printf "\nRTS Occasions Logs staging table load job Failed step2.sh\n with Return Code=${ret_code}"| mailx -s "Occasions Log staging table load job Failed" -a /logs/rts/occasions_step2.log rtsteam$searshc.com
     exit 1 ;;
esac

/appl/rts/occasions_logs/step3.sh > /logs/rts/occasions_insert.log 2>&1
ret_code=$?
printf "\nStatus of step3 job=$ret_code\n" >> /logs/rts/occasions_insert.log
case ${ret_code} in
     0) printf "\ninsert job successful step3.sh\n" >> /logs/rts/occasions_insert.log;;
     *) printf "\ninsert job Failed step3.sh\n" >> /logs/rts/occasions_insert.log
     printf "\nRTS Occasions Logs insert job Failed with Return Code=${ret_code}\n"| mailx -s "Occasions Log insert job Failed" -a /logs/rts/occasions_insert.log rtsteam$searshc.com
     exit 1 ;;
esac


impala-shell -f /appl/rts/occasions_logs/refresh_occasions_table.sql > /logs/rts/occasions_refresh_table.log 2>&1
exit 0
