#! /bin/bash
cd /appl/rts/mongo
logdir=/logs/rts

/appl/rts/mongo/mongo_export_cmd.sh > $logdir/mongo_export_cmd.log

sed 1d /staging/occasionResponses.csv > /staging/occasionResponses_noheader.csv

fastload</appl/rts/mongo/mongo_dmp.fld > $logdir/mongo_dmp_fld.log
ret_code=$?
case ${ret_code} in
     0) printf "\nRTS fastload job from mongo suceess\n" >> /logs/rts/mongo_dmp_fld.log ;;
     *) printf "\nFastload Occasions job from mongo Failed with Return Code=${ret_code}"| mailx -s "Fastload Occasions job from mongo Failed" -a /logs/rts/mongo_dmp_fld.log rtsteam$searshc.com
     exit 1 ;;
esac

bteq</appl/rts/mongo/teradata_insert.sql > $logdir/teradata_insert.log
ret_code=$?
case ${ret_code} in
     0) printf "\nRTS Bteq occasions job from mongo Success\n" >> /logs/rts/teradata_insert.log
     *) printf "\nRTS Bteq Occasions job from mongo Failed with Return Code=${ret_code}"| mailx -s "Bteq Occasions job from mongo Failed" -a /logs/rts/teradata_insert.log rtsteam$searshc.com
     exit 1 ;;
esac
