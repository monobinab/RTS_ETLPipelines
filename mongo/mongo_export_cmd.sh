#! //bin/bash
cd /appl/rts/mongo
last_datestamp=$(date '+%Y-%m-%d' -d "2 day ago")
outfile=/staging/occasionResponses.csv
collection_name=occasionResponses
field1=l_id
field2=eid
field3=tag
field4=t
field5=topology

/home/auto/spannal/mongodb-linux-x86_64-3.0.3/bin/mongoexport --host trspy5e02-a09.hadoop.searshc.com:27000 --db RTSProd -u rtsreader -p sears123 --collection ${collection_name} --type=csv  --query "{\"t\": /${last_datestamp}/}" --out ${outfile} --fields ${field1},${field2},${field3},${field4},${field5}

ret_code=$?
printf "\nStatus of occasions mongo table extract job=$ret_code\n" >> /logs/rts/mongo_export_cmd.log
case ${ret_code} in
     0) printf "\nOccasions mongo table extract job successful\n" >> /logs/rts/mongo_export_cmd.log;;
     *) printf "\Occasions mongo table extract job Failed\n" >> /logs/rts/mongo_export_cmd.log
     printf "\nRTS occasions mongo table extract job Failed\n with Return Code=${ret_code}"| mailx -s "RTS Occasions mongo table create job Failed" -a /logs/rts//mongo_export_cmd.log  rtsteam$searshc.com
     exit 1 ;;
esac 
