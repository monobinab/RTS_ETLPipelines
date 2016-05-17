#! /bin/bash
sh /appl/rts/reports/tec/contact_history/new/hive_top_storewideemails.sh > /logs/rts/tec_contact_history_storewideemails.log
ret_code=$?
case ${ret_code} in
     0) printf "\nTEC Storewide emails hive table create job successful \n" >> /logs/rts/TI_ofr_cd.log;;
     *) printf "\nTEC Storewide emails hive table create job failed\n" >> /logs/rts/TI_ofr_cd.log
     echo "\nTEC Storewide emails hive table create job failed with Return Code=${ret_code}\n"| mailx -s "Report TEC Storewide emails hive job Failed" -a /logs/rts/TI_ofr_cd.log msaha@searshc.com
     exit 1 ;;
esac

sh /appl/rts/reports/tec/contact_history/new/drop_teradata_tec_table.sh > /logs/rts/storewide_drop_tec_teradatatable.log
ret_code=$?
echo ${ret_code}

sh /appl/rts/reports/tec/contact_history/new/sqoop_rts_api_response_tec.sh > /logs/rts/tec_storewideemails_sqoop.log
ret_code=$?
case ${ret_code} in
     0) printf "\nTEC Storewide emails sqoop job successful \n" >> /logs/rts/TI_ofr_cd.log;;
     *) printf "\nTEC Storewide emails sqoop job failed\n" >> /logs/rts/TI_ofr_cd.log
     echo "\nTEC Storewide emails sqoop job failed with Return Code=${ret_code}\n"| mailx -s "Report TEC Storewide emails sqoop job Failed" -a /logs/rts/TI_ofr_cd.log msaha@searshc.com
     exit 1 ;;
esac

sh /appl/rts/reports/tec/contact_history/new/teradata_storewideemails_process.sh > /logs/rts/tec_storewideemails_teradata_process.log

sh /appl/rts/reports/tec/contact_history/new/teradata_final_insert.sh >> /logs/rts/tec_storewideemails_teradata_process.log

