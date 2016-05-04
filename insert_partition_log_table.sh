current_timestamp=`date +%Y-%m-%d'  '%H':'%M`
echo $current_timestamp
current_month=`date +%b`
current_year=`date +%Y`

input_parentdir=/smith/rts
sql_file=load_rts_api_partition.sql

export input_directory=${input_parentdir}/$current_month/$current_year
echo "data directory is : " ${input_directory}
#export ${input_directory}

#hive -hiveconf current_year=$current_year
#hive -hiveconf current_month=$currentmonth

hive -hiveconf current_year=${current_year} current_month=${currentmonth} -f ./$sql_file
