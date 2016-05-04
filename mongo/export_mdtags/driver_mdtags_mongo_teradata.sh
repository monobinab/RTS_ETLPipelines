/appl/rts/mongo/export_mdtags/mongo_export_cmd.sh > /logs/rts/mdtags_mongoexport.log 2>&1
ret_code=$?
case ${ret_code} in
     0) printf "\nRTS mdtags mongo export job  suceess\n" >> /logs/rts/mdtags_mongoexport.log ;;
     *) printf "\nRTS mdtags mongo export job  Failed with Return Code=${ret_code}"| mailx -s "RTS mdtags mongo export job Failed" -a /logs/rts/mdtags_mongoexport.log rtsteam$searshc.com
     exit 1 ;;
esac

python /appl/rts/mongo/export_mdtags/mdtags_parser.py > /logs/rts/mdtags_python_jsonparser.log 2>&1
ret_code=$?
case ${ret_code} in
     0) printf "\nRTS mdtags json parser job  suceess\n" >> /logs/rts/mdtags_python_jsonparser.log ;;
     *) printf "\nRTS mdtags json parser job  Failed with Return Code=${ret_code}"| mailx -s "RTS mdtags json parser job Failed" -a /logs/rts/mdtags_python_jsonparser.log rtsteam$searshc.com
     exit 1 ;;
esac

fastload</appl/rts/mongo/export_mdtags/mdtags_load.fld > /logs/rts/mdtags_load_fld.log 2>&1
ret_code=$?
case ${ret_code} in
     0) printf "\nRTS mdtags fastload job  suceess\n" >> /logs/rts/mdtags_load_fld.log ;;
     *) printf "\nRTS mdtags fastload job  Failed with Return Code=${ret_code}"| mailx -s "RTS mdtags fastload job Failed" -a /logs/rts/mdtags_load_fld.log rtsteam$searshc.com
     exit 1 ;;
esac

bteq</appl/rts/mongo/export_mdtags/mdtags_teradata_insert.sql > /logs/rts/teradata_insert_mdtags.log 2>&1
ret_code=$?
case ${ret_code} in
     0) printf "\nRTS mdtag bteq teradata insert job  suceess\n" >> /logs/rts/teradata_insert_mdtags.log ;;
     *) printf "\nRTS mdtags bteq teradata insert job Failed with Return Code=${ret_code}"| mailx -s "RTS mdtags bteq teradata insert job Failed" -a /logs/rts/teradata_insert_mdtags.log rtsteam$searshc.com
     exit 1 ;;
esac
