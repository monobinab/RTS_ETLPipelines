use real_time_scoring;
SET mapreduce.output.fileoutputformat.compress.codec=com.hadoop.compression.lzo.LzopCodec;
SET hive.exec.compress.output=true;
SET mapreduce.output.fileoutputformat.compress=true;
set avro.output.codec=snappy;

drop table if exists rts_api_response_log_staging_deduped;

create table rts_api_response_log_staging_deduped (
run_date string,
api_response string,
lyl_id_no string,
encrypted_lyl_id_no string,
client string,
time_taken string
)
row format delimited
fields terminated by '|'
lines terminated by '\n'
STORED AS INPUTFORMAT  "com.hadoop.mapred.DeprecatedLzoTextInputFormat"
OUTPUTFORMAT "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
;
set mapred.reduce.tasks = 13;

insert into table rts_api_response_log_staging_deduped
select
run_date, api_response, lyl_id_no, encrypted_lyl_id_no, client, time_taken
from
(
Select
run_date,
api_response,
lyl_id_no,
encrypted_lyl_id_no,
client,
time_taken,
row_number() over (partition by run_date, lyl_id_no order by run_date, lyl_id_no) rn
from rts_api_response_log_staging) a
where a.rn = 1
;

