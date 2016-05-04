#! /bin/bash
cd /appl/rts/mongo/export_mdtags
outfile=/staging/modelname_modelid_mapping.csv
collection_name=Models
field1=modelId
field2=modelName

/appl/rts/mongo/mongoexport --host trspy5e01-a07.hadoop.searshc.com:27000 --db RTSProd -u rtsreader -p sears123 --collection ${collection_name} --type=csv --out ${outfile} --fields ${field1},${field2}

ret_code=$?
printf "\nStatus of occasions mongo table extract job=$ret_code\n" >> /logs/rts/mongo_export_cmd.log
case ${ret_code} in
     0) printf "\nOccasions mongo table extract job successful\n" >> /logs/rts/mongo_export_cmd.log;;
     *) printf "\Occasions mongo table extract job Failed\n" >> /logs/rts/mongo_export_cmd.log
     printf "\nRTS occasions mongo table extract job Failed\n with Return Code=${ret_code}"| mailx -s "RTS Occasions mongo table create job Failed" -a /logs/rts//mongo_export_cmd.log  rtsteam$searshc.com
     exit 1 ;;
esac 
