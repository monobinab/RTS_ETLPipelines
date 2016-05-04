
use real_time_scoring;

--create table api_error_log (
--run_date string,
--error_cd string,
--error_msg string,
--member_id string,
--client string
--)
--partitioned by (Year int, Month int)
--row format delimited
--fields terminated by '|'
--lines terminated by '\n'
--stored as textfile
--;

SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;


SET mapreduce.output.fileoutputformat.compress.codec=com.hadoop.compression.lzo.LzopCodec;
SET hive.exec.compress.output=true;
SET mapreduce.output.fileoutputformat.compress=true;
set avro.output.codec=snappy;


ALTER TABLE api_error_log DROP IF EXISTS PARTITION(year = '${hiveconf:current_year}', month = '${hiveconf:current_month}');

drop table rts_api_error_log_staging_1;

create table rts_api_error_log_staging_1 (
run_date string,
error_cd string,
error_msg string,
member_id string,
client string
)
row format delimited
fields terminated by '|'
lines terminated by '\n'
stored as textfile
;

--insert into table rts_api_error_log_staging_1
--select
--trim(run_date) as run_date,
--trim(v1.error_cd) as error_cd,
--trim(v1.error_msg) as error_msg,
--trim(t1.member_id) as member_id,
--trim(t1.client)as client
--from
--rts_api_error_log_staging t1
--  lateral view json_tuple(t1.error_message, 'errorCode', 'errorMessage') v1 as error_cd, error_msg
--;

insert into table api_error_log
partition(Year, Month)
select
trim(t1.run_date),
--unix_timestamp(t.run_date, "EEE MMM dd HH:mm:ss z yyyy") as rundate_epoch,
trim(v1.error_cd),
trim(v1.error_msg),
trim(t1.member_id),
trim(t1.client),
year(t1.run_date) as year,
month(t1.run_date) as month
from
rts_api_error_log_staging t1
  lateral view json_tuple(t1.error_message, 'errorCode', 'errorMessage') v1 as error_cd, error_msg
;


