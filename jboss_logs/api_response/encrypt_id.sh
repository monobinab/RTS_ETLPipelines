#! /bin/bash

cd /appl/rts/jboss_logs/api_response;
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp
#current_month=May
#current_month=`date +%b`
#current_year=`date +%Y`
#current_day=`date +%d`
script_dir=/appl/rts/jboss_logs/api_response
script_file=encrypt_loyalty_id.pig


#pig -param current_year=${current_year} -param current_month=${current_month} -f ${script_dir}/${script_file} 
pig -f ${script_dir}/${script_file}
ret_code=$?
case ${ret_code} in
     0) printf "\nAPI Member id encrypt job successful \n" >> /logs/rts/pig_encrypt_id.log;;
     *) printf "\nAPI Member id encrypt failed\n" >> /logs/rts/pig_encrypt_id.log
     printf "\nAPI Response Member Id Encrypt job failed with Return Code=${ret_code}\n"| mailx -s "API Response Member Id Encrypt job Failed" -a /logs/rts/pig_encrypt_id.log rtsteam$searshc.com
     exit 1 ;;
esac
