use real_time_scoring;

SET mapreduce.output.fileoutputformat.compress.codec=com.hadoop.compression.lzo.LzopCodec;
SET hive.exec.compress.output=true;
SET mapreduce.output.fileoutputformat.compress=true;
set avro.output.codec=snappy;

drop table if exists rts_api_error_log_staging;

create table rts_api_error_log_staging (
run_date string,
error_message string,
member_id string,
client string
)
row format delimited
fields terminated by '|'
lines terminated by '\n'
STORED AS INPUTFORMAT  "com.hadoop.mapred.DeprecatedLzoTextInputFormat"
OUTPUTFORMAT "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
;

LOAD DATA INPATH '${hiveconf:input_directory}/part-*' INTO TABLE rts_api_error_log_staging;
