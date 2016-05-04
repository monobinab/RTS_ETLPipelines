#! /bin/bash

hive -f /appl/rts/reports/changed_scores/step2.sql
ret_code=$?
case ${ret_code} in
     0) printf "\nRTS hive insert into storm_serve_count job Success\n" >> /logs/rts/api_served_with_changed_scores_step2.log
     *) printf "\nRTS hive insert into storm_serve_count job Failed with Return Code=${ret_code}"| mailx -s "RTS hive insert into storm_serve_count job Failed" -a /logs/rts/api_served_with_changed_scores_step2.log rtsteam$searshc.com
     exit 1 ;;
esac
