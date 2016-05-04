#! /bin/bash
cd /home/auto/msaha/rts/api/final;
current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp
#current_month=Mar
#current_month=`date +%b`
current_month=08
current_day=10
current_year=2015
#current_year=`date +%Y`
#current_day=`date +%-d`

if [ ${current_day} = 1 ]; then
current_month=$(date '+%b' -d "1 day ago")
echo "current_month is ${current_month}"
if [ ${current_month} == "Jan" ] || [ ${current_month} == "Mar" ] || [ ${current_month} == "May" ] || [ ${current_month} == "Jul" ] || [ ${current_month} == "Aug" ] || [ ${current_month} == "Oct"] || [ ${current_month} == "Dec" ] ; then
       current_day=31
       echo "current day is ${current_day}"
       last_datestamp=$(date '+%Y-%m-%d' -d "2 day ago")
       echo "Last Datestamp is ${last_datestamp}"
   elif [ current_month == "Feb" ]; then
       current_day=28
       echo "current day is ${current_day}"
       last_datestamp=$(date '+%Y-%m-%d' -d "2 day ago")
       echo "Last Datestamp is ${last_datestamp}"
   else
       current_day=30
       echo "current day is ${current_day}"
       last_datestamp=$(date '+%Y-%m-%d' -d "2 day ago")
       echo "Last Datestamp is ${last_datestamp}"
fi 
else 
last_datestamp=$(date '+%Y-%m-%d' -d "2 day ago")
echo "Last Datestamp is ${last_datestamp}"
fi


echo "So the current month for today's load is ${current_month} and current day is ${current_day}"

#last_datestamp=$(${current_day}-1)
#current_datestamp=$(date '+%Y%m%d' -d "0 day ago")


#generate input directory path
input_parentdir=/incoming/rts/flume
input_directory=${input_parentdir}/$current_month/$current_year
echo "Input Directory is ${input_directory}"
#generate output directory path
out_parentdir=/tmp/adhoc_api
#out_parentdir=/smith/rts
#out_directory=${out_parentdir}/$current_month/$current_year
hadoop fs -rm -r -skipTrash ${out_parentdir}
hadoop fs -mkdir ${out_parentdir}

echo "Out directory is ${out_parentdir}"
hadoop fs -ls ${input_directory} | grep jboss* | sort -k 6 -k 7 -r |
while read -a record; do
createDate=${record[5]}
createTime=${record[6]}
file=${record[7]}
#echo $file
if [ $(date -d $createDate +%s) -gt $(date -d ${last_datestamp} +%s) ] ; then
hadoop fs -cp ${file} ${out_parentdir}
echo "Processing file ${file} Create Date: $createDate Create Time: $createTime"
fi
done


ret_code=$?
case ${ret_code} in
     0) printf "\nAPI streaming job successful \n" > /home/auto/msaha/rts/api/final/logs/load_api.log
     echo "\nAPI streaming job success with Return Code=${ret_code}\n"| mailx -s "API streaming job Success" msaha$searshc.com;;
     *) printf "\nAPI streaming job failed\n" > /home/auto/msaha/rts/api/final/logs/load_api.log
     echo "\nAPI streaming job failed with Return Code=${ret_code}\n"| mailx -s "API streaming job Failed"  msaha$searshc.com
     exit 1 ;;
esac
