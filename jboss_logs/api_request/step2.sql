use real_time_scoring;
SET mapreduce.output.fileoutputformat.compress.codec=com.hadoop.compression.lzo.LzopCodec;
SET hive.exec.compress.output=true;
SET mapreduce.output.fileoutputformat.compress=true;
set avro.output.codec=snappy;


drop table if exists api_request_log_staging;


create table api_request_log_staging (
run_date string,
request_type string,
api_url string,
tags string,
session_id string,
request_level string,
lyl_id_no string,
client string
)
row format delimited
fields terminated by '|'
lines terminated by '\n'
STORED AS INPUTFORMAT  "com.hadoop.mapred.DeprecatedLzoTextInputFormat"
OUTPUTFORMAT "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
;

LOAD DATA INPATH '${hiveconf:input_directory}/part-*' INTO TABLE api_request_log_staging;

