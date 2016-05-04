use real_time_scoring;
SET mapreduce.output.fileoutputformat.compress.codec=com.hadoop.compression.lzo.LzopCodec;
SET hive.exec.compress.output=true;
SET mapreduce.output.fileoutputformat.compress=true;

drop table if exists rts_email_contact_history_staging;


create table rts_email_contact_history_staging (
run_date string,
persist_date string,
topology string,
lid string,
eid string,
cust_event string,
success_flag string,
occasion_tag string,
purchase_occasion string,
businessUnit string,
subBusinessUnit string
)
row format delimited
fields terminated by '|'
lines terminated by '\n'
STORED AS INPUTFORMAT  "com.hadoop.mapred.DeprecatedLzoTextInputFormat"
OUTPUTFORMAT "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
;

LOAD DATA INPATH '${hiveconf:input_directory}/part-*' INTO TABLE rts_email_contact_history_staging;

;
