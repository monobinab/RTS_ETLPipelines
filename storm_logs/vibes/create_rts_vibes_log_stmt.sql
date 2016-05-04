use real_time_Scoring;
create table rts_vibes_log (
head_date string,
persist_date string,
topology string,
encrypted_lyl_id_no string,
success_flag string,
load_date string,
user_created string
)
PARTITIONED BY (Year INT, Month INT, Day INT)
row format delimited
fields terminated by '|'
lines terminated by '\n'
STORED AS INPUTFORMAT  "com.hadoop.mapred.DeprecatedLzoTextInputFormat"
OUTPUTFORMAT "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
;
