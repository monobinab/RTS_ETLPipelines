#!/bin/ksh

## using sqoop logic for getting data

#The below commented protion is used to create a Job and add it to the Sqoop Job List.. The command following that is used to Run the job
#sqoop job --create incremental_cp_outbox_sqp --import --verbose $SQOOP_MYSQL_CONN_DETAILS --table cp_outbox --driver com.mysql.jdbc.Driver --target-dir $hdploc/$sqptbl  --fields-terminated-by '|' -m 1
#sqoop job --create incremental_cp_outbox_sqp --import --connect jdbc:mysql://heahada02:13372/rts_member?dontTrackOpenResources=true&defaultFetchSize=1000&useCursorFetch=true --table cp_outbox –-incremental lastmodified -–check-column added_datetime -–last-value "2015-11-22 15:29:48.66" --driver com.mysql.jdbc.Driver --target-dir /incoming/rts/mysql_sqoop_files/datasourcing/cp_outbox/cp_outbox/$(date +"%Y%m%d%H%M%S")  --fields-terminated-by '|' -m 5

sqoop job --create incremental_cp_outbox_sqp -- import --verbose --connect jdbc:mysql://heahada02:13372/rts_member --table cp_outbox --driver com.mysql.jdbc.Driver --target-dir /incoming/rts/mysql_sqoop_files/datasourcing/cp_outbox -incremental append -check-column added_datetime -last-value '2015-11-22 15:29:50.0' -m 1

sqrc=$?

if [ "$sqrc" -ne "0" ]; then

echo "---------------------------------------------------------------------------------------------------------------------------------"

echo "Return Code is :" $sqrc
echo "Error Occured. Sqoop Job Creation Failed for table " cp_outbox

echo "---------------------------------------------------------------------------------------------------------------------------------"
exit $sqrc
fi

echo "---------------------------------------------------------------------------------------------------------------------------------"

echo "Sqoop Job Creation Completed Successfully for table" cp_outbox

echo 'End time is:' `date`

echo "---------------------------------------------------------------------------------------------------------------------------------"

