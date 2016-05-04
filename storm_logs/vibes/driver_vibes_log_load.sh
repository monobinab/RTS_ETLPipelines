#! /bin/bash
/appl/rts/storm_logs/vibes/vibes_log_stream.sh > /logs/rts/vibes_log_stream.log 2>&1

ret_code=$?
case ${ret_code} in
     0) printf "\nstreaming job successful vibes_log_stream.sh\n" >> /logs/rts/vibes_log_stream.log;;
     *) printf "\nstreaming job Failed vibes_log_stream.sh\n" >> /logs/rts/vibes_log_stream.log
     printf "\nRTS Vibes Logs streaming job Failed vibes_log_stream.sh\n with Return Code=${ret_code}"| mailx -s "Vibes Log streaming job Failed" -a /logs/rts/vibes_log_stream.log msaha$searshc.com
     exit 1 ;;
esac

/appl/rts/storm_logs/vibes/step2.sh > /logs/rts/vibes_step2.log 2>&1

ret_code=$?
case ${ret_code} in
     0) printf "\nVibes logs staging table create job successful\n" >> /logs/rts/vibes_step2.log;;
     *) printf "\nVibes logs staging table create job failed \n" >> /logs/rts/vibes_step2.log
     printf "\nRTS Vibes logs staging table create job failed \n with Return Code=${ret_code}"| mailx -s "Vibes Log staging table create job Failed" -a /logs/vibes_step2.log msaha$searshc.com
     exit 1 ;;
esac

/appl/rts/storm_logs/vibes/step3.sh > /logs/rts/vibes_step3.log 2>&1

ret_code=$?
printf "\nStatus of Create log Table job=$ret_code\n" >> /logs/rts/vibes_step3.log
case ${ret_code} in
     0) printf "\nStatus of insert vibes log Table job successful.sh\n" >> /logs/rts/vibes_step3.log;;
     *) printf "\nStatus of insert vibes log Table failed\n" >> /logs/rts/vibes_step3.log
     printf "\nRTS Vibes Logs insert vibes log Table failed \n with Return Code=${ret_code}"| mailx -s "RTS Vibes insert log Table failed" -a /logs/rts/vibes_step3.log msaha$searshc.com
     exit 1 ;;
esac

~
~
